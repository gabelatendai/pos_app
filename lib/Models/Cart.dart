class Cart{
  String _id;
  String _cartid;
  String _title;
  double _price;
  int _qnty;
  String _category;
  double _subtotal;


  Cart(
      this._id,
      this._cartid,
      this._title,
      this._price,
      this._qnty,
      this._category,
      this._subtotal,
     );

  Cart.map(dynamic obj){
    this._id = obj['id'];
    this._cartid = obj['cartid'];
    this._category = obj['category'];
    this._title = obj['title'];
    this._price = obj['price'];
    this._subtotal = obj['subtotal'];
    this._qnty = obj['qnty'];

  }

  String get  id=> _id;
  String get cartid => _cartid;
  String get category => _category;
  String get  title=> _title;
  double get  price=> _price;
  double get subtotal => _subtotal;
  int get qnty => _qnty;


  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['id']=_id;
    map['cartid'] = _cartid;
    map['category'] = _category;
    map['title']=_title;
    map['price']=_price;
    map['subtotal'] = _subtotal;
    map['qnty'] = _qnty;
    return map;
  }

  Cart.fromMap(Map<String,dynamic> map){
    this._id= map['id'];
    this._cartid = map['cartid'];
    this._category = map['category'];
    this._title= map['title'];
    this._price= map['price'];
    this._subtotal = map['subtotal'];
    this._qnty = map['qnty'];

  }
String getIndex(int index) {
  switch (index) {
    case 0:
      return _id;
    case 1:
      return _title;
    case 2:
      return _price.toString();
    case 3:
      return _qnty.toString();
    case 4:
      return _subtotal.toString();
  }
  return '';
}
}