//
//  FLMapView.swift
//  mapbox_ios
//
//  Created by Jaime Blasco on 16/3/21.
//

import Flutter
import UIKit
import MapboxMaps

class FLMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLMapView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
       return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLMapView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    private var mapView: MapView
    
    private let channel: FlutterMethodChannel
    
    private var annotations: Dictionary<String, Annotation> =  [:]


    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        channel = FlutterMethodChannel(name: "flutter.mapbox/map_controller/\(viewId)",
                                           binaryMessenger: messenger)
        _view = FLEmbedView()
        
        guard  let arguments = args as? FlutterMap,
               let accessToken = arguments["accessToken"] as? String else {
           fatalError("No access token provided")
        }
        let options = ResourceOptions(accessToken: accessToken)
        mapView = MapView(with: frame, resourceOptions: options)
        super.init()
       
    
        _view.addSubview(mapView)
        channel.setMethodCallHandler(handle)
        
        for eventKind in MapEvents.EventKind.allCases {
            mapView.on(eventKind) { event in
                self.channel.invokeMethod("onEvent", arguments: [
                    "kind":  eventKind.rawValue,
                    "event": event.type
                ])
            }
        }
    }
    
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let argument =  call.arguments as? FlutterMap;
        switch call.method {
        case "updateOptions":
           updateOptions(args: argument, result: result)
        case "updateStyle":
           updateStyle(args: argument, result: result)
        case "updateAnnotation":
           updateAnnotation(args: argument, result: result)
        case "createAnnotation":
            createAnnotation(args: argument, result: result)
        case "removeAnnotation":
            removeAnnotation(args: argument, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func view() -> UIView {
        return _view
    }
    
    func updateOptions(args: FlutterMap?, result: @escaping FlutterResult)  {
        guard let args = args else {
            return result(FlutterError.invalidArguments)
        }
        mapView.update(with: { options in
            if let render = args["render"] as? FlutterMap  {
                options.updateRender(render)
            }
            if let ornaments = args["ornaments"] as? FlutterMap  {
                options.updateOrnaments(ornaments)
            }
            if let camera = args["camera"] as? FlutterMap  {
                options.updateCamera(camera)
            }
            if let gestures = args["gestures"] as? FlutterMap  {
                options.updateGestures(gestures)
            }
            if let location = args["location"] as? FlutterMap  {
                options.updateLocation(location)
            }
        })
        result(nil)
    }
    
    func createAnnotation(args: FlutterMap?, result: @escaping FlutterResult)  {
        guard let args = args,
              let type = args["type"] as? String else {
            return result(FlutterError.invalidArguments)
        }
        var annotation : Annotation?
        if(type == "point") {
            annotation = PointAnnotation.from(args)
        } else if(type == "line") {
            annotation = LineAnnotation.from(args)
        } else if(type == "polygon") {
            annotation = PolygonAnnotation.from(args)
        }
        
        if let annotation = annotation {
            annotations[annotation.identifier] = annotation
            mapView.annotationManager.addAnnotation(annotation)
            return  result(annotation.identifier)
        } else {
            return result(FlutterError.invalidArguments)
        }
      
    }
    
    func removeAnnotation(args: FlutterMap?, result: @escaping FlutterResult)  {
        guard let args = args,
              let id = args["id"] as? String else {
            return result(FlutterError.invalidArguments)
        }
        if let annotation = annotations.removeValue(forKey: id) {
            let r =   mapView.annotationManager.removeAnnotation(annotation)
            switch r {
            case .success(let bool):
                result(bool)
            case .failure(let error):
                result(error.toFlutterError())
            }
            return
        } else {
            result(FlutterError.init(code: "No annotation available with id \(id)", message: nil, details: nil))
        }
    }
    
    
    func updateAnnotation(args: FlutterMap?, result: @escaping FlutterResult)  {
        guard let args = args,
              let id = args["id"] as? String,
              let data = args["data"].asMap() else {
            return result(FlutterError.invalidArguments)
        }
        
        if var annotation = annotations[id] {
          
            if var pointAnnotation = annotation as? PointAnnotation {
                pointAnnotation.update(data)
                annotation =  pointAnnotation
                print("is point \(annotation)")
            } else if var lineAnnotation = annotation as? LineAnnotation {
                lineAnnotation.update(data)
                annotation =  lineAnnotation
                print("is line \(annotation)")
            } else if var polygonAnnotation = annotation as? PolygonAnnotation {
                polygonAnnotation.update(data)
                annotation =  polygonAnnotation
                print("is polygon \(annotation)")
            }
             
            do {
                try mapView.annotationManager.updateAnnotation(annotation)
            } catch let error {
                if let error = error as? AnnotationManager.AnnotationError {
                    result(error.toFlutterError())
                } else {
                    result(FlutterError.init(code: "Unexpected error when updating annotation \(id)", message: nil, details: nil))
                }
                return
            }
            
        }
        result(nil)
        
    }
    
    func  updateStyle(args: FlutterMap?, result: @escaping FlutterResult)  {
        guard let map = args,
              let style = map["style"]  as? String else {
            return result(FlutterError.invalidArguments)
        }
        do {
            try mapView.style.styleManager.setStyleJSONForJson(style)
        } catch {
            return result(FlutterError.invalidArguments)
        }
       
    }
}


class FLEmbedView : UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func layoutSubviews() {
    for view in subviews {
        view.frame = self.frame
    }
    super.layoutSubviews()
  }
}

