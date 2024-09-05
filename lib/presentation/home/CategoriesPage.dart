
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:nile_training/core/app_export.dart';

import '../../core/utils/Constants.dart';
import '../../models/Category.dart';
import '../../theme/theme_helper.dart';

class CategoriesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }

}


class CategoriesState extends State<CategoriesPage>{

  List<Category> categories = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCategories();
  }


  Future<String> loadCategories() async{
    final response = await http.get(
        Uri.parse(Constants.BASE_URL+"categories"),
        headers: {
          "Content-type" : "application/json",
          "Accept":"application/json"
        },
    );
    if(response.statusCode == 200){
      setState(() {

        dynamic parsed = json.decode(response.body);
        final categoriesData = parsed['categories'];

        for(int i = 0;i< parsed['products_count'];i++){
          final catObj = categoriesData[i];
          Category  category = Category(catObj['id'], catObj['name']);
          categories.add(category);
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
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Color(0xE00909),
      child: GridView.count(
        crossAxisCount: 2,
        children: new List<Widget>.generate(
            categories.length,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.h),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgDefaultCategory,
                                      height: 50.h,
                                      width: 50.h,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),),
                                Center(child: Text(categories[index].name,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),)),
                              ],
                            )
                        ),
                        onTap: () {
                          Constants.category = categories[index];
                          
                          Navigator.pushNamed(context, AppRoutes.coursesScreen);
                        },
                      )
                  );
                }),

      )

    );
  }

}