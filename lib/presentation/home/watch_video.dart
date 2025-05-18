
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
import 'package:screen_capture_utils/screen_capture_utils.dart';
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
  final _noScreenshot = NoScreenshot.instance;

  bool isRecording = false;
  bool isScreen = false;
  static const platform = MethodChannel('com.example.app/screenRecording');
  static const platformScreenShot = MethodChannel('com.example.screenshotProtection');

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
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _noScreenshot.screenshotOff();
    // Listen for screen recording changes.
    platform.setMethodCallHandler(_methodCallHandler);
    startListeningForScreenshots();

    // #docregion platform_features
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
//     // #enddocregion platform_features
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(Uri.parse('https://admin.nilefortraining.com/video/play/'+Constants.video.link));
//
//     // setBackgroundColor is not currently supported on macOS.
//     if (kIsWeb || !Platform.isMacOS) {
//       controller.setBackgroundColor(const Color(0x80000000));
//     }
//
//     // #docregion platform_features
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
    // #enddocregion platform_features

    //_controller = controller;


    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: []);
    // initPlatformState();
    //
    // WidgetsBinding.instance!.addObserver(this);
  }


// Method to handle platform channel callbacks
  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == 'screenRecordingDetected') {
      setState(() {
        isRecording = true;
      });
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
    platform.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(isRecording);
    print(isScreen);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(Constants.video.name,style: theme.textTheme.titleLarge!.copyWith(height: 1.60),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Visibility(
             visible: !isRecording && !isScreen,
             child: Expanded(
               child: Container(
                   padding: EdgeInsets.all(10.0),
                   color: Color(0xE00909),
                   child: Container(
                     child: SafeArea(
                       child: Visibility(
                         visible: !isRecording,
                         child: VimeoPlayer(
                           videoId: "1048331820",
                         ),
                       ),
                     ),
                   )
               
               ),
             ),
           ),
           Visibility(
             visible: isScreen,
             child: Container(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Screenshot not available!!"),
                   CustomElevatedButton(
                       text: "Resume Video",
                     margin: EdgeInsets.only(left: 20.h,right: 20.h),
                     onPressed: (){
                       setState(() {
                         isScreen = false;
                       });
                     },

                   )
                 ],
               ),
             ),
           ),
           Visibility(
             visible: isRecording,
             child: Container(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Screen Record not available!!")
                 ],
               ),
             ),
           )
         ],
      ),
    );
  }

}