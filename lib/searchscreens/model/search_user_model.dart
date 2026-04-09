class SearchUserModel {
  bool? success;
  String? message;
  SearchUserData? data;

  SearchUserModel({this.success, this.message, this.data});

  SearchUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = SearchUserData.fromJson(json['data']);
    } else {
      data = null;
    }
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

class SearchUserData {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  SearchUserData({
    this.currentPage,
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
    this.total,
  });

  SearchUserData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class Data {
  String? number;
  int? id;
  String? code;
  String? email;
  String? photo;
  String? profession;
  String? userName;
  String? address;
  dynamic userId;
  String? contactId;
  dynamic isActive;
  dynamic planName;
  dynamic averageReview;
  dynamic followingListCount;
  dynamic followersListCount;
  dynamic reviewsAverage;
  int? numberOfUsers;
  dynamic isFriend;
  bool? isLocked;
  bool? isVisited;
  int? visitsCount;

  Data(
      {this.number,
      this.id,
      this.code,
      this.email,
      this.photo,
      this.profession,
      this.userName,
      this.address,
      this.userId,
      this.contactId,
      this.isActive,
      this.planName,
      this.averageReview,
      this.followingListCount,
      this.followersListCount,
      this.reviewsAverage,
      this.numberOfUsers,
      this.isFriend,
      this.isLocked,
      this.isVisited = false,
      this.visitsCount});

  Data.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    id = json['id'];
    code = json['code'];
    email = json['email'];
    photo = json['photo'];
    profession = json['profession'];
    userName = json['user_name'];
    address = json['address'];
    userId = json['user_id'];
    contactId = json['contact_id'];
    isActive = json['is_active'];
    planName = json['plan_name'];
    averageReview = json['average_review'];
    followingListCount = json['following_list_count'];
    followersListCount = json['followers_list_count'];
    reviewsAverage = json['reviews_average'];
    numberOfUsers = json['number_of_users'];
    isFriend = json['is_friend'];
    isLocked = json['is_locked'];
    visitsCount = json['visits_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = number;
    data['id'] = id;
    data['code'] = code;
    data['email'] = email;
    data['photo'] = photo;
    data['profession'] = profession;
    data['user_name'] = userName;
    data['address'] = address;
    data['user_id'] = userId;
    data['contact_id'] = contactId;
    data['is_active'] = isActive;
    data['plan_name'] = planName;
    data['average_review'] = averageReview;
    data['following_list_count'] = followingListCount;
    data['followers_list_count'] = followersListCount;
    data['reviews_average'] = reviewsAverage;
    data['number_of_users'] = numberOfUsers;
    data['is_friend'] = isFriend;
    data['is_locked'] = isLocked;
    data['visits_count'] = visitsCount;

    return data;
  }
}

class Address {
  dynamic address;
  dynamic street;
  dynamic city;
  dynamic state;
  dynamic postalCode;
  dynamic country;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
