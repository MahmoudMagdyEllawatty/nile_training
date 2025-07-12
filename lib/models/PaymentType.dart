
class PaymentType {
  late String id;
  late String type;


  PaymentType.empty();


  PaymentType(this.id,this.type);

  PaymentType.fromJson(Map<String,dynamic> json):
        id  =json['id'],
        type =json['type'];

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;

    return data;
  }
}