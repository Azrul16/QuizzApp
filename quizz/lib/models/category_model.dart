class CategoryModel {
  CategoryModel({
    required this.title,
    required this.subTitle,
    required this.docID,
  });

  final String title;
  final String subTitle;
  final String docID;

  // Factory method to create a Category object from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      docID: id,
    );
  }

  // Method to convert a Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subTitle': subTitle,
    };
  }
}
