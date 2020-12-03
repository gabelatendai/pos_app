class Pay{

  String _currency;
  double _amount;
  double _rate;



  Pay(

      this._currency,
      this._amount,
      this._rate,
     );

  Pay.map(dynamic obj){

    this._currency = obj['currency'];

    this._amount = obj['amount'];
    this._rate = obj['rate'];


  }


  String get currency => _currency;

  double get  amount=> _amount;
  double get  rate=> _rate;


  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();

    map['currency'] = _currency;

    map['amount']=_amount;
    map['rate']=_rate;

    return map;
  }

  Pay.fromMap(Map<String,dynamic> map){
    this._currency = map['currency'];
   this._amount= map['amount'];
    this._rate= map['rate'];


  }

}