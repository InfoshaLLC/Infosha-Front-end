// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:flutter/material.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

/* class UserModel {
  final bool success;
  final String message;
  Data data;

  UserModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
} */

class UserModel {
  int? id;
  String? username;
  String? token;
  String? number;
  String? counryCode;
  String? type;
  String? fcmToken;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  int? isContactChange;
  int? countContactNumber;
  bool? likeStatus;
  bool? dislikeStatus;
  List<GetNickName>? getNickName;
  List<GetProfiles>? getProfiles;
  List<FollowersList>? followers;
  List<GetGender>? getGender;
  List<GetAddress>? getAddress;
  List<GetAddress>? getAddressOther;
  List<GetEmail>? getEmail;
  List<GetDob>? getDob;
  List<GetSocial>? getSocial;
  List<GetSocial>? getSocialOther;

  int? followersCount;
  int? visitsCount;
  int? followingCount;
  int? mutualFollowers;
  int? mutualFollowing;
  List<ReviewList>? reviewList;
  int? contactsCount;
  dynamic likeCount;
  dynamic dislikeCount;
  dynamic average_review;
  dynamic averageRating;
  dynamic number_of_review_user;
  bool? is_subscription_active;
  bool? isLocked;
  String? active_subscription_plan_name;
  dynamic contact_id;
  Profile? profile;
  dynamic num_of_review_user;
  dynamic avg_review;

