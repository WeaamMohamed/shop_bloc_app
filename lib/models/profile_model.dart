class ProfileModel {
  bool status;
  String message;
  Data data;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  String name;
  String email;
  String phone;
  String image;

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
  }
}

//
// {
// "status": true,
// "message": null,
// "data": {
// "id": 906,
// "name": "weaamMohamed",
// "email": "weaamMohamed@gmail.com",
// "phone": "1234568888",
// "image": "https://student.valuxapps.com/storage/uploads/users/7Xk5hvfu7L_1621404411.jpeg",
// "points": 0,
// "credit": 0,
// "token": "T70fAGPonMhGEYQMDGDpixrhY8JWooC1RSSyOatQ2N8QZ1SRJA0tyWFUqGsQLuKYbTHZOy"
// }
// }
