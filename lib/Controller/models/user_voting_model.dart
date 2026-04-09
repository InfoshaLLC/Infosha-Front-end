class UserVotingModel {
  bool? success;
  String? message;
  List<Data>? data;

  UserVotingModel({this.success, this.message, this.data});

  UserVotingModel.fromJson(Map<String, dynamic> json) {
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
  String? userName;
  String? number;
  String? createdAt;
  String? profession;
  bool? isSubscriptionActive;
  String? profile;
  bool? isLocked;

  Data(
      {this.userName,
      this.number,
      this.createdAt,
      this.profession,
      this.isSubscriptionActive,
      this.profile,
      this.isLocked});

  Data.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    number = json['number'];
    createdAt = json['created_at'];
    profession = json['profession'];
    isSubscriptionActive = json['is_subscription_active'];
    profile = json['profile'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_name'] = userName;
    data['number'] = number;
    data['created_at'] = createdAt;
    data['profession'] = profession;
    data['is_subscription_active'] = isSubscriptionActive;
    data['profile'] = profile;
    data['is_locked'] = isLocked;
    return data;
  }
}
