import Flutter
import UIKit


public class SnapshotGuardPlugin: NSObject, FlutterPlugin {
    var hide:Bool = false;
    var field = UITextField()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "snapshot_guard", binaryMessenger: registrar.messenger())
    let instance = SnapshotGuardPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch( call.method ){
      case "toggleGuard" : toggleGuard(result: result)
      case "switchGuardStatus" :
          let status = call.arguments! as? Bool ?? false
          switchGuardStatus(status: status, result:result)
      default : result( FlutterError(code:"INVALID_METHOD", message: "The method called is invalid", details: nil))
      }
  }
    
    private func switchGuardStatus(status: Bool, result: FlutterResult) {
            hide = status
        field.isSecureTextEntry = hide
        result(hide)
    }
    
    private func toggleGuard(result: FlutterResult) {
        hide.toggle()
        field.isSecureTextEntry = hide
        result(hide)
    }
//    this shows the app when
    public func applicationWillResignActive(_ application: UIApplication) {
        if(hide){
            field.isSecureTextEntry = false
        }

    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        if(hide){
            field.isSecureTextEntry = true
        }

    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        
        if let window = application.delegate?.window as? UIWindow {
            if (!window.subviews.contains(field)) {
                window.addSubview(field)
                field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
                field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
                window.layer.superlayer?.addSublayer(field.layer)
                field.layer.sublayers?.first?.addSublayer(window.layer)
                debugPrint("something")
            }
        }
        return true
    }
}

