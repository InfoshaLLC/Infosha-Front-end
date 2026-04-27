import 'dart:ffi';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/views/app_icons.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosha/config/api_endpoints.dart';
import 'package:infosha/Controller/models/vote_status_mode.dart';
import 'package:infosha/screens/feed/model/feed_list_model.dart';
import 'package:infosha/screens/feed/model/feed_vote_model.dart';
import 'package:infosha/screens/feed/model/feed_reaction_model.dart';

class FeedModel extends ChangeNotifier {
  static const _feedCacheKey = 'cached_feed_json';

  bool isUploading = false;
  bool isLoading = true;
  bool isViewLoading = false;
  bool isAddComment = false;
  bool isLoadingMorePost = false;
  bool isReactionOfComment = false;
  bool isHomeScreenVisible = false;
  bool isProfileScreenVisible = false;
  bool isOtherProfileScreenVisible = false;
  bool hasNewPosts = false;
  DateTime? _lastFetchStartTime;
  FeedListModel? _cachedNewFeed;
  int page = 1;
  bool hasMore = true;
  static const int perPage = 10;

  FeedListModel feedListModel = FeedListModel();
  FeedListModel viewFeedListModel = FeedListModel();
  FeedVoteModel feedVoteModel = FeedVoteModel();
  FeedReactionModel feedReactionModel = FeedReactionModel();

