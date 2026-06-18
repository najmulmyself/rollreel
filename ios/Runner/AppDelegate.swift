import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "rollreel/app_icon",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "setIcon":
        guard UIApplication.shared.supportsAlternateIcons else {
          result(false)
          return
        }
        let args = call.arguments as? [String: Any]
        let iconName = args?["iconName"] as? String
        UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error = error {
            result(FlutterError(code: "SET_ICON_FAILED", message: error.localizedDescription, details: nil))
          } else {
            result(true)
          }
        }
      case "currentIcon":
        result(UIApplication.shared.alternateIconName)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
