import Flutter
import UIKit

public class MapboxFlutterPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter.mapbox/channel/", binaryMessenger: registrar.messenger())
    let instance = MapboxFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    let factory = FLMapViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "flutter.mapbox/map")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
