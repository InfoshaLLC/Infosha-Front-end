class KingGodListModel {
  bool? success;
  String? message;
  KingGodData? data;

  KingGodListModel({this.success, this.message, this.data});

  KingGodListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new KingGodData.fromJson(json['data']) : null;
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

class KingGodData {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  KingGodData(
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

  KingGodData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? userId;
  int? planId;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  int? isActive;
  User? user;
  bool? isLocked;

  Data({
    this.id,
    this.userId,
    this.planId,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.isActive,
    this.user,
    this.isLocked,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    isActive = json['is_active'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['plan_id'] = planId;
    data['subscription_start_date'] = subscriptionStartDate;
    data['subscription_end_date'] = subscriptionEndDate;
    data['is_active'] = isActive;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['is_locked'] = isLocked;

    return data;
  }
}

class User {
  int? id;
  String? username;
  String? number;
  String? type;
  dynamic followersCount;
  dynamic averageReview;
  dynamic numberOfReviewUser;
  dynamic followingCount;
  dynamic averageRating;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  dynamic user_profession;
  String? profile_url;

  User(
      {this.id,
      this.username,
      this.number,
      this.type,
      this.followersCount,
      this.averageReview,
      this.numberOfReviewUser,
      this.followingCount,
      this.averageRating,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.user_profession,
      this.profile_url});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    number = json['number'];
    type = json['type'];
    followersCount = json['followers_count'];
    averageReview = json['average_review'];
    numberOfReviewUser = json['number_of_review_user'];
    followingCount = json['following_count'];
    averageRating = json['average_rating'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    user_profession = json['user_profession'];
    profile_url = json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['number'] = number;
    data['type'] = type;
    data['followers_count'] = followersCount;
    data['average_review'] = averageReview;
    data['number_of_review_user'] = numberOfReviewUser;
    data['following_count'] = followingCount;
    data['average_rating'] = averageRating;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['user_profession'] = user_profession;
    data['profile_url'] = profile_url;
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
