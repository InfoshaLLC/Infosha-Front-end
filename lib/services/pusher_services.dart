import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/screens/feed/controller/feed_model.dart';
import 'package:infosha/screens/feed/model/feed_list_model.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:infosha/Controller/name_gender_storing_controller.dart';
// import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  late FeedModel _feedModel;
  String socketId = '';
  String? _lastEventType;
  DateTime? _lastEventTime;
  final nameAndGenderStoringController = Get.put(NameAndGenderStoringController());

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  bool _isManuallyDisconnected = false;
  bool _isReconnecting = false;
  Timer? _reconnectTimer;

  PusherService._internal();
  void setFeedModel(FeedModel feedModel) {
    _feedModel = feedModel;
  }

  Future<void> initPusher() async {
    try {
      await pusher.init(
        apiKey: "ad34db28ff33f52e4c16",
        cluster: "ap2",
        onConnectionStateChange: (currentState, previousState) async {
          debugPrint("Pusher connected: $previousState to $currentState");
          if (currentState == 'CONNECTED') {
            final socketId = await pusher.getSocketId();

            if (socketId == null || socketId.isEmpty) {
              debugPrint("❌ Socket ID is null or empty");
              return;
            }

            debugPrint("Socket ID after $currentState: $socketId");
            // Save the socket id in shared pref
            var prefs = await SharedPreferences.getInstance();
            prefs.setString("Pusher_Socket_ID", socketId);

            _stopReconnectLoop();
            return;
          }
          if (!_isManuallyDisconnected && (currentState == 'DISCONNECTED' || currentState == 'FAILED')) {
            _startReconnectLoop();
          }
        },
        onError: (message, code, e) {
          debugPrint("Pusher error: $message");

          if (!_isManuallyDisconnected) {
            _startReconnectLoop();
          }
        },
        // onAuthorizer: (channelName, socketId, options) async {
        //   final prefs = await SharedPreferences.getInstance();
        //   String? authSignature = prefs.getString('Pusher_Auth_Signature');
        //   debugPrint('Providing auth for $channelName: $authSignature');
        //   return {'auth': authSignature ?? ''};
        // },
        onAuthorizer: (channelName, socketId, options) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          final payload = {
            "channel_name": channelName,
            "socket_id": socketId,
          };

          final headers = {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          };

          debugPrint("Authorizing channel: $channelName with socketId: $socketId");

          final response = await http.post(
            Uri.parse("${ApiEndPoints.PUSHERURL}broadcasting/auth"),
            headers: headers,
            body: jsonEncode(payload),
          );
          if (response.statusCode == 200) {
            final body = jsonDecode(response.body);
            debugPrint("Auth response for $channelName: $body");
            return body;
          } else {
            debugPrint("Auth failed with status ${response.statusCode}: ${response.body}");
            return {'auth': ''};
          }
        },
      );
      _isManuallyDisconnected = false;
      await pusher.connect();
    } catch (e) {
      debugPrint("Pusher init error: $e");
      _startReconnectLoop();
    }
  }

  bool shouldProcessEvent(String type) {
    final now = DateTime.now();

    if (_lastEventType == type) {
      if (_lastEventTime != null && now.difference(_lastEventTime!) < Duration(seconds: 1)) {
        return false;
      }
    }

    _lastEventType = type;
    _lastEventTime = now;

    return true;
  }

  Future<void> subscribeToChannel(String channelName) async {
    debugPrint("Subscribe to private channel method called");
    final prefs = await SharedPreferences.getInstance();
    final socketId = prefs.getString("Pusher_Socket_ID");

    if (socketId == null || socketId.isEmpty) {
      debugPrint("❌ Cannot subscribe. socketId not ready.");
      return;
    }

    try {
      await pusher.subscribe(
        channelName: "private-client.$channelName",
        onEvent: (event) async {
          debugPrint('Event received on $channelName => ${event.data}');
          // _feedModel.fetchPosts();
          if (event.data != null) {
            final data = jsonDecode(event.data);

            if (!shouldProcessEvent(data["type"])) {
              debugPrint("Duplicate ${data["type"]} event blocked");
              return;
            }
            if (data["type"] == "feed_created") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            }
            if (data["type"] == "feed_deleted") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            }
            if (data["type"] == "feed_reaction" && data["feed_id"] != null) {
              int feedId = data["feed_id"];
              var feedList = _feedModel.feedListModel.data?.data;
              if (feedList == null) return;

              final index = feedList.indexWhere((item) => item.id == feedId);
              if (index != -1) {
                var feed = feedList[index];

                if (data["counts"]?["reactionCount"] != null) {
                  feed.totalReactionCount = data["counts"]["reactionCount"];
                }
                if (data["reaction_name"] != null) {
                  feed.reactionName = data["reaction_name"];
                }

                _feedModel.notifyListeners();
              }
            } else if (data["type"] == "reply") {
              int feedId = int.tryParse(data["feedId"].toString()) ?? -1;
              if (feedId == -1) return;

              var feedList = _feedModel.feedListModel.data?.data;
              if (feedList == null) return;

              final index = feedList.indexWhere((item) => item.id == feedId);
              if (index == -1) return;

              var feed = feedList[index];
              var eventData = data["data"];
              RepliesComment newComment = RepliesComment(
                id: eventData["id"],
                comment: eventData["comment"],
                profile: eventData["feed_owner"]?["avatar"],
                username: eventData["feed_owner"]?["username"],
                number: eventData["feed_owner"]?["number"],
                addedBy: eventData["feed_owner"]?["id"],
                createdAt: eventData["created_at"],
                isLocked: eventData["feed_owner"]?["is_locked"],
                feedCommentReplies: [],
              );

              feed.repliesComment ??= [];
              feed.repliesComment!.add(newComment);
              feed.totalRepliesComment = (feed.totalRepliesComment ?? 0) + 1;

              _feedModel.notifyListeners();
              debugPrint("Updated comment count for feed $feedId -> ${feed.totalRepliesComment}");
            } else if (data["type"] == "comment_reply") {
              int feedId = int.tryParse(data["feed_reply_id"].toString()) ?? -1;
              if (feedId == -1) return;

              var feedList = _feedModel.feedListModel.data?.data;
              if (feedList == null) return;

              // Find which feed has this comment
              for (var feed in feedList) {
                for (var comment in feed.repliesComment ?? []) {
                  if (comment.id.toString() == data["feed_reply_id"].toString()) {
                    comment.feedCommentReplies ??= [];

                    FeedCommentReplies newReply = FeedCommentReplies(
                      id: data["reply_id"],
                      comment: data["comment"],
                      feedUserId: data["user"]["id"],
                      username: data["user"]["name"] ?? "User",
                      profile: data["user"]["avatar"] ?? "",
                      createdAt: data["created_at"],
                      isLocked: data["user"]["is_locked"],
                    );

                    comment.feedCommentReplies!.add(newReply);
                    _feedModel.notifyListeners();

                    debugPrint("--------------- Added reply to comment ${comment.id} in feed ${feed.id}");
                    return;
                  }
                }
              }
            }

            if (data["type"] == "nickname_updated") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "profile_photo_updated") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "profession_update") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "bio_update") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "social_update") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "review_created") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "review_updated") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            } else if (data["type"] == "nickname_and_profile_photo_updated") {
              await Future.delayed(const Duration(seconds: 1));
              await _feedModel.fetchPosts(isEvent: true);
            }
          }
        },
        onSubscriptionSucceeded: (data) async {
          debugPrint('Subscribed successfully to $channelName');

          await Future.delayed(const Duration(seconds: 1));
          // try {
          //   final userViewModel = Get.put(UserViewModel());
          //   await userViewModel.fetchDeviceContacts();
          //   debugPrint("Contacts fetched successfully after Pusher subscription");
          // } catch (e) {
          //   debugPrint("Error fetching contacts after Pusher subscription: $e");
          // }
        },
        onSubscriptionError: (error) {
          debugPrint('Subscription error on $channelName: $error');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Error subscribing to $channelName: $e');
      debugPrint('$stackTrace');
    }
  }

  /// Disconnect safely
  Future<void> disconnect() async {
    _isManuallyDisconnected = true;
    _stopReconnectLoop();
    await pusher.disconnect();
    debugPrint("Pusher manually disconnected");
  }

  void _startReconnectLoop() {
    if (_isReconnecting) return;
    _isReconnecting = true;

    debugPrint("Pusher attempting to reconnect...");

    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (pusher.connectionState == 'CONNECTED' ||
          pusher.connectionState == 'CONNECTING' ||
          pusher.connectionState == 'RECONNECTING') {
        return;
      }

      debugPrint("Pusher reconnect attempt...");
      try {
        await pusher.connect();
      } catch (e) {
        debugPrint("Reconnect failed: $e");
      }
    });
  }

  void _stopReconnectLoop() {
    if (_reconnectTimer != null) {
      _reconnectTimer!.cancel();
      _reconnectTimer = null;
    }
    _isReconnecting = false;
  }
}
