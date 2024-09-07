

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nile_training/core/app_export.dart';
import 'package:nile_training/core/utils/Constants.dart';
import 'package:nile_training/theme/custom_button_style.dart';
import 'package:nile_training/widgets/custom_elevated_button.dart';

import '../../theme/theme_helper.dart';
import '../../widgets/custom_text_form_field.dart';

class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }

}

class ProfileState extends State<ProfilePage>{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nameController.text = Constants.user.name;
      emailController.text = Constants.user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildName(context),
                _buildEmail(context),
                _buildPassword(context),
                _buildUpdateProfile(context),
                _buildDeleteAccount(context)
              ],
            ),
          ),
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
        hintText: "Enter Email",
        textInputType: TextInputType.emailAddress,
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
              height: 20.h,
              width: 20.h,
            ),
          ),
          prfixConstrains: BoxConstraints(
              maxHeight: 20.h
          ),
          contentPadding: EdgeInsets.fromLTRB(14.h, 10.h, 12.h, 10.h),
          hintText: 'Enter Password',
          textInputType: TextInputType.text,
          obscuringCharacter: '*',
          obscureText: true,

        ),
    );
  }
  
  
  Widget _buildUpdateProfile(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: CustomElevatedButton(
        text: "Update Profile",
        onPressed: () => {

        },),
    );
  }

  Widget _buildDeleteAccount(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: CustomElevatedButton(
        buttonStyle: CustomButtonStyles.fillOnPrimary,
        text: "Request Delete Account",
        onPressed: () => {
            Fluttertoast.showToast(msg: "We received your request.Delete account may take up to 3 days",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 14.0)
        },),
    );
  }

}