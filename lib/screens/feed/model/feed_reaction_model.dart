class FeedReactionModel {
  bool? success;
  String? message;
  List<FeedReactionData>? data;

  FeedReactionModel({this.success, this.message, this.data});

  FeedReactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FeedReactionData>[];
      json['data'].forEach((v) {
        data!.add(FeedReactionData.fromJson(v));
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

class FeedReactionData {
  String? reactionName;
  int? addedBy;
  String? createdAt;
  String? username;
  String? number;
  String? profile;
  int? userId;
  bool? isLocked;

  FeedReactionData({
    this.reactionName,
    this.addedBy,
    this.createdAt,
    this.username,
    this.number,
    this.profile,
    this.userId,
    this.isLocked,
  });

  FeedReactionData.fromJson(Map<String, dynamic> json) {
    reactionName = json['reaction_name'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    username = json['username'];
    number = json['number'];
    profile = json['profile'];
    userId = json['user_id'];
    isLocked = json['is_locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reaction_name'] = reactionName;
    data['added_by'] = addedBy;
    data['created_at'] = createdAt;
    data['username'] = username;
    data['number'] = number;
    data['profile'] = profile;
    data['user_id'] = userId;
    data['is_locked'] = isLocked;
    return data;
  }
}