  /// Saves the current feed JSON to disk for instant startup.
  Future<void> _saveFeedToCache(String rawJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_feedCacheKey, rawJson);
      debugPrint('Feed cache saved (${rawJson.length} chars)');
    } catch (e) {
      debugPrint('Failed to save feed cache: $e');
    }
  }

  /// Loads cached feed from disk. Returns true if cache was loaded.
  Future<bool> loadCachedFeed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_feedCacheKey);
      if (cached != null && cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        feedListModel = FeedListModel.fromJson(decoded);
        if (feedListModel.data?.data != null && feedListModel.data!.data!.isNotEmpty) {
          isLoading = false;
          notifyListeners();
          debugPrint('Feed loaded from cache (${feedListModel.data!.data!.length} items)');
          return true;
        }
      }
    } catch (e) {
      debugPrint('Failed to load feed cache: $e');
    }
    return false;
  }

  Future addPost(String? description, XFile? file) async {
    try {
      isUploading = true;
      notifyListeners();
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.addFeed));

      request.fields.addAll({"description": description!.isEmpty ? '' : description});
      request.headers.addAll(headers);
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("addPost ==> $decodeData");

      if (response.statusCode == 200) {
        fetchPosts();
        Get.back();
        Get.back();
        UIHelper.showMySnak(title: "Upload", message: "Feed is uploaded successfully", isError: false);
        isUploading = false;
        notifyListeners();
      } else {
        UIHelper.showMySnak(title: "Upload", message: decodeData["message"], isError: true);
        isUploading = false;
        notifyListeners();
      }
    } catch (e) {
      isUploading = false;
      notifyListeners();
    }
  }

  /// Clears the list of posts to free up memory.
  void clearFeedData() {
    if (feedListModel.data?.data != null) {
      feedListModel.data!.data!.clear();
      // We don't call notifyListeners() because we don't need to update the UI
      // while the app is in the background. The data will be refetched on resume.
      debugPrint("Feed data cleared from memory.");
    }
  }

  void clearViewFeedData() {
    viewFeedListModel = FeedListModel();
    debugPrint("View feed data cleared from memory.");
    // No need to notify listeners as this is called on dispose.
  }

  void setHasNewPosts(bool value) {
    hasNewPosts = value;
    notifyListeners();
  }

  /// Returns the ID of the newest feed currently loaded, or null.
  int? get _currentTopFeedId {
    final items = feedListModel.data?.data;
    if (items != null && items.isNotEmpty) return items.first.id;
    return null;
  }

  /// Fetches page 1 and checks if the top feed ID differs from the current one.
  /// Caches the result so the banner tap can apply it instantly.
  /// Returns true if there are new posts.
  Future<bool> checkForNewPosts() async {
    if (Params.UserToken == "") return false;
    try {
      var headers = {'Authorization': 'Bearer ${Params.UserToken}'};
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.feed}?page=1"));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(result.body);
        final newModel = FeedListModel.fromJson(decodeData);
        final newTopId = newModel.data?.data?.isNotEmpty == true ? newModel.data!.data!.first.id : null;
        final oldTopId = _currentTopFeedId;
        debugPrint('checkForNewPosts: oldTopId=$oldTopId, newTopId=$newTopId');
        if (newTopId != null && oldTopId != null && newTopId != oldTopId) {
          _cachedNewFeed = newModel;
          return true;
        }
      }
    } catch (e) {
      debugPrint('checkForNewPosts error: $e');
    }
    return false;
  }

  /// Applies cached new-posts data instantly (no network call).
  /// Falls back to fetchPosts if cache is empty.
  void applyNewPosts() {
    if (_cachedNewFeed != null) {
      debugPrint('applyNewPosts: using cached feed data (instant)');
      feedListModel = _cachedNewFeed!;
      _cachedNewFeed = null;
      isLoading = false;
      hasNewPosts = false;
      notifyListeners();
      // Persist to disk for next app launch
      _saveFeedToCache(jsonEncode(feedListModel.toJson()));
    } else {
      debugPrint('applyNewPosts: no cache, falling back to fetchPosts');
      fetchPosts(isEvent: true);
    }
  }

  Future fetchPosts({bool isEvent = false}) async {
    if (Params.UserToken != "") {
      // Debounce: skip if a fetch started less than 2 seconds ago
      final now = DateTime.now();
      if (_lastFetchStartTime != null &&
          now.difference(_lastFetchStartTime!) < const Duration(seconds: 2)) {
        debugPrint("fetchPosts skipped — debounce (too soon)");
        return;
      }
      _lastFetchStartTime = now;
      try {
        if (isEvent == false) {
          isLoading = true;
          print("isLoading set to true");
        }
        // Reset pagination state on a fresh first-page fetch
        page = 1;
        hasMore = true;
        print("Fetch Posts Called");
        notifyListeners();
        var headers = {
          'Authorization': 'Bearer ${Params.UserToken}',
        };
        var request = http.Request('GET', Uri.parse("${ApiEndPoints.feed}?page=1&per_page=$perPage"));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        var result = await http.Response.fromStream(response);
        final decodeData = jsonDecode(result.body);
        print("fetchPosts ==> $decodeData");

        if (response.statusCode == 200) {
          feedListModel = FeedListModel.fromJson(decodeData);
          hasMore = feedListModel.data?.nextPageUrl != null;
          isLoading = false;
          notifyListeners();
          // Save to disk cache for instant startup
          _saveFeedToCache(result.body);
          // Spec step 2: as soon as page 1 arrives, IMMEDIATELY fire page 2
          // in the background. Fire-and-forget — errors swallowed inside.
          prefetchNext();
        } else {
          isLoading = false;
          notifyListeners();
        }
      } catch (e) {
        debugPrint("-----------------------------DEBUG ERROR $e");
        isLoading = false;
        _lastFetchStartTime = null; // Allow immediate retry on error
        notifyListeners();
      }
    }
  }

  Future fetchSinglePosts(String id) async {
    try {
      isViewLoading = true;
      notifyListeners();
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.feed}?page=1&feed_id=$id"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("fetchPosts ==> $decodeData");

      if (response.statusCode == 200) {
        viewFeedListModel = FeedListModel.fromJson(decodeData);

        isViewLoading = false;
        notifyListeners();
      } else {
        isViewLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isViewLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Public entry point used by the scroll listener (and the initial-load
  /// path) to silently fetch the NEXT page in the background. Idempotent —
  /// concurrent calls are dropped via [isLoadingMorePost]. Always loads at
  /// most one page ahead, so memory stays bounded regardless of how fast
  /// the user scrolls.
  ///
  /// Spec mapping:
  ///  - Step 2: called right after page 1 arrives → fetches page 2.
  ///  - Step 6: called by scroll listener when user nears end of loaded
  ///    data → fetches the next page (3, 4, 5, …) in background.
  void prefetchNext() {
    // Don't await — fire-and-forget so the caller (UI scroll callback) is
    // never blocked by network latency.
    // ignore: discarded_futures
    _prefetchNextPage();
  }

  Future<void> _prefetchNextPage() async {
    if (!hasMore || isLoadingMorePost) return;
    isLoadingMorePost = true;
    page += 1;
    notifyListeners();
    final attemptedPage = page;
    try {
      await fetchMorePosts(attemptedPage);
    } catch (e) {
      // Roll back so the next scroll trigger re-attempts the same page
      page = (attemptedPage - 1).clamp(1, 1 << 30);
      debugPrint('Prefetch failed for page $attemptedPage: $e');
    } finally {
      isLoadingMorePost = false;
      notifyListeners();
    }
  }

  Future fetchMorePosts(int page) async {
    if (!hasMore) return;
    try {
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.feed}?page=$page&per_page=$perPage"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("fetchMorePosts ==> $decodeData");

      if (response.statusCode == 200) {
        FeedListModel feed = FeedListModel.fromJson(decodeData);

        if (feed.data != null && feed.data!.data != null) {
          feedListModel.data!.data!.addAll(feed.data!.data!);
          // Keep paginator metadata fresh so hasMore reflects the new page
          feedListModel.data!.currentPage = feed.data!.currentPage;
          feedListModel.data!.nextPageUrl = feed.data!.nextPageUrl;
          feedListModel.data!.lastPage = feed.data!.lastPage;
          hasMore = feed.data!.nextPageUrl != null;
          notifyListeners();
        } else {
          hasMore = false;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future fetchPostsData(String id) async {
    isAddComment = true;
    notifyListeners();
    try {
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse("${ApiEndPoints.feed}?page=1&feed_id=$id"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        FeedListModel data = FeedListModel.fromJson(decodeData);

        isAddComment = false;
        notifyListeners();
        return data.data!.data![0];
      } else {
        isAddComment = false;
        notifyListeners();
        return FeedListData();
      }
    } catch (e) {
      isAddComment = false;
      notifyListeners();
      rethrow;
      // return FeedListData();
    }
  }

  Future<VoteStatusModel> likeDislikeFeed(String feedId, bool isLike) async {
    // int status = -1;
    VoteStatusModel status = VoteStatusModel(status: -1, likeCount: 0, disLikeCount: 0);
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(isLike ? ApiEndPoints.addFeedLike : ApiEndPoints.addFeedDislike));
      request.body = json.encode({"feed_id": feedId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        print("likeDislikeReview ==> $decodeData");
        if (decodeData["message"].toString().contains("Your dislike added successfully in comment")) {
          // status = 1;
          status = VoteStatusModel(
              status: 1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else if (decodeData["message"].toString().contains("Your dislike removed successfully in comment")) {
          // status = -1;
          status = VoteStatusModel(
              status: -1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else if (decodeData["message"].toString().contains("Your like removed successfully in comment.")) {
          // status = -1;
          status = VoteStatusModel(
              status: -1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else if (decodeData["message"].toString().contains("Your like added successfully in comment")) {
          // status = 0;
          status = VoteStatusModel(
              status: 0, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        } else {
          // status = -1;
          status = VoteStatusModel(
              status: -1, likeCount: decodeData["data"]["like"], disLikeCount: decodeData["data"]["dislike"]);
        }

        return status;
      } else {
        print(response.reasonPhrase);
        return status;
      }
    } catch (e) {
      return status;
    }
  }

  Future feedReport(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.reportFeed));
      request.body = json.encode({"feed_report_user_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      print("feedReport ==> $decodeData");
      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Report", message: 'User reported successfully', isError: false);
      } else {
        UIHelper.showMySnak(title: "Report", message: 'This user is already reported', isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future addFeedReply(String feedId, String comment) async {
    try {
      isAddComment = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addFeedReplies));
      request.body = json.encode({"feed_id": feedId, "comment": comment});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      print("addFeedReply ==> $decodeData ==> $feedId");
      if (response.statusCode == 200) {
        isAddComment = false;
        notifyListeners();
      } else {
        UIHelper.showMySnak(title: "Error", message: decodeData["message"], isError: true);

        isAddComment = false;
        notifyListeners();
      }
    } catch (e) {
      isAddComment = false;
      notifyListeners();

      // return [];
    }
  }

  /// used to add review reply
  Future addReviewReply(String feedId, String comment) async {
    try {
      isAddComment = true;
      notifyListeners();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addReviewReply));
      request.body = json.encode({"feed_reply_id": feedId, "comment": comment});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      print("addReviewReply ==> $decodeData ==> $feedId");
      if (response.statusCode == 200) {
        isAddComment = false;
        notifyListeners();
      } else {
        UIHelper.showMySnak(title: "Error", message: decodeData["message"], isError: true);

        isAddComment = false;
        notifyListeners();
      }
    } catch (e) {
      isAddComment = false;
      notifyListeners();

      // return [];
    }
  }

  Future blockUser(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.blockUser));
      request.body = json.encode({"block_user_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      print("block user ==> ${decodeData}");

      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Block", message: 'User blocked successfully', isError: false);
        fetchPosts();
      } else {
        UIHelper.showMySnak(title: "Block", message: decodeData["message"], isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteFeed(String id) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.deleteFeed));
      request.body = json.encode({"feed_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("deleteFeed ==> $decodeData");
      if (response.statusCode == 200) {
        UIHelper.showMySnak(title: "Delete", message: 'Feed successfully deleted', isError: true);
        fetchPosts();
      } else {
        UIHelper.showMySnak(title: "Delete", message: decodeData["message"], isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future editPost(String? description, XFile? file, String id) async {
    try {
      isUploading = true;
      notifyListeners();
      var headers = {
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.MultipartRequest('POST', Uri.parse(ApiEndPoints.updateFeed));

      request.fields.addAll({"description": description!.isEmpty ? '' : description, 'feed_id': id});
      request.headers.addAll(headers);
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("editPost ==> $decodeData");

      if (response.statusCode == 200) {
        fetchPosts();

        Get.back();
        UIHelper.showMySnak(title: "Edit", message: "Feed is updated successfully", isError: false);
        isUploading = false;
        notifyListeners();
      } else {
        UIHelper.showMySnak(title: "Edit", message: decodeData["message"], isError: true);
        isUploading = false;
        notifyListeners();
      }
    } catch (e) {
      isUploading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to get list of user who give up/down vote
  Future getUserList(String id, bool isLike) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      final uri = Uri.parse(ApiEndPoints.feedVoteList)
          .replace(queryParameters: {"feed_id": id, "user_type": isLike ? "like" : "dislike"});
      var request = http.Request('GET', uri);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      print("getUserList ==> $decodeData");

      if (response.statusCode == 200) {
        feedVoteModel = FeedVoteModel.fromJson(decodeData);
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  ///used to react on feed
  Future<int> addFeedReaction(String commentId, String name) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiEndPoints.addFeedReaction));
      request.body = json.encode({"feed_id": commentId, "reaction_name": name});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);

      if (response.statusCode == 200) {
        debugPrint("addReaction ===> $commentId $decodeData");
        return decodeData["data"]["reactionCount"];
      } else {
        return decodeData["data"]["reactionCount"];
      }
    } catch (e) {
      return 0;
    }
  }

  /// used to get reaction list of any review
  Future getReactionOfFeed(String id) async {
    try {
      isReactionOfComment = true;
      notifyListeners();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Params.UserToken}',
      };
      var request = http.Request('GET', Uri.parse(ApiEndPoints.getFeedReactionList));
      request.body = json.encode({"feed_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var result = await http.Response.fromStream(response);
      final decodeData = jsonDecode(result.body);
      debugPrint("getReactionOfFeed ==> $decodeData");

      if (response.statusCode == 200) {
        feedReactionModel = FeedReactionModel.fromJson(decodeData);
        isReactionOfComment = false;
        notifyListeners();
      } else {
        isReactionOfComment = false;
        notifyListeners();
      }
    } catch (e) {
      isReactionOfComment = false;
      notifyListeners();
      rethrow;
    }
  }

  /// used to get icon path from id
  String convertReactionIdToPath(int id) {
    var path = APPICONS.reactionpng;
    switch (id) {
      case -1:
        path = path;
        break;
      case 0:
        path = APPICONS.lovepng;
        break;
      case 1:
        path = APPICONS.wowpng;
        break;
      case 2:
        path = APPICONS.lolpng;
        break;
      case 3:
        path = APPICONS.sadpng;
        break;
      case 4:
        path = APPICONS.angrypng;
        break;
      default:
    }
    return path;
  }

  String convertReactionIdToPathNew(int id) {
    var path = APPICONS.reactionpng;
    switch (id) {
      case -1:
        path = path;
        break;
      case 2:
        path = APPICONS.lovepng;
        break;
      case 4:
        path = APPICONS.wowpng;
        break;
      case 5:
        path = APPICONS.angrypng;
        break;
      case 6:
        path = APPICONS.sadpng;
        break;
      default:
    }
    return path;
  }
}
