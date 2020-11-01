
import 'package:flutter/material.dart';


class ProductDescription extends StatefulWidget {
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
  ProductDescription({Key key,
    @required this.id,
    @required this.productCode,
    @required this.productDescrip,
    @required this.tax,
    @required this.stockGroup,
    @required this.qty,
    @required this.branch,
    @required this.company,
    @required this.costing,
    @required this.siUnit,
    @required this.minimumLevel,
    @required this.reorderLevel,
    @required this.purchaseAcount,
    @required this.salesAcc,
    @required this.status,
    @required this.shareStock,
    @required this.ratioQnty,
    @required this.typ,
    @required this.price,
    @required this.fqty,
    @required this.category,
    @required this.addedby,
    @required this.addon,
    @required this.tqty,
    @required this.productId,
    @required this.picture,}): super(key: key);

  @override
  ProductDescriptionState createState() => ProductDescriptionState();
}

class ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
appBar: AppBar(),
      body: Center(
        child:ListView(
          children: [
            Image.network(widget.picture),
            Text(widget.productDescrip)
          ],
        ) ,
      )
    );
  }
}
 