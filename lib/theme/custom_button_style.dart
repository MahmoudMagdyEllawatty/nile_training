

import 'package:flutter/material.dart';
import 'package:nile_training/core/app_export.dart';
import 'package:nile_training/theme/theme_helper.dart';

class CustomButtonStyles{

  static ButtonStyle get fillOnPrimary => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.h)
    ),
    elevation: 0
  );


  static ButtonStyle get fillOnError => ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.onError,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h)
      ),
      elevation: 0
  );


  static ButtonStyle get none => ButtonStyle(
     backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
    side: MaterialStateProperty.all<BorderSide>(
      BorderSide(color: Colors.transparent)
    )
  );

}