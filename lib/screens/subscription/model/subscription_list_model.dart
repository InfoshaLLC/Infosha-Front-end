class SubscriptionListModel {
  bool? success;
  String? message;
  List<Data>? data;

  SubscriptionListModel({this.success, this.message, this.data});

  SubscriptionListModel.fromJson(Map<String, dynamic> json) {
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
  String? planId;
  int? billingFrequency;
  String? currencyIsoCode;
  String? price;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.planId,
      this.billingFrequency,
      this.currencyIsoCode,
      this.price,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    planId = json['plan_id'];
    billingFrequency = json['billing_frequency'];
    currencyIsoCode = json['currency_iso_code'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['plan_id'] = planId;
    data['billing_frequency'] = billingFrequency;
    data['currency_iso_code'] = currencyIsoCode;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
