class Category {
  int? id;
  String? title;

  Category.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      title = json['title'];
}