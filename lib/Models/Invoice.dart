class ModelClass {
  bool success;
  List<Data> data;
  String message;

  ModelClass({this.success, this.data, this.message});

  ModelClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  String productName;
  int userId;
  int quantity;
  int price;
  List<dynamic> customFields;

  Data(
      {this.id,
        this.productName,
        this.userId,
        this.quantity,
        this.price,
        this.customFields});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    userId = json['user_id'];
    quantity = json['quantity'];
    price = json['price'];
    customFields = json['custom_fields'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['user_id'] = this.userId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['custom_fields'] = this.customFields;
    return data;
  }
}