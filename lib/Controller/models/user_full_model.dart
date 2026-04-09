// To parse this JSON data, do
//
//     final userFullModel = userFullModelFromJson(jsonString);

// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:infosha/screens/viewUnregistered/model/unregistered_user_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'user_model.dart';

UserFullModel userFullModelFromJson(String str) => UserFullModel.fromJson(json.decode(str));

String userFullModelToJson(UserFullModel data) => json.encode(data.toJson());

class UserFullModel {
  bool? success;
  String? message;
  Data? data;

  UserFullModel({this.success, this.message, this.data});

  UserFullModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

/* class GetNickName {
  String? name;
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
} */

class Data {
  int? id;
  String? username;
  String? number;
  String? countryCode;
  String? type;
  String? fcmToken;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  int? isContactChange;
  int? countContactNumber;
  Null? braintreeCustomerId;
  bool? likeStatus;
  bool? dislikeStatus;
  List<GetNickName>? getNickName;
  List<GetDob>? getDob;
  List<GetAddress>? getAddress;
  List<GetAddress>? getAddressOther;
  List<GetEmail>? getEmail;
  List<GetProfile>? getProfile;
  List<Followers>? followers;
  List<ReviewList>? reviewList;
  List<GetGender>? getGender;
  List<GetSocial>? getSocial;
  List<GetSocial>? getSocialOther;

  dynamic followersCount;
  dynamic followingCount;
  dynamic visitsCount;
  dynamic contactsCount;
  dynamic likeCount;
  dynamic dislikeCount;
  dynamic averageRating;
  dynamic number_of_review_user;
  bool? is_subscription_active;
  bool? isLocked;
  String? active_subscription_plan_name;
  Profile? profile;
  List<ProfileMany>? profileMany;
  dynamic num_of_review_user;
  dynamic avg_review;
  int? mutualFollowers;
  int? mutualFollowings;

  Data(
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
      this.braintreeCustomerId,
      this.likeStatus,
      this.dislikeStatus,
      this.getNickName,
      this.getDob,
      this.getAddress,
      this.getAddressOther,
      this.getEmail,
      this.getProfile,
      this.getGender,
      this.getSocial,
      this.getSocialOther,
      this.followers,
      this.reviewList,
      this.followersCount,
      this.followingCount,
      this.visitsCount,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.averageRating,
      this.number_of_review_user,
      this.is_subscription_active,
      this.isLocked,
      this.active_subscription_plan_name,
      this.profile,
      this.avg_review,
      this.num_of_review_user,
      this.mutualFollowers,
      this.mutualFollowings,
      this.profileMany});

