import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/dialog_overlay.dart';
import 'package:phone_state/phone_state.dart';
import 'package:infosha/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:infosha/services/pusher_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infosha/Controller/locale_controller.dart';
import 'package:infosha/screens/hscreen/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/translation/translation_service.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:infosha/screens/feed/component/view_feed.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:infosha/screens/ProfileScreen/visitor_screen.dart';
import 'package:infosha/searchscreens/controller/search_model.dart';
import 'package:infosha/followerscreen/controller/following_model.dart';
import 'package:infosha/followerscreen/controller/topfollowers_model.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:infosha/followerscreen/controller/followers_controller.dart';
import 'package:infosha/screens/allKingsGods/controller/god_king_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:infosha/screens/subscription/controller/subscription_model.dart';

bool isArabic = false;
bool isMainDark = true;
String userid = "null";
String initialDynamic = "null";
String initialRoute = "/";
final pusherService = PusherService();

/// used for local notifcation
const AndroidNotificationChannel channel =
    AndroidNotificationChannel("id", "name", description: "Description", importance: Importance.high, playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

///used for call popup
///entry point of dialog
@pragma("vm:entry-point")
Future<void> overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.red,
      home: TrueCallerOverlay(),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  print('Intialize service');
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
  await pusherService.initPusher();
}

/// used to start background process and entry point of background process
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print('On start method');
  // DartPluginRegistrant.ensureInitialized();

  PhoneState.stream.listen((event) {
    print('Event phone state : $event');
    // if (event != null) {
    handlePhoneState(event);
    // }
  });

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Infosha",
      content: "Infosha works in background to detect call",
    );
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

/// used to handle call popup show and close
void handlePhoneState(PhoneState event) async {
  print('Handle phone state : $event');
  final phoneNumber = event.number;
  final status = event.status;

  print('Event Status in handle phone state : $status');

  if (phoneNumber == null) {
    return;
  }

  switch (status) {
    case PhoneStateStatus.CALL_INCOMING:
      print("===event.number===${phoneNumber}");
      await handleCallIncoming(phoneNumber);
      break;

    case PhoneStateStatus.CALL_STARTED:
      await handleCallStarted(phoneNumber);
      break;

    case PhoneStateStatus.CALL_ENDED:
      print('Call ended method should be called after 4 seconds');
      Future.delayed(const Duration(seconds: 4), () async {
        await handleCallEnded();
      });
      break;

    default:
      break;
  }
}

/// used when incoming call detected
Future<void> handleCallIncoming(String number) async {
  print("==number==${number}");
  await Future.delayed(const Duration(milliseconds: 100));
  await SystemAlertWindow.showSystemWindow(
    height: 450,
    prefMode: SystemWindowPrefMode.OVERLAY,
    gravity: SystemWindowGravity.CENTER,
    layoutParamFlags: [SystemWindowFlags.FLAG_NOT_FOCUSABLE],
  );
  await SystemAlertWindow.sendMessageToOverlay(number);
}

/// used to hide dialog and call ended
Future<void> handleCallEnded() async {
  print('Show system alert window');
  await SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
  await SystemAlertWindow.sendMessageToOverlay("null");
}

///used when started outgoing call
Future<void> handleCallStarted(String number) async {
  print('Show system alert window for call started');
  await Future.delayed(const Duration(milliseconds: 100));
  await SystemAlertWindow.showSystemWindow(
    height: 450,
    prefMode: SystemWindowPrefMode.OVERLAY,
    gravity: SystemWindowGravity.CENTER,
    layoutParamFlags: [SystemWindowFlags.FLAG_NOT_FOCUSABLE],
  );
  await SystemAlertWindow.sendMessageToOverlay(number);
}

const platform = MethodChannel('call_detecting');

