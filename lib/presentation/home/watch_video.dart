
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:nile_training/core/app_export.dart';
import 'package:nile_training/presentation/login/login.dart';
import 'package:nile_training/widgets/custom_elevated_button.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../core/utils/Constants.dart';
import '../../models/Category.dart';
import '../../models/Course.dart';
import '../../models/Video.dart';
import '../../theme/theme_helper.dart';
import 'home.dart';

class WatchVideoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return VideoState();
  }

}


class VideoState extends State<WatchVideoPage> {

  //late final WebViewController _controller;
  bool isFullScreen = false;
  final _noScreenshot = NoScreenshot.instance;

  bool isRecording = false;
  bool isScreen = false;
  static const platform = MethodChannel('com.example.app/screenRecording');
  static const platformScreenShot = MethodChannel('com.example.screenshotProtection');

  static const androidPlatform = MethodChannel('com.example.app/screen_recording_detection'); // نفس اسم القناة من Java

  String _screenRecordStatus = "Not started";


   void startListeningForScreenshots() {
    platformScreenShot.setMethodCallHandler((call) async {
      if (call.method == "screenshotTaken") {
        // Handle screenshot event, e.g., hide or blur video

        hideVideo();
        // You can show a black view or blur the video.
      }
    });
  }

  void hideVideo(){
     setState(() {
       isScreen = true;
     });
     sendStatic(3);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // ضبط اتجاه الشاشة على الوضع العرضي
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    platform.setMethodCallHandler(_methodCallHandler);
    startListeningForScreenshots();
    sendStatic(1);

  }

  void sendStatic(int type) async{
    final uri = Uri.parse(Constants.BASE_URL+"statics");
    final request = http.MultipartRequest('POST', uri);
    request.fields["user_id"] = Constants.user.id.toString();
    request.fields["video_id"] = Constants.video.id.toString();
    request.fields["action"] = type.toString();
    final response = await request.send();
  }

// Method to handle platform channel callbacks
  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == 'screenRecordingDetected') {
      setState(() {
        isRecording = true;
      });
      sendStatic(2);
      showExitDialog(context);
    } else if (call.method == 'screenRecordingStopped') {
      setState(() {
        isRecording = false;
      });
    }
  }


  void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the dialog from being dismissed outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!!'),
          content: Text('Screen Record Not available'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
                // Close the app

              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    platform.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnnotatedRegion<SystemUiOverlayStyle>(

      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: isFullScreen ? true : false,
        resizeToAvoidBottomInset: false,
        appBar: isFullScreen ? null : AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(Constants.video.name, style: theme.textTheme.titleLarge!.copyWith(height: 1.60)),
          actions: [
            IconButton(
              icon: Icon(Icons.fullscreen),
              onPressed: () {
                setState(() {
                  isFullScreen = true;
                });
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // إخفاء كل شيء
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // ✅ الفيديو بكامل الشاشة
            Visibility(
              visible: isFullScreen,
              child: Transform.scale(
                scale: 1.05, // زوّدها حسب المساحات المتبقية يمين ويسار
                child: VimeoPlayer(
                  videoId: Constants.video.link,
                ),
              ),
            ),
            Visibility(
              visible: !isFullScreen,
              child: Transform.scale(
                scale: 1, // زوّدها حسب المساحات المتبقية يمين ويسار
                child: VimeoPlayer(
                  videoId: Constants.video.link,
                ),
              ),
            ),


            // ✅ زر الخروج من fullscreen
            if (isFullScreen)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isFullScreen = false;
                    });
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  },
                ),
              ),

            // ✅ رسالة لقطة الشاشة
            if (isScreen)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Screenshot not available!!", style: TextStyle(color: Colors.white)),
                    SizedBox(height: 20),
                    CustomElevatedButton(
                      text: "Resume Video",
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      onPressed: () {
                        setState(() {
                          isScreen = false;
                        });
                      },
                    )
                  ],
                ),
              ),

            // ✅ رسالة التسجيل
            if (isRecording)
              Center(
                child: Text("Screen Record not available!!", style: TextStyle(color: Colors.white)),
              ),
          ],
        ),

      ),
    );
  }

}