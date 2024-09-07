

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nile_training/core/app_export.dart';
import 'package:nile_training/models/StudentLogin.dart';
import 'package:nile_training/presentation/home/home.dart';
import 'package:nile_training/theme/custom_button_style.dart';
import 'package:nile_training/widgets/custom_elevated_button.dart';
import 'package:nile_training/widgets/custom_text_form_field.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/Constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }


}


class _LoginState extends State<LoginScreen>{




  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<StudentLogin> parseUser(String responseBody){
    final parsed = json.decode(responseBody);
    return parsed.map<StudentLogin>((json){
      return StudentLogin.fromMap(json);
    }).toList();

  }

  Future<String> checkLogin() async {



    final response = await http.post(
        Uri.parse(Constants.BASE_URL+"check_login"),
        headers: {"Content-type" : "application/json",
          "Accept":"application/json"},
        body: jsonEncode({
          "email": emailController.text.toString(),
          "password" : passwordController.text.toString()
        })
    );
    if(response.statusCode == 200){
      StudentLogin login = parseUser(response.body)[0];

      if(login.code == 200){
        Constants.user = login.user!;

        final SharedPreferences prefs = await _prefs;
        prefs.setString("email", emailController.text.toString());
        prefs.setString("password", passwordController.text.toString());
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

    _prefs.then((value) {
      String phone =value.getString("email") ?? "";
      String password = value.getString("password") ?? "";

      if(phone.isNotEmpty){

        setState(() {
          emailController.text = phone;
          passwordController.text = password;
        });


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
                      Text('Validating Login')
                    ],
                  ),
                ),
              );
            });

        checkLogin().then((value){
          Navigator.pop(dialogContext);

          if(value == 'Not Found'){
            Fluttertoast.showToast(
                msg: "Phone or Password is not correct",
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
                msg: "Welcome "+Constants.user.name,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          }

        });
      }
      else{

      }

    });
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.whiteA700,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
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
                          SizedBox(height: 28.h,),
                          _buildDiscoverCoursesSection(context),
                          SizedBox(height: 138.h)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 764.h,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgGroup13,
                          height: 400.h,
                          width: double.maxFinite,
                        ),
                        _buildLoginSection(context),
                        _buildImageStackCollection(context),
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
          ),
        )
    );

  }



  Widget _buildDiscoverCoursesSection(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 22.h,right: 14.h),
        padding: EdgeInsets.only(left: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Discover the best \nonline Courses",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge!.copyWith(height: 1.56),
            )
          ],
        ),
      ),
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
        textInputType: TextInputType.emailAddress,
      ),

    );
  }


  Widget _buildLogin(BuildContext context){
    return CustomElevatedButton(
      text: "Login",
      margin: EdgeInsets.only(left: 10.h),
      onPressed: (){
        if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
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
                  msg: "Welcome "+Constants.user.name,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
              );

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
    );
  }

  Widget _buildRegister(BuildContext context){
    return CustomElevatedButton(
      text: "Register",
      margin: EdgeInsets.only(left: 10.h),
      buttonStyle: CustomButtonStyles.fillOnPrimary,
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.registerScreen);
      },
    );
  }


  Widget _buildLoginSection(BuildContext context){
    return Container(
        height: 380.h,
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
                      Padding(
                          padding: EdgeInsets.only(left: 16.h),
                        child: Text(
                          "Welcome Back,\nLogin Now",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge!.copyWith(height: 1.60),
                        ),

                      ),
                      SizedBox(height: 24.h,),
                      _buildEmail(context),
                      SizedBox(height: 14.h,),
                      _buildPassword(context),
                      SizedBox(height: 14.h,),
                      _buildLogin(context),
                      SizedBox(height: 8.h,),
                      _buildRegister(context),
                    ],
                  ),
                )
            )
          ],
        ),
      
    );
  }


  Widget _buildImageStackCollection(BuildContext context){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 146.h,
        margin: EdgeInsets.only(left: 22.h, top: 222.h, right: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 14.h),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgFrame,
              height: 104.h,
              width: 104.h,
              margin: EdgeInsets.only(left: 8.h),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgImage40,
              height: 123.h,
              width: 264.h,
              alignment: Alignment.topRight,
            )
          ],
        ),
      ),
    );
  }

}