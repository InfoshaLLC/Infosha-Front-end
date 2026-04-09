class ReviewVoteModel {
  bool? success;
  String? message;
  List<Data>? data;

  ReviewVoteModel({this.success, this.message, this.data});

  ReviewVoteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  String? username;
  String? number;
  String? createdAt;
  String? profession;
  String? photo;
  String? activeSubscriptionPlanName;
  int? isSubscriptionActive;
  bool? isLocked;

  Data({
    this.id,
    this.username,
    this.number,
    this.createdAt,
    this.profession,
    this.photo,
    this.activeSubscriptionPlanName,
    this.isSubscriptionActive,
    this.isLocked,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    createdAt = json['created_at'];
    profession = json['profession'];
    photo = json['photo'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    isSubscriptionActive = json['is_subscription_active'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['created_at'] = createdAt;
    data['profession'] = profession;
    data['photo'] = photo;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['is_subscription_active'] = isSubscriptionActive;
    data['is_locked'] = isLocked;
    return data;
  }
}
