class CategoryModel {
  bool status;
  CategoriesData data;

  CategoryModel({this.status, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? CategoriesData.fromJson(json['data']) : null;
  }
}

class CategoriesData {
  List<DataModel> categoriesData = [];

  CategoriesData({
    this.categoriesData,
  });

  CategoriesData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        categoriesData.add(DataModel.fromJson(v));
      });
    }
  }
}

class DataModel {
  int id;
  String name;
  String image;

  DataModel({this.id, this.name, this.image});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
