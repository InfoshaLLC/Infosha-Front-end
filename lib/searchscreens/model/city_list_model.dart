class CityListModel {
  bool? error;
  String? msg;
  List<String>? data;

  CityListModel({this.error, this.msg, this.data});

  CityListModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    msg = json['msg'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['error'] = error;
    data['msg'] = msg;
    data['data'] = data;
    return data;
  }
}
