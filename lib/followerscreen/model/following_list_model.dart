class FollowingListModel {
  bool? success;
  String? message;
  FollowingData? data;

  FollowingListModel({this.success, this.message, this.data});

  FollowingListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? FollowingData.fromJson(json['data']) : null;
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

class FollowingData {
  dynamic currentPage;
  List<Data>? data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  dynamic links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  FollowingData({
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

  FollowingData.fromJson(Map<String, dynamic> json) {
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
  int? id;
  dynamic userId;
  String? username;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  dynamic averageReview;
  int? numberOfReviewUser;
  String? profile;
  String? profession;
  String? number;
  bool? isLocked;

  Data(
      {this.id,
      this.userId,
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
    userId = json['user_id'];
    username = json['username'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    averageReview = json['average_review'];
    numberOfReviewUser = json['number_of_review_user'];
    profile = json['profile'];
    profession = json['profession'];
    number = json['number'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
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
