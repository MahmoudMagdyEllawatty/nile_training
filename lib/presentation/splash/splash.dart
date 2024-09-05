import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashState();
  }


}


class _SplashState extends State<SplashScreen>{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRoutes.loginScreen);
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        body: Container(
          height: 764.h,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildWelcomeSection(context),
              CustomImageView(
                imagePath: ImageConstant.imgNileLogo1,
                height: 266.h,
                width: 266.h,
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 128.h),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgVector,
                height: 80.h,
                width: 114.h,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 150.h),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgVector46x112,
                height: 46.h,
                width: 112.h,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 104.h),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      height: 400.h,
      padding: EdgeInsets.only(top: 42.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgGroup2,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImage40,
            height: 160.h,
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 66.h),
          ),
          Container(
            width: 138.h,
            margin: EdgeInsets.only(
              left: 70.h,
              top: 18.h,
            ),
            child: Text(
              "Welcome Back,\nLogin Now",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge!.copyWith(
                height: 1.60,
              ),
            ),
          )
        ],
      ),
    );
  }
}
