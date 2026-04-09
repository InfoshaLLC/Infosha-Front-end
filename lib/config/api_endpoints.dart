// ignore_for_file: constant_identifier_names

class ApiEndPoints {
  static const geoSMSAPIKey = "d2def8d9435625eacae0d3b047dd576b4383f6fcf0721e567747476e02925b17";
  // static const geoSMSAPIKey =
  //     "e9f026eb582c8f55e1aaa776d947805e42c550e0e92d193e18c1b5056b84402c";
  static const SecretKey = 'Basic MzA2OTo4YTA2M2M3ZS01M2U3LTQ3YmYtOWUxYS00OTY2ZmUyZjhhYWY=';

  //STAGING BASEURL
  // static const BASE_URL = "http://143.0.1.97/api/";
  // static const BASE_URL = "http://163.53.177.63:8030/api/";

  //LIVE BASEURL
  // static const BASE_URL = "http://infoshadev.bimjl.com/api/";
  static const BASE_URL = "https://infosha.org/api/";
  // static const BASE_URL = "https://x1c4bd7k.infosha.org/api/";
  // static const PUSHERURL = "http://infoshadev.bimjl.com/";
  static const PUSHERURL = "https://infosha.org/";

  // static const BASE_URL = "https://f11b0dd4875e.ngrok-free.app/api/";
  // static const PUSHERURL = "https://f11b0dd4875e.ngrok-free.app/";

  // static const PUSHERURL = BASE_URL=="https://infosha.org/api/"?"https://infosha.org/broadcasting/auth":"https://infoshadev.bimjl.com/broadcasting/auth";
  static const REGISTERUSER = "${BASE_URL}register";
  static const LOGINUSER = "${BASE_URL}login";
  static const BIOUPDATE = "${BASE_URL}my-profile-bio-update";
  static const SOCIALUPDATE = "${BASE_URL}my-profile-social-update";
  static const UploadContacts = "${BASE_URL}contact/store";
  static const GETCONTACTs = "${BASE_URL}contacts";
  static const GETUSERBYID = "${BASE_URL}get-user-by-id?";
  static const ADDLIKE = "${BASE_URL}add-like";
  static const ADDDISLIKE = "${BASE_URL}add-dislike";

  ///Added By us
  static const SOCIALUPDATEOTHERUSER = "${BASE_URL}other-profile-bio-update";
  static const follow = "${BASE_URL}follow";
  static const unfollow = "${BASE_URL}unfollow";
  static const checkNumberExist = "${BASE_URL}check-number-exist";
  static const newNumber = "${BASE_URL}new-number";
  static const addReview = "${BASE_URL}add-review";
  static const addCommentReply = "${BASE_URL}add-comment-replies";
  static const professionList = "${BASE_URL}profession/list";
  static const professionUpdate = "${BASE_URL}other-profile-profession-update";
  static const professionByOtherUser = "${BASE_URL}profession-by-other-user";
  static const likeReview = "${BASE_URL}add-comment-like";
  static const disLikeReview = "${BASE_URL}add-comment-dislike";
  static const addReaction = "${BASE_URL}add-comment-reaction";
  static const otherSocialUpdate = "${BASE_URL}other-profile-social-update";
  static const searchUser = "${BASE_URL}search-user";
  static const searchUserV2 = "${BASE_URL}v2/search-user";
  static const addFeed = "${BASE_URL}add-feed";
  static const feed = "${BASE_URL}v2/feed";
  static const addFeedLike = "${BASE_URL}add-feed-like";
  static const addFeedDislike = "${BASE_URL}add-feed-dislike";
  static const reportFeed = "${BASE_URL}report-feed";
  static const deleteReview = "${BASE_URL}delete-review";
  static const addFeedReplies = "${BASE_URL}add-feed-replies";
  static const blockUser = "${BASE_URL}block-user";
  static const reportUser = "${BASE_URL}report-user";
  static const topFollowers = "${BASE_URL}top-followers";
  static const topFollowersV2 = "${BASE_URL}v2/top-followers";
  static const topVisitors = "${BASE_URL}top-visitors";
  static const topVisitorsV2 = "${BASE_URL}v2/top-visitors";
  static const deleteFeed = "${BASE_URL}delete-feed";
  static const updateFeed = "${BASE_URL}update-feed";
  static const submitPlan = "${BASE_URL}submit-plan";
  static const getPlan = "${BASE_URL}get-plans";
  static const getReactionOfComment = "${BASE_URL}get-reactions-user-info-by-comment";
  static const profileRating = "${BASE_URL}profile-rating";
  static const deactiveUser = "${BASE_URL}deactive-user";
  static const visitorList = "${BASE_URL}visitor/list";
  static const cancelSubscription = "${BASE_URL}cancel-subscription";
  static const deleteReplyComment = "${BASE_URL}delete-comment-replay";
  static const userSubscriptionList = "${BASE_URL}user/subscription/list";
  static const setNewPassword = "${BASE_URL}set-new-password";
  static const viewUnregisterdProfiel = "${BASE_URL}end-user-profile";
  static const viewUnregisterdProfielSearch = "${BASE_URL}other-end-user-profile";
  static const followingList = "${BASE_URL}following/list";
  static const updateContact = "${BASE_URL}contact/update-contact";
  static const editUnregisterUser = "${BASE_URL}unregister-profile-bio-update";
  static const checkRegisterNumber = "${BASE_URL}check-number-is-register";
  static const visitorUnregisterList = "${BASE_URL}end-user-visitor-list";
  static const incomingCallData = "${BASE_URL}user/incoming";
  static const addProfession = "${BASE_URL}add-profession";
  static const userVoting = "${BASE_URL}list-user-upvote-downvote";
  static const spamUser = "${BASE_URL}spam-call";
  static const sendOTP = "${BASE_URL}otp-send";
  static const verifyOTP = "${BASE_URL}otp-verify";
  static const followersList = "${BASE_URL}followers-list-by-number";
  static const getNicknameList = "${BASE_URL}get-nickname-from-number";
  static const lockProfile = "${BASE_URL}lock-profile";
  static const feedVoteList = "${BASE_URL}like-dislike-users-info-by-feed";
  static const reviewVoteList = "${BASE_URL}like-dislike-users-info-by-comment";
  static const addFeedReaction = "${BASE_URL}add-feed-reaction";
  static const getFeedReactionList = "${BASE_URL}get-reactions-user-info-by-feed";
  static const addReviewReply = "${BASE_URL}add-feed-comment-replies";
  static const categoryList = "${BASE_URL}category-list";
  static const updateRating = "${BASE_URL}v2/update-rating";
  static const mutualFollowers = "${BASE_URL}v2/mutual-followers";
  static const mutualFollowings = "${BASE_URL}v2/mutual-followings";
  static const profileRatingV2 = "${BASE_URL}v2/profile-rating";
  static const mutualFollowersEndUsers = "${BASE_URL}v2/end-user-mutual-followers";

  static const broadcastingPusherAuth = "${BASE_URL}broadcasting/auth";
}
