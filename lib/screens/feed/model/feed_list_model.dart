import 'package:flutter/material.dart';

class FeedListModel {
  bool? success;
  String? message;
  Data? data;

  FeedListModel({this.success, this.message, this.data});

  FeedListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<FeedListData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  String? prevPageUrl;
  dynamic to;
  dynamic total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <FeedListData>[];
      json['data'].forEach((v) {
        data!.add(new FeedListData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class FeedListData {
  int? id;
  int? userId;
  String? fileName;
  String? fileUrl;
  String? description;
  String? activity_type;
  String? feed_item_type;
  String? createdAt;
  String? updatedAt;
  String? image_update;
  String? nickname_update;
  dynamic isLiked;
  dynamic isDisliked;
  dynamic totalLikes;
  dynamic totalDislikes;
  dynamic totalRepliesComment;
  User? user;
  List<RepliesComment>? repliesComment;
  // List<Null>? totallike;
  List<Totaldislike>? totaldislike;
  // GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  // FocusNode? focusNode = FocusNode();
  // TextEditingController? replyController = TextEditingController();
  String? reactionName;
  int? totalReactionCount;

  FeedListData({
    this.id,
    this.userId,
    this.fileName,
    this.fileUrl,
    this.description,
    this.activity_type,
    this.feed_item_type,
    this.createdAt,
    this.updatedAt,
    this.image_update,
    this.nickname_update,
    this.isLiked,
    this.isDisliked,
    this.totalLikes,
    this.totalDislikes,
    this.totalRepliesComment,
    this.user,
    this.repliesComment,
    // this.totallike,
    this.totaldislike,
    // this.formKey,
    // this.focusNode,
    // this.replyController,
    this.reactionName,
    this.totalReactionCount,
  });

  FeedListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    description = json['description'];
    activity_type = json['activity_type'];
    feed_item_type = json['feed_item_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image_update = json['image_update'];
    nickname_update = json['nickname_update'];
    isLiked = json['is_liked'];
    isDisliked = json['is_disliked'];
    totalLikes = json['total_likes'];
    totalDislikes = json['total_dislikes'];
    totalRepliesComment = json['total_replies_comment'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['replies_comment'] != null) {
      repliesComment = <RepliesComment>[];
      json['replies_comment'].forEach((v) {
        repliesComment!.add(new RepliesComment.fromJson(v));
      });
    }
    /*  if (json['totallike'] != null) {
      totallike = <Null>[];
      json['totallike'].forEach((v) {
        totallike!.add(new Null.fromJson(v));
      });
    } */
    if (json['totaldislike'] != null) {
      totaldislike = <Totaldislike>[];
      json['totaldislike'].forEach((v) {
        totaldislike!.add(new Totaldislike.fromJson(v));
      });
    }
    // formKey = GlobalKey<FormState>();
    // focusNode = FocusNode();
    // replyController = TextEditingController();
    reactionName = json['reaction_name'];
    totalReactionCount = json['total_reactions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['file_name'] = fileName;
    data['file_url'] = fileUrl;
    data['description'] = description;
    data['activity_type'] = activity_type;
    data['feed_item_type'] = feed_item_type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_update'] = image_update;
    data['nickname_update'] = nickname_update;
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    data['total_likes'] = totalLikes;
    data['total_dislikes'] = totalDislikes;
    data['total_replies_comment'] = totalRepliesComment;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (repliesComment != null) {
      data['replies_comment'] = repliesComment!.map((v) => v.toJson()).toList();
    }
    /* if (this.totallike != null) {
      data['totallike'] = this.totallike!.map((v) => v.toJson()).toList();
    } */
    if (totaldislike != null) {
      data['totaldislike'] = totaldislike!.map((v) => v.toJson()).toList();
    }
    data['reaction_name'] = reactionName;
    data['total_reactions'] = totalReactionCount;
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? number;
  String? gender;
  bool? isRegisteredUser;

  bool? isSubscriptionActive;
  String? activeSubscriptionPlanName;
  Profile? profile;
  bool? isLocked;

  User(
      {this.id,
      this.username,
      this.number,
      this.gender,
      this.isRegisteredUser,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.profile,
      this.isLocked});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    gender = json['gender'];
    isRegisteredUser = json['is_registered_user'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['gender'] = gender;
    data['is_registered_user'] = isRegisteredUser;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['is_locked'] = isLocked;
    return data;
  }
}

class Profile {
  int? id;
  int? userId;
  /* dynamic addedBy;
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
  String? city;*/
  String? profileUrl;

  Profile(
      {this.id,
      this.userId,
      /* this.addedBy,
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
      this.city,*/
      this.profileUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    /* addedBy = json['added_by'];
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
    city = json['city']; */
    profileUrl = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    /* data['added_by'] = addedBy;
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
    data['city'] = city; */
    data['profile'] = profileUrl;
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
  bool? isLiked;
  bool? isDisliked;
  bool? isReaction;
  dynamic reactionName;
  dynamic imageUrl;

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
      this.isLiked,
      this.isDisliked,
      this.isReaction,
      this.reactionName,
      this.imageUrl});

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
    isLiked = json['is_liked'];
    isDisliked = json['is_disliked'];
    isReaction = json['is_reaction'];
    reactionName = json['reaction_name'];
    imageUrl = json['image_url'];
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
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    data['is_reaction'] = isReaction;
    data['reaction_name'] = reactionName;
    data['image_url'] = imageUrl;
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
  Null? createdAt;
  Null? updatedAt;
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
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class RepliesComment {
  int? id;
  int? feedId;
  String? comment;
  int? addedBy;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? number;
  String? profile;
  List<FeedCommentReplies>? feedCommentReplies;
  bool? isLocked;

  RepliesComment({
    this.id,
    this.feedId,
    this.comment,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.number,
    this.profile,
    this.feedCommentReplies,
    this.isLocked,
  });

  RepliesComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    comment = json['comment'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    username = json['username'];
    number = json['number'];
    profile = json['profile_image'];
    if (json['feed_comment_replies'] != null) {
      feedCommentReplies = <FeedCommentReplies>[];
      json['feed_comment_replies'].forEach((v) {
        feedCommentReplies!.add(new FeedCommentReplies.fromJson(v));
      });
    }
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['feed_id'] = feedId;
    data['comment'] = comment;
    data['added_by'] = addedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['number'] = number;
    data['profile_image'] = profile;
    if (feedCommentReplies != null) {
      data['feed_comment_replies'] = feedCommentReplies!.map((v) => v.toJson()).toList();
    }
    data['is_locked'] = isLocked;
    return data;
  }
}

class FeedCommentReplies {
  int? id;
  String? comment;
  int? feedUserId;
  int? feedReplyId;
  String? createdAt;
  String? updatedAt;

  String? username;
  String? number;
  String? profile;
  int? isDeletedCommentReply;
  bool? isLocked;

  FeedCommentReplies({
    this.id,
    this.comment,
    this.feedUserId,
    this.feedReplyId,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.number,
    this.profile,
    this.isDeletedCommentReply,
    this.isLocked,
  });

  FeedCommentReplies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    feedUserId = json['feed_user_id'];
    feedReplyId = json['feed_reply_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    username = json['username'];
    number = json['number'];
    profile = json['profile'];
    isDeletedCommentReply = json['is_deleted_comment_reply'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['comment'] = comment;
    data['feed_user_id'] = feedUserId;
    data['feed_reply_id'] = feedReplyId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['username'] = username;
    data['number'] = number;
    data['profile'] = profile;
    data['is_deleted_comment_reply'] = isDeletedCommentReply;
    data['is_locked'] = isLocked;
    return data;
  }
}

class Totaldislike {
  int? id;
  int? feedId;
  int? addedBy;
  int? like;
  int? dislike;
  String? createdAt;
  String? updatedAt;

  Totaldislike({this.id, this.feedId, this.addedBy, this.like, this.dislike, this.createdAt, this.updatedAt});

  Totaldislike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    addedBy = json['added_by'];
    like = json['like'];
    dislike = json['dislike'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['feed_id'] = feedId;
    data['added_by'] = addedBy;
    data['like'] = like;
    data['dislike'] = dislike;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
