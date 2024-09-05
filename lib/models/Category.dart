
class Category{
  late String id;
  late String name;


  Category.empty();


  Category(this.id,this.name);

  Category.fromJson(Map<String,dynamic> json):
        id  =json['id'],
        name =json['name'];

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    return data;
  }
}