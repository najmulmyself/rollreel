import Flutter
import StoreKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let registrar = registrar(forPlugin: "RollReelStoreKitEntitlements") {
      FlutterMethodChannel(
        name: "rollreel/storekit_entitlements",
        binaryMessenger: registrar.messenger()
      ).setMethodCallHandler { call, result in
        if call.method == "isSupported" {
          if #available(iOS 15.0, *) {
            result(true)
          } else {
            result(false)
          }
          return
        }

        guard #available(iOS 15.0, *) else {
          result(FlutterMethodNotImplemented)
          return
        }

        switch call.method {
        case "currentEntitlements":
          Task { @MainActor in
            await Self.currentEntitlements(result: result)
          }
        case "sync":
          // Sync can prompt for App Store credentials. Call it on Restore only.
          Task { @MainActor in
            do {
              try await AppStore.sync()
              result(nil)
            } catch {
              result(FlutterError(code: "storekit_sync_failed", message: nil, details: nil))
            }
          }
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @available(iOS 15.0, *)
  @MainActor
  private static func currentEntitlements(result: FlutterResult) async {
    let lifetimeID = "com.rollreel.pro.lifetime"
    let monthlyID = "com.rollreel.plus.monthly"
    var lifetime = false
    var monthlyActive = false
    var monthlyExpiration: Date?

    for await entry in Transaction.currentEntitlements {
      switch entry {
      case .verified(let transaction):
        guard transaction.revocationDate == nil, !transaction.isUpgraded else {
          continue
        }
        if transaction.productID == lifetimeID {
          lifetime = true
        } else if transaction.productID == monthlyID {
          monthlyActive = true
          if let expiry = transaction.expirationDate {
            monthlyExpiration = max(monthlyExpiration ?? expiry, expiry)
          }
        }
      case .unverified(let transaction, _):
        if transaction.productID == lifetimeID || transaction.productID == monthlyID {
          result(FlutterError(code: "storekit_unverified", message: nil, details: nil))
          return
        }
      }
    }

    var snapshot: [String: Any] = [
      "lifetime": lifetime,
      "monthlyActive": monthlyActive
    ]
    if let expiry = monthlyExpiration {
      snapshot["monthlyExpirationMs"] = Int64(expiry.timeIntervalSince1970 * 1000)
    }
    result(snapshot)
  }
}
