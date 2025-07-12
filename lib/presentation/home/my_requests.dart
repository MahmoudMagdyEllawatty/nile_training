

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nile_training/widgets/course_request_item.dart';

import '../../core/utils/Constants.dart';

import 'package:http/http.dart' as http;

import '../../models/Request.dart';
import '../../theme/theme_helper.dart';
class MyRequestsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyRequestsState();
  }

}

class _MyRequestsState extends State<MyRequestsPage>{

  List<Request> courses = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRequests();
  }

  Future<String> loadRequests() async{

    final response = await http.post(
        Uri.parse(Constants.BASE_URL+"my_requests"),
        headers: {
          "Content-type" : "application/json",
          "Accept":"application/json"
        },
        body:jsonEncode({
          "user_id" : Constants.user.id
        })
    );
    if(response.statusCode == 200){
      setState(() {

        dynamic parsed = json.decode(response.body);
        final coursesData = parsed['courses'];

        for(int i = 0;i< parsed['products_count'];i++){
          final catObj = coursesData[i];
          Request  course = Request(catObj['id'].toString(),
              catObj['course_name']
              ,catObj['paid_by'],
              catObj['payment_type'],
              catObj['state'],
              catObj['amount'] ,
              catObj['notes'] ?? "",
              catObj['date']??"");

          courses.add(course);
        }

      });
      return "تم تسجيل الدخول بنجاح";
    }else{
      return "";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10.0),
          color: Color(0xE00909),
          child: GridView.count(
            crossAxisCount: 1,
            children: new List<Widget>.generate(
                courses.length,
                    (index) {
                  return  CourseRequestItem(courseName: courses[index].course_name, date: courses[index].date,
                      amount: courses[index].amount,
                      status: courses[index].state.toString());
                }),

          )

      ),
    );
  }

}