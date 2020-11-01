// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  Products({
    this.id,
    this.productCode,
    this.productDescrip,
    this.tax,
    this.stockGroup,
    this.qty,
    this.branch,
    this.company,
    this.costing,
    this.siUnit,
    this.minimumLevel,
    this.reorderLevel,
    this.purchaseAcount,
    this.salesAcc,
    this.status,
    this.shareStock,
    this.ratioQnty,
    this.typ,
    this.price,
    this.fqty,
    this.category,
    this.addedby,
    this.addon,
    this.tqty,
    this.productId,
    this.picture,
  });

  String id;
  String productCode;
  String productDescrip;
  String tax;
  String stockGroup;
  String qty;
  String branch;
  String company;
  String costing;
  String siUnit;
  String minimumLevel;
  String reorderLevel;
  String purchaseAcount;
  String salesAcc;
  String status;
  String shareStock;
  String ratioQnty;
  String typ;
  String price;
  String fqty;
  String category;
  String addedby;
  DateTime addon;
  String tqty;
  String productId;
  String picture;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    productCode: json["product_code"],
    productDescrip: json["product_Descrip"],
    tax: json["tax"],
    stockGroup: json["stock_group"],
    qty: json["qty"],
    branch: json["branch"],
    company: json["company"],
    costing: json["costing"],
    siUnit: json["SI_unit"],
    minimumLevel: json["minimum_level"],
    reorderLevel: json["reorder_level"],
    purchaseAcount: json["Purchase-acount"] == null ? null : json["Purchase-acount"],
    salesAcc: json["Sales_Acc"] == null ? null : json["Sales_Acc"],
    status: json["status"],
    shareStock: json["share_stock"] == null ? null : json["share_stock"],
    ratioQnty: json["ratio_qnty"],
    typ: json["typ"],
    price: json["price"],
    fqty: json["fqty"],
    category: json["category"],
    addedby: json["addedby"],
    addon: DateTime.parse(json["addon"]),
    tqty: json["tqty"],
    productId: json["product_id"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_code": productCode,
    "product_Descrip": productDescrip,
    "tax": tax,
    "stock_group": stockGroup,
    "qty": qty,
    "branch": branch,
    "company": company,
    "costing": costing,
    "SI_unit": siUnit,
    "minimum_level": minimumLevel,
    "reorder_level": reorderLevel,
    "Purchase-acount": purchaseAcount ,
    "Sales_Acc": salesAcc,
    "status": status,
    "share_stock": shareStock ,
    "ratio_qnty": ratioQnty,
    "typ": typ,
    "price": price,
    "fqty": fqty,
    "category": category,
    "addedby": addedby,
    "addon": "${addon.year.toString().padLeft(4, '0')}-${addon.month.toString().padLeft(2, '0')}-${addon.day.toString().padLeft(2, '0')}",
    "tqty": tqty,
    "product_id": productId,
    "picture": picture,
  };
}
