import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/screens/otherprofile/add_review_dialog.dart';
import 'package:infosha/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class CallNumberView extends StatefulWidget{
  var phoneNumber;
  var color;
  var size;
  var userID;
  var name;
  Function? callBack;
  CallNumberView({Key? key, this.phoneNumber, this.color, this.size, this.callBack,required this.name, required this.userID})
      : super(key: key);

  @override
  State<CallNumberView> createState() => _CallNumberViewState();
}

class _CallNumberViewState extends State<CallNumberView> with WidgetsBindingObserver {
  bool isFromCall = false;
  static const platform = MethodChannel('custom_notifications');
  String notificationStatus = "No callback received";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if(widget.callBack != null) {
        if(isFromCall) {
          // await widget.callBack!();
          // showNotification();
          isFromCall = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final call = Uri.parse('tel:${widget.phoneNumber}');
        if (await canLaunchUrl(call)) {
          isFromCall = true;
          launchUrl(call);
        } else {
          throw 'Could not launch $call';
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.call_outlined,
            color: widget.color ?? Colors.white,
            size: widget.size,
          ),
          const SizedBox(width: 5),
          Text(
            widget.phoneNumber,
            style: TextStyle(
              color: widget.color ?? Colors.white,
              fontSize: widget.size ?? 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showNotification() async {
    try {
      await platform.invokeMethod('showCustomNotification', {
        'param1': 'Rate ${widget.name}!',
        'param2': 'How was your experience?',
        'param3': widget.userID,
      });
    } on PlatformException catch (e) {
      print("Failed to show notification: ${e.message}");
    }
  }

  void listenForCallbacks() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "ratingCallback") {
        final Map<dynamic, dynamic> data = call.arguments;
        setState(() {
          notificationStatus =
          "Rating: ${data['rating']}, Anonymous: ${data['isAnonymous']}, UserId: ${data['userId']}";
        });
      }
    });
  }
}
