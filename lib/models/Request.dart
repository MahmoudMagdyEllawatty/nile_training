
class Request{
  late String id;
  late String course_name;
  late String notes;
  late String payment_type;
  late String amount;
  late String paid_by;
  late String date;
  late String state;


  Request.empty();


  Request(this.id,this.course_name, this.paid_by, this.payment_type,this.state,this.amount,this.notes,this.date);

}