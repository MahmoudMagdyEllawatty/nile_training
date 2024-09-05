
import 'dart:convert';

import 'Student.dart';


class StudentLogin {
  late String msg;
  late int code;
  late Student? user;

  StudentLogin.empty();

  StudentLogin(this.msg,this.code,this.user);

  factory StudentLogin.fromMap(Map<String,dynamic> data){

    if(data['user'] != null){
      var uu = jsonEncode(data['user']);
      final parsed = json.decode(uu);

      Map<String,dynamic> employerMap = jsonDecode(uu);

      return StudentLogin(
          data['msg'] as String,
          data['code'] as int,
          Student.fromJson(employerMap)
      );
    }else{

      return StudentLogin(
          data['msg'] as String,
          data['code'] as int,
          data['user']
      );
    }

  }




  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['user'] = this.user;
    return data;
  }

}