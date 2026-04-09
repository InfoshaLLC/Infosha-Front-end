class FollowersListModel {
  bool? success;
  String? message;
  List<Data>? data;

  FollowersListModel({this.success, this.message, this.data});

  FollowersListModel.fromJson(Map<String, dynamic> json) {
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
  String? username;
  bool? isSubscriptionActive;
  String? activeSubscriptionPlanName;
  double? averageReview;
  int? numberOfReviewUser;
  String? profile;
  String? profession;
  String? number;
  bool? isLocked;

  Data(
      {this.id,
      this.username,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.averageReview,
      this.numberOfReviewUser,
      this.profile,
      this.profession,
      this.number,
      this.isLocked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    averageReview = (json['average_review'] as num?)?.toDouble();
    numberOfReviewUser = json['number_of_review_user'];
    profile = json['profile'];
    profession = json['profession'];
    number = json['number'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['average_review'] = averageReview;
    data['number_of_review_user'] = numberOfReviewUser;
    data['profile'] = profile;
    data['profession'] = profession;
    data['number'] = number;
    data['is_locked'] = isLocked;
    return data;
  }
}