Future<void> main() async {
  userid = "null";
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      : await Firebase.initializeApp(name: 'Infosha-app', options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  requestPermission();

  /* Disabling linkstream for now ----
  linkStream.listen((String? link) async {
    print("link1 ==> ${link}");
    if (link != null) {
      try {
        if (link.contains("feed")) {
          initialRoute = "/viewpost";
          initialDynamic = link.toString();

          Get.to(() => ViewFeed(postUrl: initialDynamic));
        }
      } catch (e) {
        rethrow;
      }
    } else {
      initialRoute = "/";
    }
  }, onError: (err) {
    print('Error handling deep link: $err');
  });

  */

  // platform.setMethodCallHandler((call) async {
  //   print("setMethodCallHandler ==> ${call.arguments}");
  //   if (call.arguments != null) {
  //     if (call.method == 'incomingCall' || call.method == 'outgoingCall') {
  //       if (await FlutterBackgroundService().isRunning() == false) {
  //         await initializeService();
  //         await FlutterBackgroundService().startService();
  //       }
  //     }
  //   }
  // });

  await initializeService();
  await FlutterBackgroundService().startService();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notificationicon');

  DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(/* onDidReceiveLocalNotification: onDidReceiveLocalNotification */);

  LinuxInitializationSettings initializationSettingsLinux =
      const LinuxInitializationSettings(defaultActionName: 'Open notification');

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, linux: initializationSettingsLinux);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  /* if (kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  }; */

  // initialRoute = await handleDeepLink(initialRoute);
  print("initialRoute runapp ==> $initialRoute");

  MobileAds.instance
      .updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['36383AAECA0448EFC6DFC030F3A7B80C']));

  runApp(MyApp(initialRoute: initialRoute));
}

// Future<String> handleDeepLink(String initialRoute) async {
//   try {
//     String? initialLink = await getInitialLink();
//     if (initialLink != null) {
//       // The app was opened through a deep link
//       print("opended through deep link $initialLink");
//       initialDynamic = initialLink.toString();
//       initialRoute = "/viewpost";
//       return "/viewpost";
//     } else {
//       // The app was opened without a deep link
//       print("opended noramaly");
//       initialRoute = "/";
//       return "/";
//     }
//   } on PlatformException {
//     // Error occurred while getting the initial link
//     return "/";
//   }
// }

/// used to ask permission to show notification
void requestPermission() async {
  bool check = await Permission.notification.isGranted;

  if (check == false) {
    Permission.notification.request();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }
}

///redirect when app is opended
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  // Get.to(() => ViewProfileScreen(id: userid));
  Get.to(() => VisitorScreen(id: Params.Id));
}

void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
  // Get.to(() => ViewProfileScreen(id: userid));
  Get.to(() => VisitorScreen(id: Params.Id));
}

