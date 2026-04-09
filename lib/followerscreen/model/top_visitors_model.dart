class TopVisitorsModel {
  bool? success;
  String? message;
  List<Data>? data;

  TopVisitorsModel({this.success, this.message, this.data});

  TopVisitorsModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  dynamic username;
  String? number;
  bool? isSubscriptionActive;
  String? activeSubscriptionPlanName;
  String? profile;
  dynamic profession;
  String? country;
  String? city;
  int? visitsCount;
  int? followersCount;
  int? isFriend;
  bool? isLocked;

  Data(
      {this.id,
      this.name,
      this.username,
      this.number,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.profile,
      this.profession,
      this.country,
      this.city,
      this.visitsCount,
      this.followersCount,
      this.isFriend,
      this.isLocked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    number = json['number'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    profile = json['profile'];
    profession = json['profession'];
    country = json['country'];
    city = json['city'];
    visitsCount = json['visits_count'];
    followersCount = json['followers_count'];
    isFriend = json['is_friend'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['number'] = number;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['profile'] = profile;
    data['profession'] = profession;
    data['country'] = country;
    data['city'] = city;
    data['visits_count'] = visitsCount;
    data['followers_count'] = followersCount;
    data['is_friend'] = isFriend;
    data['is_locked'] = isLocked;
    return data;
  }
}
