class FavoritesModel {
  bool status;
  String message;
  FavoritesData data;

  FavoritesModel({this.status, this.message, this.data});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new FavoritesData.fromJson(json['data']) : null;
  }
}

class FavoritesData {
  List<Data> data = [];
  String path;

  FavoritesData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    path = json['path'];
  }
}

class Data {
  int id;
  Product product;

  Data({this.id, this.product});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }
}

class Product {
  int id;
  var price;
  var oldPrice;
  int discount;
  String image;
  String name;
  String description;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
