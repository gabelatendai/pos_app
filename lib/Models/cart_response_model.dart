
class CartResponseModel{
  bool status;
  List<CartItem> data;
  CartResponseModel({this.status,this.data});

  CartResponseModel.fromJson(Map<String, dynamic>json){
    status=json['status'];
    if(json['data']!=null){
      data= new List<CartItem>();
      json['data'].forEach((v){
        data.add((new CartItem.fromJson(v)));
      });
    }
  }
  Map<String,dynamic>toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status']=this.status;
    if(this.data!=null){
      data['data']= this.data.map((v) => v.toJson()).toList();

    }
  }
}
class CartItem{
  String id;
  String cartid;
  String title;
  double price;
  int qnty;
  String category;
  double subtotal;


  CartItem(
      {this.id,
      this.cartid,
      this.title,
      this.price,
      this.qnty,
      this.category,
      this.subtotal,}
      );
  CartItem.fromJson(Map<String,dynamic> json){
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