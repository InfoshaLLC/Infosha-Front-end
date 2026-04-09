class ProfessionModel {
  int? id;
  String? profession;

  ProfessionModel({this.id, this.profession});

  ProfessionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profession = json['profession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profession'] = this.profession;
    return data;
  }
}
