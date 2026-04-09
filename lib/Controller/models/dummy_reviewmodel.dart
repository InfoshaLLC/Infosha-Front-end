class DummyReviewModel {
  String nickname;
  double rating;
  String comment;
  String imgPath;
  DateTime createdAt;
  bool isExpanded;
  DummyReviewModel(
      {required this.nickname,
      required this.rating,
      required this.comment,
      required this.imgPath,
      required this.createdAt,
      required this.isExpanded});
}
