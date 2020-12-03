class Food {
  String product_id;
  String price;
  String name;
  // String category;
  String qnty;

  Food(String name,String price,String qnty,String product_id) {
    this.name = name;this.price = price;this.qnty = qnty;
    this.product_id = product_id;
    // this.category = category;
  }
}
