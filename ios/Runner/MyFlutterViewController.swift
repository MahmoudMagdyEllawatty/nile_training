import UIKit
import Flutter

class MyFlutterViewController: FlutterViewController {

    var screenRecordingChannel: FlutterMethodChannel?
    var screenRecordingObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the method channel for screen recording events
        screenRecordingChannel = FlutterMethodChannel(name: "com.example.app/screenRecording", binaryMessenger: self.binaryMessenger)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Re-attach the screen recording observer when the view appears
        monitorScreenRecording()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove observer to avoid memory leaks
        stopScreenRecording()
    }

    func monitorScreenRecording() {
        screenRecordingObserver = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            
            if UIScreen.main.isCaptured {
                // Screen recording detected, send message to Flutter
                DispatchQueue.main.async {
                    self.screenRecordingChannel?.invokeMethod("screenRecordingDetected", arguments: nil)
                }
            } else {
                // Screen recording stopped, send message to Flutter
                DispatchQueue.main.async {
                    self.screenRecordingChannel?.invokeMethod("screenRecordingStopped", arguments: nil)
                }
            }
        }
    }

    func stopScreenRecording() {
        if let observer = screenRecordingObserver {
            NotificationCenter.default.removeObserver(observer)
            screenRecordingObserver = nil
        }
    }
}