class MyApp extends StatefulWidget {
  String initialRoute;
  MyApp({required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _receivePort = ReceivePort();
  SendPort? homePort;
  static const String _kPortNameHome = 'UI';
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  // Create an instance of the FeedModel to be able to access it in didChangeAppLifecycleState
  final FeedModel _feedModel = FeedModel();
  final PusherService pusherService = PusherService();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    CallDetection.startCallDetection();
    pusherService.setFeedModel(_feedModel);
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );

    _receivePort.listen((message) {
      log("message from OVERLAY: $message");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        RemoteNotification remoteNotification = message.notification!;
        if (message.notification != null) {
          print('Message also contained a notification: ${message.data}');
          userid = message.data["user_id"] ?? "";
        }

        flutterLocalNotificationsPlugin.show(
          0,
          remoteNotification.title,
          remoteNotification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, '',
              channelDescription: channel.description,
              playSound: true,
              icon: 'notificationicon',
              largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              // subText: channel.name,
              color: baseColor,
              groupKey: channel.id,
              setAsGroupSummary: true,
              groupAlertBehavior: GroupAlertBehavior.children,
            ),
          ),
          // payload: action
        );
      }
    });

    ///redirect when app is in foreground
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      // Get.to(() => ViewProfileScreen(id: event.data["user_id"]));
      Get.to(() => VisitorScreen(id: Params.Id));
    });
    // checkNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TranslationService translationService = TranslationService();

    return getx.SimpleBuilder(builder: (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
          ChangeNotifierProvider<SearchModel>(create: (_) => SearchModel()),
          ChangeNotifierProvider.value(value: _feedModel),
          ChangeNotifierProvider<SubscriptionModel>(create: (_) => SubscriptionModel()),
          ChangeNotifierProvider<TopFollowVisitorModel>(create: (_) => TopFollowVisitorModel()),
          ChangeNotifierProvider<AllKingGodModel>(create: (_) => AllKingGodModel()),
          ChangeNotifierProvider<FollowingModel>(create: (_) => FollowingModel()),
          ChangeNotifierProvider<FollowersController>(create: (_) => FollowersController()),
        ],
        child: ConnectivityAppWrapper(
          app: ResponsiveSizer(builder: (context, orientation, screenType) {
            return GetMaterialApp(
              title: AppName,
              theme: ThemeData(
                  useMaterial3: false,
                  textTheme: TextTheme(
                    bodyMedium: GoogleFonts.workSans(),
                    bodyLarge: GoogleFonts.workSans(),
                    titleMedium: GoogleFonts.workSans(),
                    titleSmall: GoogleFonts.workSans(),
                    labelLarge: GoogleFonts.workSans(),
                    bodySmall: GoogleFonts.workSans(),
                    labelSmall: GoogleFonts.workSans(),
                    displayLarge: GoogleFonts.workSans(),
                  ),
                  primaryColor: whiteColor,
                  appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.black))),
              themeMode: ThemeMode.system,
              /* initialRoute: widget.initialRoute,
              routes: <String, WidgetBuilder>{
                '/': (context) => const splashScreen(),
                '/viewpost': (context) => const HomeScreen()
              }, */
              navigatorKey: navigatorKey,
              home: const splashScreen(),
              fallbackLocale: LocalizationService.fallbackLocale,
              translations: translationService,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale("en"),
                Locale('ar'),
                Locale('fr'),
              ],
              locale: const Locale('en'),
            );
          }),
        ),
      );
    });
  }

  static const MethodChannel _platform = MethodChannel('com.ktech.infosha/service');

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print("*********************************************************");
    if (state == AppLifecycleState.paused) {
      // The app is in the background. Release memory.
      debugPrint("App is paused. Releasing memory-intensive resources.");

      // 1. Keep feed data in memory (don't clear — show cached data on resume)
      // _feedModel.clearFeedData();
      // _feedModel.page = 1;

      // 2. DO NOT clear Flutter's image cache on pause.
      //    Wiping the cache forces every visible feed image to redecode on
      //    resume, which causes the feed to flash/jump and looks like the
      //    scroll position skipped. The OS will reclaim memory if it needs to.
      // PaintingBinding.instance.imageCache.clear();
      // PaintingBinding.instance.imageCache.clearLiveImages();
      debugPrint("Image cache preserved across pause/resume.");

      if (_feedModel.isHomeScreenVisible) {
        // Already on the home screen, just refresh the data.
        debugPrint("Already on home screen. Refreshing feed.");
        // _feedModel.fetchPosts();
      } else if (_feedModel.isProfileScreenVisible) {
        // If on the profile screen, navigate back to home.
        debugPrint("Resuming from ProfileScreen. Navigating to home screen.");
        // navigatorKey.currentState?.pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => const HomeScreen()),
        //   (Route<dynamic> route) => false,
        // );
      } else {
        // For all other screens, do nothing and let the user stay where they were.
        debugPrint("Resuming from another screen. No navigation action taken.");
      }
    } else if (state == AppLifecycleState.resumed) {
      // The app has returned to the foreground.
      // DO NOT call _feedModel.fetchPosts() here. HomeScreen owns the resume
      // refresh: its own didChangeAppLifecycleState restarts the 2-min auto-
      // refresh timer, which uses checkForNewPosts() / applyNewPosts() to
      // update the feed without replacing the list or resetting scroll.
      // Calling fetchPosts(isEvent: true) here additionally would replace the
      // entire feedListModel and visibly skip the user's scroll position.
      debugPrint("App is resumed. Feed refresh delegated to HomeScreen.");
    }
  }
}

class CallDetection {
  static const MethodChannel _channel = MethodChannel('com.ktech.infosha/call_detection');

  static Future<void> startCallDetection() async {
    _channel.setMethodCallHandler((call) async {
      print("call ==> ${call.method}");
    });
  }
}
