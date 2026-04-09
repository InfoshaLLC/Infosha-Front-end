class ProfileRatingModel {
  bool? success;
  String? message;
  List<Data>? data;

  ProfileRatingModel({this.success, this.message, this.data});

  ProfileRatingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? reviewerId;
  String? rating;
  dynamic averageReview;
  String? createdAt;
  String? profile;
  Reviewer? reviewer;
  int? isShowRating;
  String? nicknames;
  String? comment;
  List<String>? reviewImages;

  Data(
      {this.id,
      this.userId,
      this.reviewerId,
      this.rating,
      this.averageReview,
      this.createdAt,
      this.nicknames,
      this.comment,
      this.reviewImages,
      this.profile,
      this.isShowRating,
      this.reviewer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reviewerId = json['reviewer_id'];
    rating = json['rating'];
    nicknames = json['nicknames'];
    comment = json['comment'];
    averageReview = json['average_review'];
    createdAt = json['created_at'];
    reviewImages = List<String>.from(json['review_images'] ?? []);
    profile = json['profile'];
    isShowRating = json['isShowRating'];
    reviewer = json['reviewer'] != null ? new Reviewer.fromJson(json['reviewer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['reviewer_id'] = reviewerId;
    data['rating'] = rating;
    data['average_review'] = averageReview;
    data['created_at'] = createdAt;
    data['nicknames'] = nicknames;
    data['review_images'] = reviewImages;
    data['comment'] = comment;
    data['isShowRating'] = isShowRating;
    data['profile'] = profile;
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
  bool? isSubscriptionActive;
  dynamic activeSubscriptionPlanName;

  Reviewer({this.id, this.username, this.number, this.isSubscriptionActive, this.activeSubscriptionPlanName});

  Reviewer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    return data;
  }
}
