import UIKit
import AVFoundation
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  var screenRecordingObserver: NSObjectProtocol?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // Register platform views if necessary
              if #available(iOS 14.0, *) {
                  GeneratedPluginRegistrant.register(with: self)
              }
    // Register the platform channel.
    let controller = window?.rootViewController as! FlutterViewController
    let screenRecordingChannel = FlutterMethodChannel(name: "com.example.app/screenRecording",
                                                      binaryMessenger: controller.binaryMessenger)

    // Monitor screen capture events
    monitorScreenRecording(screenRecordingChannel: screenRecordingChannel)

      // Listen for screenshot notification
         NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    @objc func didTakeScreenshot() {
        // Notify Flutter that a screenshot was taken
        if let controller = window?.rootViewController as? FlutterViewController {
          let channel = FlutterMethodChannel(name: "com.example.screenshotProtection", binaryMessenger: controller.binaryMessenger)
          channel.invokeMethod("screenshotTaken", arguments: nil)
        }
      }
    
  func monitorScreenRecording(screenRecordingChannel: FlutterMethodChannel) {
    NotificationCenter.default.addObserver(
      forName: UIScreen.capturedDidChangeNotification,
      object: nil,
      queue: nil) { _ in
        if UIScreen.main.isCaptured {
          // Screen recording detected, send message to Flutter
          screenRecordingChannel.invokeMethod("screenRecordingDetected", arguments: nil)
        } else {
          // Screen recording stopped, send message to Flutter
          screenRecordingChannel.invokeMethod("screenRecordingStopped", arguments: nil)
        }
    }
  }
}
