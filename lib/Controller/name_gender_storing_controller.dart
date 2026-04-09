import 'package:get/get.dart';

/// A simple model to store each update
class UserUpdate {
  final String? nickname;
  final String? gender;
  final String? profession;
  final String? avatar;
  final String eventType; // e.g. nickname_updated, bio_update, etc.
  final DateTime timestamp;

  UserUpdate({
    this.nickname,
    this.gender,
    this.profession,
    this.avatar,
    required this.eventType,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class NameAndGenderStoringController extends GetxController {
  /// List of updates in added order
  RxList<UserUpdate> updates = <UserUpdate>[].obs;

  /// Add nickname update
  void addNicknameUpdate({
    required String nickname,
    required String gender,
  }) {
    updates.add(UserUpdate(
      nickname: nickname,
      gender: gender,
      eventType: 'nickname_updated',
    ));
  }

  /// Add profile photo update
  void addProfilePhotoUpdate({
    required String avatar,
    required String nickname,
    required String gender,
  }) {
    updates.add(UserUpdate(
      nickname: nickname,
      gender: gender,
      avatar: avatar,
      eventType: 'profile_photo_updated',
    ));
  }

  /// Add profession update
  void addProfessionUpdate({
    required String nickname,
    required String gender,
    required String profession,
  }) {
    updates.add(UserUpdate(
      nickname: nickname,
      gender: gender,
      profession: profession,
      eventType: 'profession_update',
    ));
  }

  /// Add bio update (e.g. name, gender, bio_updated)
  void addBioUpdate({
    required String nickname,
    required String gender,
  }) {
    updates.add(UserUpdate(
      nickname: nickname,
      gender: gender,
      eventType: 'bio_update',
    ));
  }

  /// Add social media update
  void addSocialUpdate({
    required String nickname,
    required String gender,
  }) {
    updates.add(UserUpdate(
      nickname: nickname,
      gender: gender,
      eventType: 'social_update',
    ));
  }

  /// Clear all stored updates
  void clearAll() {
    updates.clear();
  }
}