  Data.fromJson(Map<String, dynamic> json) {
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
    mutualFollowers = json['mutual_followers'];
    mutualFollowings = json['mutual_followings'];
    countContactNumber = json['count_contact_number'];
    braintreeCustomerId = json['braintree_customer_id'];
    likeStatus = json['like_status'];
    dislikeStatus = json['dislike_status'];
    if (json['get_nick_name'] != null) {
      getNickName = <GetNickName>[];
      json['get_nick_name'].forEach((v) {
        getNickName!.add(GetNickName.fromJson(v));
      });
    }
    if (json['get_dob'] != null) {
      getDob = <GetDob>[];
      json['get_dob'].forEach((v) {
        getDob!.add(GetDob.fromJson(v));
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
      print("==getAddressOther===${getAddressOther!.length}");
    }
    if (json['get_email'] != null) {
      getEmail = <GetEmail>[];
      json['get_email'].forEach((v) {
        getEmail!.add(new GetEmail.fromJson(v));
      });
    }
    if (json['get_profiles'] != null) {
      getProfile = <GetProfile>[];
      json['get_profiles'].forEach((v) {
        getProfile!.add(new GetProfile.fromJson(v));
      });
    }
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(Followers.fromJson(v));
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
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    visitsCount = json['visits_count'];
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    averageRating = json['average_rating'];
    number_of_review_user = json['number_of_review_user'];
    is_subscription_active = json['is_subscription_active'];
    isLocked = json['is_locked'];
    active_subscription_plan_name = json['active_subscription_plan_name'];
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    num_of_review_user = json['num_of_review_user'];
    avg_review = json['avg_review'];
    if (json['profile_many'] != null) {
      profileMany = <ProfileMany>[];
      json['profile_many'].forEach((v) {
        profileMany!.add(new ProfileMany.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['braintree_customer_id'] = braintreeCustomerId;
    data['like_status'] = likeStatus;
    data['mutual_followers'] = mutualFollowers;
    data['mutual_followings'] = mutualFollowings;
    data['dislike_status'] = dislikeStatus;
    if (getNickName != null) {
      data['get_nick_name'] = getNickName!.map((v) => v).toList();
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
    if (getProfile != null) {
      data['get_profiles'] = getProfile!.map((v) => v.toJson()).toList();
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
    if (getSocial != null) {
      data['get_social'] = getSocial!.map((v) => v.toJson()).toList();
    }
    if (getSocialOther != null) {
      data['get_social'] = getSocialOther!.map((v) => v.toJson()).toList();
    }
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['visits_count'] = visitsCount;
    data['contacts_count'] = contactsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['average_rating'] = averageRating;
    data['number_of_review_user'] = number_of_review_user;
    data['is_subscription_active'] = is_subscription_active;
    data['is_locked'] = isLocked;
    data['active_subscription_plan_name'] = active_subscription_plan_name;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (profileMany != null) {
      data['profile_many'] = profileMany!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAddress {
  String? addedBy;
  Address? address;

  GetAddress({this.addedBy, this.address});

  GetAddress.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Followers {
  int? id;
  String? username;
  String? number;
  String? countryCode;
  String? type;
  dynamic fcmToken;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  int? isContactChange;
  int? countContactNumber;
  dynamic braintreeCustomerId;
  int? followersCount;
  int? followingCount;
  int? contactsCount;
  dynamic likeCount;
  dynamic dislikeCount;
  dynamic averageRating;
  Pivot? pivot;
  Profile? profile;
  dynamic is_subscription_active;
  dynamic active_subscription_plan_name;

  Followers(
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
      this.braintreeCustomerId,
      this.followersCount,
      this.followingCount,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.averageRating,
      this.pivot,
      this.profile,
      this.is_subscription_active,
      this.active_subscription_plan_name});

  Followers.fromJson(Map<String, dynamic> json) {
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
    braintreeCustomerId = json['braintree_customer_id'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    averageRating = json['average_rating'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    is_subscription_active = json['is_subscription_active'];
    active_subscription_plan_name = json['active_subscription_plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['braintree_customer_id'] = braintreeCustomerId;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['contacts_count'] = contactsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['average_rating'] = averageRating;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['is_subscription_active'] = is_subscription_active;
    data['active_subscription_plan_name'] = active_subscription_plan_name;
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

/* class Profile {
  int? id;
  int? userId;
  Null? addedBy;
  String? nickname;
  Null? profile;
  String? gender;
  String? dob;
  Null? profession;
  Null? location;
  String? address;
  String? email;
  String? facebookId;
  String? instagramId;
  String? createdAt;
  String? updatedAt;
  String? country;
  String? state;
  String? city;
  String? profileUrl;

  Profile(
      {this.id,
      this.userId,
      this.addedBy,
      this.nickname,
      this.profile,
      this.gender,
      this.dob,
      this.profession,
      this.location,
      this.address,
      this.email,
      this.facebookId,
      this.instagramId,
      this.createdAt,
      this.updatedAt,
      this.country,
      this.state,
      this.city,
      this.profileUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addedBy = json['added_by'];
    nickname = json['nickname'];
    profile = json['profile'];
    gender = json['gender'];
    dob = json['dob'];
    profession = json['profession'];
    location = json['location'];
    address = json['address'];
    email = json['email'];
    facebookId = json['facebook_id'];
    instagramId = json['instagram_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    profileUrl = json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['added_by'] = addedBy;
    data['nickname'] = nickname;
    data['profile'] = profile;
    data['gender'] = gender;
    data['dob'] = dob;
    data['profession'] = profession;
    data['location'] = location;
    data['address'] = address;
    data['email'] = email;
    data['facebook_id'] = facebookId;
    data['instagram_id'] = instagramId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['profile_url'] = profileUrl;
    return data;
  }
}
 */
/* class ReviewList {
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
      this.repliesComment,
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
    if (repliesComment != null) {
      data['replies_comment'] = repliesComment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
 */
class RepliesComment {
  int? id;
  String? comment;
  int? commentUserId;
  int? commentId;
  String? createdAt;
  String? updatedAt;
  String? username;

  RepliesComment({this.id, this.comment, this.commentUserId, this.commentId, this.createdAt, this.updatedAt, this.username});

  RepliesComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    commentUserId = json['comment_user_id'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['comment'] = comment;
    data['comment_user_id'] = commentUserId;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    return data;
  }
}

class ProfileMany {
  int? id;
  int? addedBy;
  String? nickname;
  String? profile;
  String? gender;
  String? dob;
  String? profession;
  String? location;
  String? address;
  String? email;
  String? facebookId;
  String? instagramId;
  String? createdAt;
  String? updatedAt;
  String? country;
  String? state;
  String? city;
  String? profileUrl;
  AddedUser? addedUser;

  ProfileMany(
      {this.id,
      this.addedBy,
      this.nickname,
      this.profile,
      this.gender,
      this.dob,
      this.profession,
      this.location,
      this.address,
      this.email,
      this.facebookId,
      this.instagramId,
      this.createdAt,
      this.updatedAt,
      this.country,
      this.state,
      this.city,
      this.profileUrl,
      this.addedUser});

  ProfileMany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    nickname = json['nickname'];
    profile = json['profile'];
    gender = json['gender'];
    dob = json['dob'];
    profession = json['profession'];
    location = json['location'];
    address = json['address'];
    email = json['email'];
    facebookId = json['facebook_id'];
    instagramId = json['instagram_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    profileUrl = json['profile_url'];
    addedUser = json['added_user'] != null ? new AddedUser.fromJson(json['added_user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['added_by'] = addedBy;
    data['nickname'] = nickname;
    data['profile'] = profile;
    data['gender'] = gender;
    data['dob'] = dob;
    data['profession'] = profession;
    data['location'] = location;
    data['address'] = address;
    data['email'] = email;
    data['facebook_id'] = facebookId;
    data['instagram_id'] = instagramId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['profile_url'] = profileUrl;
    if (addedUser != null) {
      data['added_user'] = addedUser!.toJson();
    }
    return data;
  }
}

class AddedUser {
  int? id;
  String? username;
  String? number;
  dynamic averageRating;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  AdddedProfile? profile;
  dynamic activeSubscription;

  AddedUser(
      {this.id,
      this.username,
      this.number,
      this.averageRating,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.profile,
      this.activeSubscription});

  AddedUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    averageRating = json['average_rating'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    profile = json['profile'] != null ? new AdddedProfile.fromJson(json['profile']) : null;
    activeSubscription = json['active_subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['average_rating'] = averageRating;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['active_subscription'] = activeSubscription;
    return data;
  }
}

class AdddedProfile {
  dynamic profession;
  String? profileUrl;

  AdddedProfile({this.profession, this.profileUrl});

  AdddedProfile.fromJson(Map<String, dynamic> json) {
    profession = json['profession'];
    profileUrl = json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profession'] = profession;
    data['profile_url'] = profileUrl;
    return data;
  }
}
