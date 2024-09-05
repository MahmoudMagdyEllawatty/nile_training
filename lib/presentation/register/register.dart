

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nile_training/core/app_export.dart';
import 'package:nile_training/models/StudentLogin.dart';
import 'package:nile_training/theme/custom_button_style.dart';
import 'package:nile_training/widgets/custom_elevated_button.dart';
import 'package:nile_training/widgets/custom_text_form_field.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/Constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterState();
  }


}


class _RegisterState extends State<RegisterScreen>{




  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  List<StudentLogin> parseUser(String responseBody){
    final parsed = json.decode(responseBody);
    return parsed.map<StudentLogin>((json){
      return StudentLogin.fromMap(json);
    }).toList();

  }

  Future<String> checkLogin() async {



    final response = await http.post(
        Uri.parse(Constants.BASE_URL+"create_account"),
        headers: {"Content-type" : "application/json",
          "Accept":"application/json"},
        body: jsonEncode({
          "email": emailController.text.toString(),
          "password" : passwordController.text.toString(),
          "name" : nameController.text.toString(),
          "phone": phoneController.text.toString()
        })
    );
    if(response.statusCode == 200){
      StudentLogin login = parseUser(response.body)[0];

      if(login.code == 200){

        return "تم تسجيل الدخول بنجاح";
      }else{
        return login.msg;
      }



    }else{
      return "Not Found";
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.whiteA700,
          resizeToAvoidBottomInset: false,
          body: Container(
            height: 764.h,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 104.h),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                ImageConstant.imgGroup12
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgVector46x112,
                          height: 46.h,
                          width: 112.h,
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 218.h,),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 764.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [


                      _buildSignup(context),
                      _buildLoginSection(context),

                      CustomImageView(
                        imagePath: ImageConstant.imgNileLogo1,
                        height: 198.h,
                        width: 210.h,
                        alignment: Alignment.topCenter,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgVector,
                        height: 80.h,
                        width: 114.h,
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: 150.h),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );

  }






  Widget _buildPassword(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: CustomTextFormField(
        controller: passwordController,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 0.h, 16.h, 0.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgLock,
            height: 24.h,
            width: 20.h,
          ),
        ),
        prfixConstrains: BoxConstraints(
            maxHeight: 25.h
        ),
        contentPadding: EdgeInsets.fromLTRB(14.h, 10.h, 12.h, 10.h),
        textInputType: TextInputType.text,
        obscuringCharacter: '*',
        obscureText: true,
        hintText: "Enter Password",
      ),

    );
  }


  Widget _buildEmail(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: CustomTextFormField(
        controller: emailController,
        textInputType: TextInputType.emailAddress,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 0.h, 16.h, 0.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgBag,
            height: 20.h,
            width: 20.h,
          ),
        ),
        prfixConstrains: BoxConstraints(
            maxHeight: 20.h
        ),
        contentPadding: EdgeInsets.fromLTRB(14.h, 10.h, 12.h, 10.h),
        hintText: "Enter Email",
      ),

    );
  }

  Widget _buildName(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: CustomTextFormField(
        controller: nameController,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 0.h, 16.h, 0.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgBag,
            height: 20.h,
            width: 20.h,
          ),
        ),
        prfixConstrains: BoxConstraints(
            maxHeight: 20.h
        ),
        contentPadding: EdgeInsets.fromLTRB(14.h, 10.h, 12.h, 10.h),
        hintText: "Enter Name",
      ),

    );
  }

  Widget _buildPhone(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: CustomTextFormField(
        controller: phoneController,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 0.h, 16.h, 0.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgPhone,
            height: 20.h,
            width: 20.h,
          ),
        ),
        prfixConstrains: BoxConstraints(
            maxHeight: 20.h
        ),
        contentPadding: EdgeInsets.fromLTRB(14.h, 10.h, 12.h, 10.h),
        hintText: "Enter Phone",
        textInputType: TextInputType.phone,
      ),

    );
  }


  Widget _buildSignup(BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 170.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgGroup13
            ),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 38.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomElevatedButton(
                    text: "Create Account",
                    margin: EdgeInsets.only(left: 10.h),
                    onPressed: (){
                      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && phoneController.text.isNotEmpty
                          && nameController.text.isNotEmpty){
                        BuildContext dialogContext = context;
                        showDialog(
                          // The user CANNOT close this dialog  by pressing outsite it
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              dialogContext = context;
                              return Dialog(
                                // The background color
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:  [
                                      // The loading indicator
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      // Some text
                                      Text('Validation Login')
                                    ],
                                  ),
                                ),
                              );
                            });

                        checkLogin().then((value){
                          Navigator.pop(dialogContext);

                          if(value == 'Not Found'){
                            Fluttertoast.showToast(
                                msg: 'Invalid Email or Password',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          else{

                            Fluttertoast.showToast(
                                msg: 'Account Created',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                            Navigator.pushNamed(context, AppRoutes.loginScreen);

                          }

                        });
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: 'Please,Complete All Fields First',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }






  Widget _buildLoginSection(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        height: 294.h,
        margin: EdgeInsets.only(left: 22.h, right: 14.h, bottom: 24.h),
        child: Row(
          children: [
            Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 36.h, vertical: 32.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusStyle.roundedBorder24,
                      image: DecorationImage(
                          image: fs.Svg(
                              ImageConstant.imgGroup29
                          ),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h,),
                      _buildName(context),
                      SizedBox(height: 14.h,),
                      _buildEmail(context),
                      SizedBox(height: 14.h,),
                      _buildPhone(context),
                      SizedBox(height: 14.h,),
                      _buildPassword(context),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }



}