
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:nile_training/core/app_export.dart';

import '../../core/utils/Constants.dart';
import '../../models/Category.dart';
import '../../models/Course.dart';
import '../../theme/theme_helper.dart';

class CoursesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CoursesState();
  }

}


class CoursesState extends State<CoursesPage>{

  List<Course> courses = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadcourses();
  }


  Future<String> loadcourses() async{
    
    final response = await http.post(
      Uri.parse(Constants.BASE_URL+"courses"),
      headers: {
        "Content-type" : "application/json",
        "Accept":"application/json"
      },
      body:jsonEncode({
        "category_id": Constants.category.id
      })
    );
    if(response.statusCode == 200){
      setState(() {

        dynamic parsed = json.decode(response.body);
        final coursesData = parsed['courses'];

        for(int i = 0;i< parsed['products_count'];i++){
          final catObj = coursesData[i];
          Course  course = Course(catObj['id'], catObj['name'],catObj['start_date'],catObj['end_date'],
          catObj['teacherName'] ?? "",
              catObj['notes'] ?? "",
              catObj['cash_price'] ?? "",
              catObj['installments_price'] ?? "",
          catObj['image'] ?? "");

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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(Constants.category.name,style: theme.textTheme.titleLarge!.copyWith(height: 1.60),),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          color: Color(0xE00909),
          child: GridView.count(
            crossAxisCount: 1,
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
                                      height: 250.h,
                                      width: double.maxFinite,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),),
                                Center(child: Text(courses[index].name,style: theme.textTheme.bodyMedium!.copyWith(height: 1.60),)),
                              ],
                            )
                        ),
                        onTap: (){
                          Constants.course = courses[index];
                          Navigator.pushNamed(context, AppRoutes.courseDetailsScreen);
                        },
                      )
                  );
                }),

          )

      ),
    );
  }

}