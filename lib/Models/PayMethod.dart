// To parse this JSON data, do
//
//     final paymentMenthod = paymentMenthodFromJson(jsonString);

import 'dart:convert';

List<PaymentMenthod> paymentMenthodFromJson(String str) => List<PaymentMenthod>.from(json.decode(str).map((x) => PaymentMenthod.fromJson(x)));

String paymentMenthodToJson(List<PaymentMenthod> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentMenthod {
  PaymentMenthod({
    this.id,
    this.currency,
    this.exchangeRate,
    this.status,
    this.addedby,
    this.addon,
    this.classification,
    this.company,
    this.shop,
    this.symbol,
    this.type,
    this.postcode,
  });

  String id;
  String currency;
  String exchangeRate;
  String status;
  String addedby;
  String addon;
  String classification;
  String company;
  String shop;
  String symbol;
  String type;
  String postcode;

  factory PaymentMenthod.fromJson(Map<String, dynamic> json) => PaymentMenthod(
    id: json["id"],
    currency: json["currency"],
    exchangeRate: json["exchange_rate"],
    status: json["status"],
    addedby: json["addedby"],
    addon: json["addon"],
    classification: json["classification"],
    company: json["company"],
    shop: json["shop"],
    symbol: json["symbol"],
    type: json["type"],
    postcode: json["postcode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currency": currency,
    "exchange_rate": exchangeRate,
    "status": status,
    "addedby": addedby,
    "addon": addon,
    "classification": classification,
    "company": company,
    "shop": shop,
    "symbol": symbol,
    "type": type,
    "postcode": postcode,
  };
}
