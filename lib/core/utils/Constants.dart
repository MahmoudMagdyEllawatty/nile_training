
import 'package:nile_training/models/Course.dart';
import 'package:nile_training/models/Student.dart';
import 'package:nile_training/models/Video.dart';

import '../../models/Category.dart';

class Constants{
  static String BASE_URL = 'https://admin.nilefortraining.com/api/';

  static Student user = Student.empty();
  static Category category = Category.empty();
  static Course course = Course.empty();

  static Video video = Video.empty();
}