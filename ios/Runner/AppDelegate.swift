import UIKit
import Flutter

class BlurView:UIView {
    override func willMove(toSuperview newSuperview: UIView?){
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            self.layer.sublayers?.forEach{ $0.removeFromSuperlayer()}
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = self.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurView)
        }
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
    var blurView: BlurView?


    override func applicationWillResignActive(_ application: UIApplication){
        if blurView == nil {
            blurView = BlurView(frame: window!.bounds)
            window?.addSubview(blurView!)
        }
    }

    override func applicationDidBecomeActive(_ application: UIApplication){
        blurView?.removeFromSuperview()
        blurView = nil
    }


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    self.window.makeSecure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
//And this extension
extension UIWindow {
func makeSecure() {
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.first?.addSublayer(self.layer)
  }
}
