class TopFollowersModel {
  bool? success;
  String? message;
  List<Data>? data;

  TopFollowersModel({this.success, this.message, this.data});

  TopFollowersModel.fromJson(Map<String, dynamic> json) {
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
  dynamic username;
  String? number;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  String? profile;
  String? profession;
  CountryData? country;
  String? city;
  dynamic followersCount;
  int? is_friend;
  int? user_id;
  bool? isLocked;

  Data(
      {this.id,
      this.username,
      this.number,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.profile,
      this.profession,
      this.country,
      this.city,
      this.followersCount,
      this.is_friend,
      this.user_id,
      this.isLocked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['name'];
    number = json['number'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    profile = json['profile'];
    profession = json['profession'];
    country = json['country'] != null && json['country'] is Map<String, dynamic>
        ? CountryData.fromJson(json['country'])
        : null;
    city = json['city'];
    followersCount = json['followers_count'];
    is_friend = json['is_friend'];
    user_id = json['user_id'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = username;
    data['number'] = number;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['profile'] = profile;
    data['profession'] = profession;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['city'] = city;
    data['followers_count'] = followersCount;
    data['is_friend'] = is_friend;
    data['user_id'] = user_id;
    data['is_locked'] = isLocked;
    return data;
  }
}

class CountryData {
  String? address;
  String? label;
  String? customLabel;
  String? street;
  String? pobox;
  String? neighborhood;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? isoCountry;
  String? subAdminArea;
  String? subLocality;

  CountryData(
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

  CountryData.fromJson(Map<String, dynamic> json) {
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
