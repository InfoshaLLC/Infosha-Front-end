import 'package:infosha/Controller/models/user_model.dart';

class CommentReactionModel {
  bool? success;
  String? message;
  List<CommentReactionData>? data;

  CommentReactionModel({this.success, this.message, this.data});

  CommentReactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommentReactionData>[];
      json['data'].forEach((v) {
        data!.add(CommentReactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentReactionData {
  String? reactionName;
  int? addedBy;
  String? createdAt;
  String? username;
  String? number;
  String? profile;
  bool? isLocked;

  CommentReactionData(
      {this.reactionName,
      this.addedBy,
      this.createdAt,
      this.username,
      this.number,
      this.profile,
      this.isLocked});

  CommentReactionData.fromJson(Map<String, dynamic> json) {
    reactionName = json['reaction_name'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    username = json['username'];
    number = json['number'];
    profile = json['profile'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reaction_name'] = reactionName;
    data['added_by'] = addedBy;
    data['created_at'] = createdAt;
    data['username'] = username;
    data['number'] = number;
    data['profile'] = profile;
    data['is_locked'] = isLocked;
    return data;
  }
}

class User {
  int? id;
  String? username;
  int? followersCount;
  dynamic averageReview;
  dynamic numberOfReviewUser;
  dynamic followingCount;
  dynamic contactsCount;
  dynamic likeCount;
  dynamic dislikeCount;
  dynamic averageRating;
  bool? isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  Profile? profile;
  List<Reviews>? reviews;
  dynamic activeSubscription;

  User(
      {this.id,
      this.username,
      this.followersCount,
      this.averageReview,
      this.numberOfReviewUser,
      this.followingCount,
      this.contactsCount,
      this.likeCount,
      this.dislikeCount,
      this.averageRating,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.profile,
      this.reviews,
      this.activeSubscription});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    followersCount = json['followers_count'];
    averageReview = json['average_review'];
    numberOfReviewUser = json['number_of_review_user'];
    followingCount = json['following_count'];
    contactsCount = json['contacts_count'];
    likeCount = json['like_count'];
    dislikeCount = json['dislike_count'];
    averageRating = json['average_rating'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    activeSubscription = json['active_subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['followers_count'] = followersCount;
    data['average_review'] = averageReview;
    data['number_of_review_user'] = numberOfReviewUser;
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
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['active_subscription'] = activeSubscription;
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
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    data['is_reaction'] = isReaction;
    data['reaction_name'] = reactionName;
    data['image_url'] = imageUrl;
    return data;
  }
}
