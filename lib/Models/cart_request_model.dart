
class CartRequestModel{
  int userId;
  List<CartProducts> products;
  CartRequestModel({this.userId,this.products});

  CartRequestModel.fromJson(Map<String, dynamic>json){
    userId=json['user_id'];
    if(json['products']!=null){
      products= new List<CartProducts>();
      json['products'].forEach((v){
        products.add((new CartProducts.fromJson(v)));
      });
    }
  }
  Map<String,dynamic>toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id']=this.userId;
    if(this.products!=null){
      data['products']= this.products.map((v) => v.toJson()).toList();

    }
    return data;
  }
}
class CartProducts{
  String id;
  String cartid;
  String title;
  double price;
  int qnty;
  String category;
  double subtotal;


  CartProducts(
      {this.id,
      this.cartid,
      this.title,
      this.price,
      this.qnty,
      this.category,
      this.subtotal,}
      );
  CartProducts.fromJson(Map<String,dynamic> json){
    id= json['id'];
    cartid = json['cartid'];
    category = json['category'];
    title= json['title'];
    price= json['price'];
    subtotal = json['subtotal'];
    qnty = json['qnty'];

  }


  Map<String,dynamic> toJson(){
    final Map<String,dynamic>  data=new Map<String,dynamic>();
    data['id']=this.id;
    data['cartid'] = this.cartid;
    data['category'] = this.category;
    data['title']=this.title;
    data['price']=this.price;
    data['subtotal'] = this.subtotal;
    data['qnty'] = this.qnty;
    return data;
  }


}