  UserModel(
      {this.id,
      this.username,
      this.number,
      this.counryCode,
      this.type,
      this.fcmToken,
      this.token,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.isContactChange,
      this.countContactNumber,
      this.likeStatus,
      this.dislikeStatus,
      this.getNickName,
      this.getProfiles,
      this.getAddress,
      this.getAddressOther,
      this.getEmail,
      this.getDob,
      this.getGender,
      this.getSocial,
      this.getSocialOther,
      this.followers,
      this.followersCount,
      this.visitsCount,
      this.followingCount,
      this.mutualFollowers,
      this.mutualFollowing,
      this.reviewList,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.average_review,
      this.averageRating,
      this.number_of_review_user,
      this.is_subscription_active,
      this.isLocked,
      this.active_subscription_plan_name,
      this.contact_id,
      this.avg_review,
      this.num_of_review_user,
      this.profile});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    counryCode = json['country_code'];
    type = json['type'];
    token = json['token'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isContactChange = json['is_contact_change'];
    countContactNumber = json['count_contact_number'];
    likeStatus = json['like_status'];
    dislikeStatus = json['dislike_status'];
    if (json['get_nick_name'] != null) {
      getNickName = <GetNickName>[];
      json['get_nick_name'].forEach((v) {
        getNickName!.add(GetNickName.fromJson(v));
      });
    }
    if (json['get_profiles'] != null) {
      getProfiles = <GetProfiles>[];
      json['get_profiles'].forEach((v) {
        getProfiles!.add(new GetProfiles.fromJson(v));
      });
    }
    if (json['followers_list'] != null) {
      followers = <FollowersList>[];
      json['followers_list'].forEach((v) {
        followers!.add(FollowersList.fromJson(v));
      });
    }
    if (json['get_dob'] != null) {
      getDob = <GetDob>[];
      json['get_dob'].forEach((v) {
        getDob!.add(GetDob.fromJson(v));
      });
    }

    followersCount = json['followers_count'];
    visitsCount = json['visits_count'];
    followingCount = json['following_count'];
    mutualFollowers = json['mutual_followers'];
    mutualFollowing = json['mutual_following'];
    followingCount = json['following_count'];
    if (json['review_list'] != null) {
      reviewList = <ReviewList>[];
      json['review_list'].forEach((v) {
        reviewList!.add(ReviewList.fromJson(v));
      });
    }
    if (json['get_address'] != null) {
      getAddress = <GetAddress>[];
      json['get_address'].forEach((v) {
        getAddress!.add(GetAddress.fromJson(v));
      });
    }
    if (json['get_address'] != null) {
      getAddressOther = <GetAddress>[];
      json['get_address'].forEach((v) {
        getAddressOther!.add(GetAddress.fromJson(v));
      });
    }
    if (json['get_email'] != null) {
      getEmail = <GetEmail>[];
      json['get_email'].forEach((v) {
        getEmail!.add(new GetEmail.fromJson(v));
      });
    }

    if (json['review_list'] != null) {
      reviewList = <ReviewList>[];
      json['review_list'].forEach((v) {
        reviewList!.add(ReviewList.fromJson(v));
      });
    }
    if (json['get_gender'] != null) {
      getGender = <GetGender>[];
      json['get_gender'].forEach((v) {
        getGender!.add(GetGender.fromJson(v));
      });
    }
    if (json['get_social'] != null) {
      getSocial = <GetSocial>[];
      json['get_social'].forEach((v) {
        getSocial!.add(GetSocial.fromJson(v));
      });
    }
    if (json['get_social'] != null) {
      getSocialOther = <GetSocial>[];
      json['get_social'].forEach((v) {
        getSocialOther!.add(GetSocial.fromJson(v));
      });
    }
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    average_review = json['average_review'];
    averageRating = json['average_rating'];
    is_subscription_active = json['is_subscription_active'];
    isLocked = json['is_locked'];
    active_subscription_plan_name = json['active_subscription_plan_name'];
    number_of_review_user = json['number_of_review_user'];
    contact_id = json['contact_id'];
    num_of_review_user = json['num_of_review_user'];
    avg_review = json['avg_review'];
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['country_code'] = counryCode;
    data['type'] = type;
    data['token'] = token;
    data['fcm_token'] = fcmToken;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_contact_change'] = isContactChange;
    data['count_contact_number'] = countContactNumber;
    data['like_status'] = likeStatus;
    data['dislike_status'] = dislikeStatus;
    if (getNickName != null) {
      data['get_nick_name'] = getNickName!.map((v) => v.toJson()).toList();
    }
    if (getDob != null) {
      data['get_dob'] = getDob!.map((v) => v.toJson()).toList();
    }
    if (getProfiles != null) {
      data['get_profiles'] = getProfiles!.map((v) => v.toJson()).toList();
    }
    if (followers != null) {
      data['followers_list'] = followers!.map((v) => v).toList();
    }
    if (getDob != null) {
      data['get_dob'] = getDob!.map((v) => v.toJson()).toList();
    }
    if (getAddress != null) {
      data['get_address'] = getAddress!.map((v) => v.toJson()).toList();
    }
    if (getAddressOther != null) {
      data['get_address'] = getAddressOther!.map((v) => v.toJson()).toList();
    }
    if (getEmail != null) {
      data['get_email'] = getEmail!.map((v) => v.toJson()).toList();
    }
    if (getSocial != null) {
      data['get_social'] = getSocial!.map((v) => v.toJson()).toList();
    }
    if (getSocialOther != null) {
      data['get_social'] = getSocialOther!.map((v) => v.toJson()).toList();
    }
    if (followers != null) {
      data['followers'] = followers!.map((v) => v.toJson()).toList();
    }
    if (reviewList != null) {
      data['review_list'] = reviewList!.map((v) => v.toJson()).toList();
    }
    if (getGender != null) {
      data['get_gender'] = getGender!.map((v) => v.toJson()).toList();
    }

    data['followers_count'] = followersCount;
    data['visits_count'] = visitsCount;
    data['following_count'] = followingCount;
    data['mutual_followers'] = mutualFollowers;
    data['mutual_following'] = mutualFollowing;
    if (reviewList != null) {
      data['review_list'] = reviewList!.map((v) => v.toJson()).toList();
    }
    data['contacts_count'] = contactsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['average_review'] = average_review;
    data['average_rating'] = averageRating;
    data['number_of_review_user'] = number_of_review_user;
    data['is_subscription_active'] = is_subscription_active;
    data['is_locked'] = isLocked;
    data['active_subscription_plan_name'] = active_subscription_plan_name;
    data['contact_id'] = contact_id;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class GetProfiles {
  String? addedBy;
  String? profile;

  GetProfiles({this.addedBy, this.profile});

  GetProfiles.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['profile'] = profile;
    return data;
  }
}

class Profile {
  final int id;
  final dynamic userId;
  final dynamic profile;
  String? gender;
  dynamic dob;
  dynamic profession;
  String location;
  String address;
  String email;
  String facebookId;
  String instagramId;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  String? profileUrl;
  String? country;
  String? state;
  String? city;

