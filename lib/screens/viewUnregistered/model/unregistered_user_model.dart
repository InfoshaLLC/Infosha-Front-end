import 'package:flutter/material.dart';
import 'package:infosha/Controller/models/user_model.dart';

class UnregisteredUserModel {
  bool? success;
  String? message;
  Data? data;

  UnregisteredUserModel({this.success, this.message, this.data});

  UnregisteredUserModel.fromJson(Map<String, dynamic> json) {
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

class GetNickName {
  String? addedBy;
  String? name;

  GetNickName({this.addedBy, this.name});

  GetNickName.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['name'] = name;

    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? contactId;
  String? code;
  String? number;
  String? name;
  dynamic photo;
  // List<dynamic>? email;
  String? email;
  dynamic profession;
  dynamic dob;
  // List<dynamic>? social;
  dynamic gender;
  Address? address;
  String? createdAt;
  String? updatedAt;
  List<GetNickName>? getNickName;
  List<GetDob>? getDob;
  List<GetAddress>? getAddress;
  List<GetAddress>? getAddressCountr;
  List<GetEmail>? getEmail;
  List<GetProfile>? getProfile;
  List<GetProfession>? getProfession;
  List<GetGender>? getGender;
  List<GetSocial>? getSocial;
  List<GetSocial>? getSocialOther;
  List<Followers>? followers;
  bool? likeStatus;
  bool? dislikeStatus;
  dynamic likeCount;
  dynamic dislikeCount;
  int? followersCount;
  int? followingCount;
  int? visitsCount;
  bool? isFriend;
  dynamic numberOfReviewUser;
  dynamic averageReview;
  dynamic num_of_review_user;
  dynamic avg_review;
  List<ReviewList>? reviews;
  int? mutualFollowers;
  int? mutualFollowings;

  Data(
      {this.id,
      this.userId,
      this.contactId,
      this.code,
      this.number,
      this.name,
      this.photo,
      this.email,
      this.profession,
      this.dob,
      // this.social,
      this.gender,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.getNickName,
      this.getDob,
      this.getAddress,
      this.getAddressCountr,
      this.getEmail,
      this.getProfile,
      this.getProfession,
      this.getGender,
      this.getSocial,
      this.getSocialOther,
      this.followers,
      this.mutualFollowings,
      this.mutualFollowers,
      this.likeStatus,
      this.dislikeStatus,
      this.likeCount,
      this.dislikeCount,
      this.followersCount,
      this.followingCount,
      this.visitsCount,
      this.isFriend,
      this.numberOfReviewUser,
      this.averageReview,
      this.avg_review,
      this.num_of_review_user,
      this.reviews});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    contactId = json['contact_id'];
    code = json['code'];
    number = json['number'];
    name = json['name'];
    photo = json['photo'];
    email = json['email'];
    mutualFollowers = json['mutual_followers'];
    mutualFollowings = json['mutual_followings'];
    /* if (json['email'] != null) {
      email = <dynamic>[];
      json['email'].forEach((v) {
        email!.add(v);
      });
    } */
    profession = json['profession'];
    dob = json['dob'];
    /* if (json['social'] != null) {
      social = <dynamic>[];
      json['social'].forEach((v) {
        social!.add(v);
      });
    } */
    gender = json['gender'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
      getAddressCountr = <GetAddress>[];
      json['get_address'].forEach((v) {
        getAddressCountr!.add(GetAddress.fromJson(v));
      });
    }
    if (json['get_email'] != null) {
      getEmail = <GetEmail>[];
      json['get_email'].forEach((v) {
        getEmail!.add(GetEmail.fromJson(v));
      });
    }
    if (json['get_profile'] != null) {
      getProfile = <GetProfile>[];
      json['get_profile'].forEach((v) {
        getProfile!.add(GetProfile.fromJson(v));
      });
    }
    if (json['get_profession'] != null) {
      getProfession = <GetProfession>[];
      json['get_profession'].forEach((v) {
        getProfession!.add(GetProfession.fromJson(v));
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
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(Followers.fromJson(v));
      });
    }
    likeStatus = json['like_status'];
    dislikeStatus = json['dislike_status'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    visitsCount = json['visits_count'];
    isFriend = json['is_friend'];
    numberOfReviewUser = json['number_of_review_user'];
    averageReview = json['average_review'];
    num_of_review_user = json['num_of_review_user'];
    avg_review = json['avg_review'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    if (json['reviews'] != null) {
      reviews = <ReviewList>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['contact_id'] = contactId;
    data['code'] = code;
    data['number'] = number;
    data['name'] = name;
    data['photo'] = photo;
    data['email'] = email;
    /*  if (email != null) {
      data['email'] = email!.map((v) => v.toJson()).toList();
    } */
    data['profession'] = profession;
    data['dob'] = dob;
    /*  if (social != null) {
      data['social'] = social!.map((v) => v.toJson()).toList();
    } */
    data['gender'] = gender;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['mutual_followers'] = mutualFollowers;
    data['mutual_followings'] = mutualFollowings;
    if (getNickName != null) {
      data['get_nick_name'] = getNickName!.map((v) => v.toJson()).toList();
    }
    if (getDob != null) {
      data['get_dob'] = getDob!.map((v) => v.toJson()).toList();
    }
    if (getAddress != null) {
      data['get_address'] = getAddress!.map((v) => v.toJson()).toList();
    }
    if (getAddressCountr != null) {
      data['get_address'] = getAddressCountr!.map((v) => v.toJson()).toList();
    }
    if (getEmail != null) {
      data['get_email'] = getEmail!.map((v) => v.toJson()).toList();
    }
    if (getProfile != null) {
      data['get_profile'] = getProfile!.map((v) => v.toJson()).toList();
    }
    if (followers != null) {
      data['followers'] = followers!.map((v) => v.toJson()).toList();
    }
    if (getProfession != null) {
      data['get_profession'] = getProfession!.map((v) => v.toJson()).toList();
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
    data['like_status'] = likeStatus;
    data['dislike_status'] = dislikeStatus;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['visits_count'] = visitsCount;
    data['is_friend'] = isFriend;
    data['number_of_review_user'] = numberOfReviewUser;
    data['average_review'] = averageReview;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetGender {
  String? addedBy;
  String? dob;

  GetGender({this.addedBy, this.dob});

  GetGender.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['dob'] = dob;
    return data;
  }
}

class GetProfession {
  String? addedBy;
  String? profession;

  GetProfession({this.addedBy, this.profession});

  GetProfession.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    profession = json['profession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['profession'] = profession;
    return data;
  }
}

class GetSocial {
  String? addedBy;
  Social? social;

  GetSocial({this.addedBy, this.social});

  GetSocial.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    social = json['social'] != null ? Social.fromJson(json['social']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    if (social != null) {
      data['social'] = social!.toJson();
    }
    return data;
  }
}

class Social {
  String? facebookId;
  String? instagramId;

  Social({this.facebookId, this.instagramId});

  Social.fromJson(Map<String, dynamic> json) {
    facebookId = json['facebook_id'];
    instagramId = json['instagram_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['facebook_id'] = facebookId;
    data['instagram_id'] = instagramId;
    return data;
  }
}

class GetDob {
  String? addedBy;
  String? dob;

  GetDob({this.addedBy, this.dob});

  GetDob.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['dob'] = dob;
    return data;
  }
}

class GetAddress {
  String? addedBy;
  Address? address;

  GetAddress({this.addedBy, this.address});

  GetAddress.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    // address = json['address'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    // data['address'] = address;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  dynamic address;
  dynamic street;
  String? city;
  String? state;
  dynamic postalCode;
  String? country;
  dynamic isoCountry;
  dynamic subAdminArea;
  dynamic subLocality;

  Address({this.address, this.street, this.city, this.state, this.postalCode, this.country, this.isoCountry, this.subAdminArea, this.subLocality});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    isoCountry = json['isoCountry'];
    subAdminArea = json['subAdminArea'];
    subLocality = json['subLocality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = address;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['isoCountry'] = isoCountry;
    data['subAdminArea'] = subAdminArea;
    data['subLocality'] = subLocality;
    return data;
  }
}

class Followers {
  int? id;
  String? username;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  dynamic averageReview;
  dynamic numberOfReviewUser;
  String? profile;
  String? profession;
  String? number;

  Followers(
      {this.id,
      this.username,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.averageReview,
      this.numberOfReviewUser,
      this.profile,
      this.profession,
      this.number});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    averageReview = json['average_review'];
    numberOfReviewUser = json['number_of_review_user'];
    profile = json['profile'];
    profession = json['profession'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['average_review'] = averageReview;
    data['number_of_review_user'] = numberOfReviewUser;
    data['profile'] = profile;
    data['profession'] = profession;
    data['number'] = number;
    return data;
  }
}

class GetEmail {
  String? addedBy;
  String? email;

  GetEmail({this.addedBy, this.email});

  GetEmail.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['email'] = email;
    return data;
  }
}

class GetProfile {
  String? addedBy;
  String? profile;

  GetProfile({this.addedBy, this.profile});

  GetProfile.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['added_by'] = addedBy;
    data['profile'] = profile;
    return data;
  }
}

/* class Reviews {
  int? id;
  int? userId;
  int? reviewerId;
  String? rating;
  String? nicknames;
  String? comment;
  String? createdAt;
  String? updatedAt;
  dynamic file;
  dynamic deletedAt;
  dynamic isLiked;
  dynamic isDisliked;
  dynamic isReaction;
  dynamic reactionName;
  dynamic imageUrl;
  String? userNickname;
  int? isDeletedComment;
  List<RepliesComment>? repliesComment;
  bool isExpanded = false;
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  Reviews(
      {this.id,
      this.userId,
      this.reviewerId,
      this.rating,
      this.nicknames,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.file,
      this.deletedAt,
      this.isLiked,
      this.isDisliked,
      this.isReaction,
      this.reactionName,
      this.imageUrl,
      this.userNickname,
      this.isDeletedComment,
      this.repliesComment,
      this.isExpanded = false,
      this.formKey});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reviewerId = json['reviewer_id'];
    rating = json['rating'];
    nicknames = json['nicknames'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    file = json['file'];
    deletedAt = json['deleted_at'];
    isLiked = json['is_liked'];
    isDisliked = json['is_disliked'];
    isReaction = json['is_reaction'];
    reactionName = json['reaction_name'];
    imageUrl = json['image_url'];
    userNickname = json['user_nickname'];
    isDeletedComment = json['is_deleted_comment'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['reviewer_id'] = reviewerId;
    data['rating'] = rating;
    data['nicknames'] = nicknames;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['file'] = file;
    data['deleted_at'] = deletedAt;
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    data['is_reaction'] = isReaction;
    data['reaction_name'] = reactionName;
    data['image_url'] = imageUrl;
    data['user_nickname'] = userNickname;
    data['is_deleted_comment'] = isDeletedComment;
    if (repliesComment != null) {
      data['replies_comment'] = repliesComment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
 */
