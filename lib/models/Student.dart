
class Student {
  late String name;
  late String email;
  late String id;


  Student.empty();

  Student(this.id,this.name,this.email);

  factory Student.fromMap(Map<String,dynamic> json){
    return Student(
        json['id'],json['name'], json['email']!
    );
  }

  Student.fromJson(Map<String,dynamic> json): id=json['id'],name=json['name'],email=json['email'];

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }

}