  Profile({
    required this.id,
    required this.userId,
    required this.profile,
    required this.gender,
    required this.dob,
    required this.profession,
    required this.location,
    required this.address,
    required this.email,
    required this.facebookId,
    required this.instagramId,
    // required this.createdAt,
    // required this.updatedAt,
    required this.profileUrl,
    required this.country,
    required this.state,
    required this.city,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? "",
        profile: json["profile"] ?? "",
        gender: json["gender"] ?? "",
        dob: json["dob"] ?? "",
        profession: json["profession"] ?? "",
        location: json["location"] ?? "",
        address: json["address"] ?? "",
        email: json["email"] ?? "",
        facebookId: json["facebook_id"] ?? "",
        instagramId: json["instagram_id"] ?? "",
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        profileUrl: json["profile_url"],
        country: json['country'],
        state: json['state'],
        city: json['city'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "profile": profile,
        "gender": gender,
        "dob": dob,
        "profession": profession,
        "location": location,
        "address": address,
        "email": email,
        "facebook_id": facebookId,
        "instagram_id": instagramId,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "profile_url": profileUrl,
        'country': country,
        'state': state,
        'city': city,
      };
}

class FollowersList {
  FollowersList({
    required this.id,
    required this.userId,
    required this.followerId,
    required this.user,
  });
  late final int id;
  late final int userId;
  late final int? followerId;
  late final User user;

  FollowersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    followerId = json['follower_id'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['follower_id'] = followerId;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  int? id;
  String? username;
  String? number;
  String? countryCode;
  String? type;
  String? fcmToken;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  dynamic isContactChange;
  dynamic countContactNumber;
  dynamic followersCount;
  dynamic followingCount;
  dynamic visitsCount;
  dynamic contactsCount;
  dynamic likeCount;
  dynamic dislikeCount;
  dynamic averageRating;
  dynamic number_of_review_user;
  dynamic is_subscription_active;
  dynamic active_subscription_plan_name;
  Profile? profile;

  User(
      {this.id,
      this.username,
      this.number,
      this.countryCode,
      this.type,
      this.fcmToken,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.isContactChange,
      this.countContactNumber,
      this.followersCount,
      this.followingCount,
      this.visitsCount,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.averageRating,
      this.number_of_review_user,
      this.is_subscription_active,
      this.active_subscription_plan_name,
      this.profile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    countryCode = json['country_code'];
    type = json['type'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isContactChange = json['is_contact_change'];
    countContactNumber = json['count_contact_number'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    visitsCount = json['visits_count'];
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    averageRating = json['average_rating'];
    number_of_review_user = json['number_of_review_user'];
    is_subscription_active = json['is_subscription_active'];
    active_subscription_plan_name = json['active_subscription'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['country_code'] = countryCode;
    data['type'] = type;
    data['fcm_token'] = fcmToken;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_contact_change'] = isContactChange;
    data['count_contact_number'] = countContactNumber;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['visits_count'] = visitsCount;
    data['contacts_count'] = contactsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['average_rating'] = averageRating;
    data['number_of_review_user'] = number_of_review_user;
    data['is_subscription_active'] = is_subscription_active;
    data['active_subscription'] = active_subscription_plan_name;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? followerId;

  Pivot({this.userId, this.followerId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    followerId = json['follower_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = userId;
    data['follower_id'] = followerId;
    return data;
  }
}

class Following {
  int? id;
  String? username;
  String? number;
  String? type;
  String? fcmToken;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  int? isContactChange;
  int? countContactNumber;
  int? followersCount;
  int? followingCount;
  int? contactsCount;
  dynamic likeCount;
  dynamic dislikeCount;
  Pivot? pivot;
  Profile? profile;

  Following(
      {this.id,
      this.username,
      this.number,
      this.type,
      this.fcmToken,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.isContactChange,
      this.countContactNumber,
      this.followersCount,
      this.followingCount,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.pivot,
      this.profile});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    type = json['type'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isContactChange = json['is_contact_change'];
    countContactNumber = json['count_contact_number'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['type'] = type;
    data['fcm_token'] = fcmToken;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_contact_change'] = isContactChange;
    data['count_contact_number'] = countContactNumber;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['contacts_count'] = contactsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

/* class GetNickName {
  dynamic name;
  String? addedBy;
  int? userId;

  GetNickName({this.name, this.addedBy, this.userId});

  GetNickName.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    addedBy = json['added_by'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['added_by'] = addedBy;
    data['userId'] = userId;
    return data;
  }
}
 */
class ReviewList {
  int? id;
  int? userId;
  int? reviewerId;
  String? rating;
  String? nicknames;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? repliesCommentCount;
  int? totalReactionCount;
  int? likeCount;
  int? dislikeCount;
  bool? isLiked;
  bool? isDisliked;
  bool? isReaction;
  String? reactionName;
  String? imageUrl;
  String? profileUrl;
  String? user_nickname;
  dynamic is_deleted_comment;
  List<RepliesComment>? repliesComment;
  bool isExpanded = false;
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  ReviewList(
      {this.id,
      this.userId,
      this.reviewerId,
      this.rating,
      this.nicknames,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.repliesCommentCount,
      this.totalReactionCount,
      this.likeCount,
      this.dislikeCount,
      this.isLiked,
      this.isDisliked,
      this.isReaction,
      this.reactionName,
      this.imageUrl,
      this.profileUrl,
      this.repliesComment,
      this.user_nickname,
      this.is_deleted_comment,
      this.isExpanded = false,
      this.formKey});

  ReviewList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reviewerId = json['reviewer_id'];
    rating = json['rating'];
    nicknames = json['nicknames'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    repliesCommentCount = json['replies_comment_count'];
    totalReactionCount = json['total_reaction_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    isLiked = json['is_liked'];
    isDisliked = json['is_disliked'];
    isReaction = json['is_reaction'];
    reactionName = json['reaction_name'];
    imageUrl = json['image_url'];
    profileUrl = json['profile_image'];
    user_nickname = json['user_nickname'];
    is_deleted_comment = json['is_deleted_comment'];
    if (json['replies_comment'] != null) {
      repliesComment = <RepliesComment>[];
      json['replies_comment'].forEach((v) {
        repliesComment!.add(RepliesComment.fromJson(v));
      });
    }
    isExpanded = false;
    formKey = GlobalKey<FormState>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['reviewer_id'] = reviewerId;
    data['rating'] = rating;
    data['nicknames'] = nicknames;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['replies_comment_count'] = repliesCommentCount;
    data['total_reaction_count'] = totalReactionCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    data['is_reaction'] = isReaction;
    data['reaction_name'] = reactionName;
    data['image_url'] = imageUrl;
    data['profile_image'] = profileUrl;
    data['user_nickname'] = user_nickname;
    data['is_deleted_comment'] = is_deleted_comment;
    if (repliesComment != null) {
      data['replies_comment'] = repliesComment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RepliesComment {
  int? id;
  String? username;
  String? comment;
  int? commentUserId;
  int? commentId;
  String? createdAt;
  String? updatedAt;
  String? profileUrl;
  dynamic is_deleted_comment_reply;

  RepliesComment(
      {this.id,
      this.username,
      this.comment,
      this.commentUserId,
      this.commentId,
      this.createdAt,
      this.updatedAt,
      this.profileUrl,
      this.is_deleted_comment_reply});

  RepliesComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    comment = json['comment'];
    commentUserId = json['comment_user_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileUrl = json['profile_image'];
    is_deleted_comment_reply = json['is_deleted_comment_reply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['comment'] = comment;
    data['comment_user_id'] = commentUserId;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profile_image'] = profileUrl;
    data['is_deleted_comment_reply'] = is_deleted_comment_reply;
    return data;
  }
}
