
import 'package:flutter/material.dart';
import 'package:nile_training/presentation/home/CoursesPage.dart';
import 'package:nile_training/presentation/home/course_details.dart';
import 'package:nile_training/presentation/home/home.dart';
import 'package:nile_training/presentation/home/watch_video.dart';
import 'package:nile_training/presentation/login/login.dart';
import 'package:nile_training/presentation/register/register.dart';
import '../presentation/home/course_videos.dart';
import '../presentation/splash/splash.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String zeroScreen = '/zero_screen';

  static const String initialRoute = '/initialRoute';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String homeScreen = "/home";
  static const String coursesScreen = "/courses";
  static const String courseDetailsScreen = "/course_details";
  static const String courseVideosScreen = "/course_videos";
  static const String watchVideoScreen = "/watch_video";

  static Map<String, WidgetBuilder> routes = {
    zeroScreen: (context) => SplashScreen(),
    initialRoute: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
    registerScreen: (context)=> RegisterScreen(),
    homeScreen: (context) => HomePage(),
    coursesScreen : (context) => CoursesPage(),
    courseDetailsScreen: (context) => CourseDetailsPage(),
    courseVideosScreen : (context) => VideosPage(),
    watchVideoScreen : (context) => WatchVideoPage()
  };
}
