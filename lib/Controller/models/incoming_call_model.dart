class IncomingCallModel {
  bool? success;
  String? message;
  Data? data;

  IncomingCallModel({this.success, this.message, this.data});

  IncomingCallModel.fromJson(Map<String, dynamic> json) {
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

class Data {
  int? id;
  String? name;
  String? number;
  String? user_profession;
  String? photo;
  List<Profession>? profession;
  List<GetNames>? getNames;
  List<GetAddress>? getAddress;
  List<GetDob>? getDob;
  List<Reviews>? reviews;
  dynamic averageReview;
  dynamic numberOfReviewUser;
  dynamic commentReactionsCount;
  bool? isLocked;

  Data({
    this.id,
    this.name,
    this.number,
    this.user_profession,
    this.photo,
    this.profession,
    this.getNames,
    this.getAddress,
    this.getDob,
    this.reviews,
    this.averageReview,
    this.numberOfReviewUser,
    this.commentReactionsCount,
    this.isLocked,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    user_profession = json['user_profession'];
    photo = json['photo'];
    if (json['profession'] != null) {
      profession = <Profession>[];
      json['profession'].forEach((v) {
        profession!.add(Profession.fromJson(v));
      });
    }
    if (json['get_names'] != null) {
      getNames = <GetNames>[];
      json['get_names'].forEach((v) {
        getNames!.add(GetNames.fromJson(v));
      });
    }
    /* if (json['get_address'] != null) {
      getAddress = <GetAddress>[];
      json['get_address'].forEach((v) {
        getAddress!.add(GetAddress.fromJson(v));
      });
    } */
    if (json['get_dob'] != null) {
      getDob = <GetDob>[];
      json['get_dob'].forEach((v) {
        getDob!.add(GetDob.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    averageReview = json['average_review'];
    numberOfReviewUser = json['number_of_review_user'];
    commentReactionsCount = json['commentReactions_count'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    data['user_profession'] = user_profession;
    data['photo'] = photo;
    if (profession != null) {
      data['profession'] = profession!.map((v) => v.toJson()).toList();
    }
    if (getNames != null) {
      data['get_names'] = getNames!.map((v) => v.toJson()).toList();
    }
    if (getAddress != null) {
      data['get_address'] = getAddress!.map((v) => v.toJson()).toList();
    }
    if (getDob != null) {
      data['get_dob'] = getDob!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['average_review'] = averageReview;
    data['number_of_review_user'] = numberOfReviewUser;
    data['commentReactions_count'] = commentReactionsCount;
    data['is_locked'] = isLocked;
    return data;
  }
}

class Profession {
  String? addedBy;
  String? profession;

  Profession({this.addedBy, this.profession});

  Profession.fromJson(Map<String, dynamic> json) {
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

class GetNames {
  String? addedBy;
  String? name;

  GetNames({this.addedBy, this.name});

  GetNames.fromJson(Map<String, dynamic> json) {
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

class GetAddress {
  String? addedBy;
  Address? address;

  GetAddress({this.addedBy, this.address});

  GetAddress.fromJson(Map<String, dynamic> json) {
    addedBy = json['added_by'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
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

class Address {
  String? address;
  dynamic label;
  dynamic customLabel;
  dynamic street;
  dynamic pobox;
  dynamic neighborhood;
  String? city;
  String? state;
  dynamic postalCode;
  String? country;
  dynamic isoCountry;
  dynamic subAdminArea;
  dynamic subLocality;

  Address(
      {this.address,
      this.label,
      this.customLabel,
      this.street,
      this.pobox,
      this.neighborhood,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.isoCountry,
      this.subAdminArea,
      this.subLocality});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    label = json['label'];
    customLabel = json['customLabel'];
    street = json['street'];
    pobox = json['pobox'];
    neighborhood = json['neighborhood'];
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
    data['label'] = label;
    data['customLabel'] = customLabel;
    data['street'] = street;
    data['pobox'] = pobox;
    data['neighborhood'] = neighborhood;
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

class Reviews {
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
  int? commentReactionsCount;
  bool? isLiked;
  bool? isDisliked;
  bool? isReaction;
  dynamic reactionName;
  dynamic imageUrl;
  String? userNickname;
  int? isDeletedComment;
  Reviewer? reviewer;

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
      this.commentReactionsCount,
      this.isLiked,
      this.isDisliked,
      this.isReaction,
      this.reactionName,
      this.imageUrl,
      this.userNickname,
      this.isDeletedComment,
      this.reviewer});

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
    commentReactionsCount = json['commentReactions_count'];
    isLiked = json['is_liked'];
    isDisliked = json['is_disliked'];
    isReaction = json['is_reaction'];
    reactionName = json['reaction_name'];
    imageUrl = json['image_url'];
    userNickname = json['user_nickname'];
    isDeletedComment = json['is_deleted_comment'];
    reviewer =
        json['reviewer'] != null ? Reviewer.fromJson(json['reviewer']) : null;
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
    data['file'] = file;
    data['deleted_at'] = deletedAt;
    data['commentReactions_count'] = commentReactionsCount;
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    data['is_reaction'] = isReaction;
    data['reaction_name'] = reactionName;
    data['image_url'] = imageUrl;
    data['user_nickname'] = userNickname;
    data['is_deleted_comment'] = isDeletedComment;
    if (reviewer != null) {
      data['reviewer'] = reviewer!.toJson();
    }
    return data;
  }
}

class Reviewer {
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
  dynamic braintreeCustomerId;
  int? isDeactiveAccount;
  int? followersCount;
  int? followingCount;
  int? contactsCount;
  int? likeCount;
  int? dislikeCount;
  dynamic averageRating;
  bool? isSubscriptionActive;
  String? activeSubscriptionPlanName;
  ProfileData? profile;
  ActiveSubscription? activeSubscription;

  Reviewer(
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
      this.isDeactiveAccount,
      this.followersCount,
      this.followingCount,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.averageRating,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.profile,
      this.activeSubscription});

  Reviewer.fromJson(Map<String, dynamic> json) {
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
    isDeactiveAccount = json['is_deactive_account'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    averageRating = json['average_rating'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    profile =
        json['profile'] != null ? ProfileData.fromJson(json['profile']) : null;
    activeSubscription = json['active_subscription'] != null
        ? ActiveSubscription.fromJson(json['active_subscription'])
        : null;
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
    data['is_deactive_account'] = isDeactiveAccount;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['contacts_count'] = contactsCount;
    data['like_count'] = likeCount;
    data['dislike_count'] = dislikeCount;
    data['average_rating'] = averageRating;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (activeSubscription != null) {
      data['active_subscription'] = activeSubscription!.toJson();
    }
    return data;
  }
}

class ProfileData {
  int? id;
  int? userId;
  dynamic addedBy;
  dynamic nickname;
  dynamic profile;
  dynamic gender;
  dynamic dob;
  dynamic profession;
  dynamic location;
  dynamic address;
  dynamic email;
  dynamic facebookId;
  dynamic instagramId;
  String? createdAt;
  String? updatedAt;
  dynamic country;
  dynamic state;
  dynamic city;
  String? profileUrl;

  ProfileData(
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

  ProfileData.fromJson(Map<String, dynamic> json) {
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

class ActiveSubscription {
  int? id;
  int? userId;
  int? planId;
  String? transactionsId;
  String? subscriptionId;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  int? isActive;
  Null createdAt;
  Null updatedAt;
  Plan? plan;

  ActiveSubscription(
      {this.id,
      this.userId,
      this.planId,
      this.transactionsId,
      this.subscriptionId,
      this.subscriptionStartDate,
      this.subscriptionEndDate,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.plan});

  ActiveSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    transactionsId = json['transactions_id'];
    subscriptionId = json['subscription_id'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['plan_id'] = planId;
    data['transactions_id'] = transactionsId;
    data['subscription_id'] = subscriptionId;
    data['subscription_start_date'] = subscriptionStartDate;
    data['subscription_end_date'] = subscriptionEndDate;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    return data;
  }
}

class Plan {
  int? id;
  String? name;
  String? planId;
  int? billingFrequency;
  String? currencyIsoCode;
  String? price;
  String? createdAt;
  String? updatedAt;

  Plan(
      {this.id,
      this.name,
      this.planId,
      this.billingFrequency,
      this.currencyIsoCode,
      this.price,
      this.createdAt,
      this.updatedAt});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    planId = json['plan_id'];
    billingFrequency = json['billing_frequency'];
    currencyIsoCode = json['currency_iso_code'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['plan_id'] = planId;
    data['billing_frequency'] = billingFrequency;
    data['currency_iso_code'] = currencyIsoCode;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
