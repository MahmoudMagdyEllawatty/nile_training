
class Course{
  late String id;
  late String name;
  late String startDate;
  late String endDate;
  late String teacherName;
  late String notes;
  late String cashPrice;
  late String installmentsPrice;
  late String image;


  Course.empty();


  Course(this.id,this.name, this.startDate, this.endDate,this.teacherName,this.notes,this.cashPrice,this.installmentsPrice,
      this.image);

}