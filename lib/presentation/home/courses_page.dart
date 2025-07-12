


import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:nile_training/core/app_export.dart';
import '../../core/utils/Constants.dart';
import '../../models/Course.dart';
import '../../theme/theme_helper.dart';

class  MyCoursesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CoursesPageState();
  }

}

class _CoursesPageState extends State<MyCoursesPage>{
  List<Course> courses = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadcourses();
  }


  Future<String> loadcourses() async{

    final response = await http.post(
        Uri.parse(Constants.BASE_URL+"my_courses"),
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
          Course  course = Course(catObj['id'].toString(), catObj['name']
              ,catObj['start_date'],catObj['end_date'],
              catObj['teacherName'] ?? "",
              catObj['notes'] ?? "",
              catObj['cash_price'] != null ? catObj['cash_price'].toString() : "",
              catObj['installments_price'] != null ? catObj['installments_price'].toString() : "",
              catObj['image'] ?? "",
              catObj['can_watch'].toString());

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
    // TODO: implement build
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10.0),
          color: Color(0xE00909),
          child: GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 1.3,
            children: new List<Widget>.generate(
                courses.length,
                    (index) {
                  return  GridTile(
                      child: GestureDetector(
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.h)),
                                side: BorderSide(
                                  // border color
                                    color: Colors.transparent,
                                    // border thickness
                                    width: 1)),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(child: Container(
                                  padding: EdgeInsets.all(5.h),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.h),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgDefaultCourse,
                                      height: 200.h,
                                      width: double.maxFinite,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),),
                                Center(child: Text(courses[index].name,style: theme.textTheme.bodySmall!.copyWith(height: 1.60),)),
                              ],
                            )
                        ),
                        onTap: (){
                          Constants.course = courses[index];
                          if(Constants.user.id == "0"){
                            Navigator.pushNamed(
                                context, AppRoutes.loginScreen);
                          }else {
                            Navigator.pushNamed(
                                context, AppRoutes.courseDetailsScreen);
                          }
                        },
                      )
                  );
                }),

          )

      ),
    );

  }

}