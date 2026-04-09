class ProfessionByOtherUserModel {
  bool? success;
  String? message;
  List<ProfessionByOtherUserModelData>? data;

  ProfessionByOtherUserModel({this.success, this.message, this.data});

  ProfessionByOtherUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProfessionByOtherUserModelData>[];
      json['data'].forEach((v) {
        data!.add(new ProfessionByOtherUserModelData.fromJson(v));
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

class ProfessionByOtherUserModelData {
  String? profession;
  String? username;

  ProfessionByOtherUserModelData({this.profession, this.username});

  ProfessionByOtherUserModelData.fromJson(Map<String, dynamic> json) {
    profession = json['profession'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profession'] = profession;
    data['username'] = username;
    return data;
  }
}
