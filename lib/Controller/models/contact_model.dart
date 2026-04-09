// To parse this JSON data, do
//
//     final Contacts = ContactsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Contacts ContactsFromJson(String str) => Contacts.fromJson(json.decode(str));

String ContactsToJson(Contacts data) => json.encode(data.toJson());

class Contacts {
  bool? success;
  String? message;
  List<ContactModel>? data;

  Contacts({this.success, this.message, this.data});

  Contacts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ContactModel>[];
      json['data'].forEach((v) {
        data!.add(new ContactModel.fromJson(v));
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

class ContactModel {
  int? id;
  dynamic userId;
  String? contactId;
  String? code;
  String? name;
  String? number;
  String? photo;
  String? profession;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  dynamic average_rating;
  int? isFriend;

  ContactModel(
      {this.id,
      this.userId,
      this.contactId,
      this.code,
      this.name,
      this.number,
      this.photo,
      this.profession,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.average_rating,
      this.isFriend});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    contactId = json['contact_id'];
    code = json['code'];
    name = json['name'];
    number = json['number'];
    photo = json['photo'];
    profession = json['profession'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    average_rating = json['average_rating'];
    isFriend = json['is_friend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['contact_id'] = contactId;
    data['code'] = code;
    data['name'] = name;
    data['number'] = number;
    data['photo'] = photo;
    data['profession'] = profession;
    data['is_subscription_active'] = isSubscriptionActive;
    data['active_subscription_plan_name'] = activeSubscriptionPlanName;
    data['average_rating'] = average_rating;
    data['is_friend'] = isFriend;
    return data;
  }
}


/* class Contacts {
  bool? success;
  String? message;
  ContactsData? data;

  Contacts({this.success, this.message, this.data});

  Contacts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? new ContactsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ContactsData {
  int? currentPage;
  List<ContactModel>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  ContactsData(
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

  ContactsData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ContactModel>[];
      json['data'].forEach((v) {
        data!.add(new ContactModel.fromJson(v));
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
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ContactModel {
  int? id;
  int? userId;
  String? contactId;
  String? code;
  String? name;
  String? number;
  String? photo;
  String? profession;
  // Null? address;
  dynamic averageRating;
  dynamic isSubscriptionActive;
  dynamic activeSubscriptionPlanName;
  bool? isFriend;

  ContactModel(
      {this.id,
      this.userId,
      this.contactId,
      this.code,
      this.name,
      this.number,
      this.photo,
      this.profession,
      // this.address,
      this.averageRating,
      this.isSubscriptionActive,
      this.activeSubscriptionPlanName,
      this.isFriend});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    contactId = json['contact_id'];
    code = json['code'];
    name = json['name'];
    number = json['number'];
    photo = json['photo'];
    profession = json['profession'];
    // address = json['address'];
    averageRating = json['average_rating'];
    isSubscriptionActive = json['is_subscription_active'];
    activeSubscriptionPlanName = json['active_subscription_plan_name'];
    isFriend = json['is_friend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['contact_id'] = this.contactId;
    data['code'] = this.code;
    data['name'] = this.name;
    data['number'] = this.number;
    data['photo'] = this.photo;
    data['profession'] = this.profession;
    // data['address'] = this.address;
    data['average_rating'] = this.averageRating;
    data['is_subscription_active'] = this.isSubscriptionActive;
    data['active_subscription_plan_name'] = this.activeSubscriptionPlanName;
    data['is_friend'] = this.isFriend;
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
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
 */
/* class Contacts {
  bool? success;
  String? message;
  List<ContactModel>? data;

  Contacts({this.success, this.message, this.data});

  Contacts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ContactModel>[];
      json['data'].forEach((v) {
        data!.add(ContactModel.fromJson(v));
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

class ContactModel {
  int? id;
  int? userId;
  String? contactId;
  String? code;
  String? number;
  String? name;
  String? photo;
  List<String>? email;
  String? profession;
  DateTime? dob;
  String? gender;
  Address? address;
  List<Social>? social;
  bool? isFriend;

  ContactModel({
    required this.id,
    required this.userId,
    required this.contactId,
    required this.code,
    required this.number,
    required this.name,
    required this.photo,
    required this.email,
    required this.profession,
    required this.dob,
    required this.gender,
    required this.address,
    required this.social,
    required this.isFriend,
  });

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    contactId = json['contact_id'];
    code = json['code'];
    number = json['number'];
    name = json['name'];
    photo = json['photo'];
    if (json['email'] != null) {
      email = <String>[];
      json['email'].forEach((v) {
        email!.add(v);
      });
    }
    profession = json['profession'];
    dob = json['dob'];
    gender = json['gender'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['social'] != null) {
      social = <Social>[];
      json['social'].forEach((v) {
        social!.add(new Social.fromJson(v));
      });
    }
    isFriend = json['is_friend'];
  }

  /* factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json["id"] ?? "",
        userId: json["user_id"],
        contactId: json["contact_id"] ?? "",
        code: json["code"],
        number: json["number"],
        name: json["name"],
        photo: json["photo"],
        
        email: json['email'] != null
            ? List<String>.from(json["email"].map((x) => x))
            : [],
        profession: json["profession"] ?? "",
        dob: json.containsKey('dob') && json["dob"] != null
            ? DateTime.parse(json["dob"])
            : DateTime(1995, 02, 12),
        gender: json["gender"] ?? "Male",
        address: Address.fromJson(json["address"]),
        social:
            List<Social>.from(json["social"].map((x) => Social.fromJson(x))),
        isFriend: json["is_friend"],
      ); */

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "contact_id": contactId,
        "code": code,
        "number": number,
        "name": name,
        "photo": photo,
        "email": List<dynamic>.from(email!.map((x) => x)),
        "profession": profession,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "address": address!.toJson(),
        "social": List<dynamic>.from(social!.map((x) => x.toJson())),
        "is_friend": isFriend,
      };
}

class Address {
  final dynamic address;
  final dynamic street;
  final dynamic city;
  final dynamic state;
  final dynamic postalCode;
  final dynamic country;
  final dynamic isoCountry;
  final dynamic subAdminArea;
  final dynamic subLocality;

  Address({
    required this.address,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isoCountry,
    required this.subAdminArea,
    required this.subLocality,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        street: json["street"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postalCode"],
        country: json["country"],
        isoCountry: json["isoCountry"],
        subAdminArea: json["subAdminArea"],
        subLocality: json["subLocality"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "street": street,
        "city": city,
        "state": state,
        "postalCode": postalCode,
        "country": country,
        "isoCountry": isoCountry,
        "subAdminArea": subAdminArea,
        "subLocality": subLocality,
      };
}

class Social {
  final String socialType;
  final String url;

  Social({
    required this.socialType,
    required this.url,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        socialType: json["social_type"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "social_type": socialType,
        "url": url,
      };
}
 */