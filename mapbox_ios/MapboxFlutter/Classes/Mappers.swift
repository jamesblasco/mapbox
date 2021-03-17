//
//  Mappers.swift
//  mapbox_ios
//
//  Created by Jaime Blasco on 16/3/21.
//

import Foundation
import MapboxMaps

typealias FlutterMap = Dictionary<String, Any>
extension Optional {
    func asMap() -> FlutterMap? {
        return self as? FlutterMap
    }
    
    func asList() -> Array<Any>? {
        return self as? Array<Any>
    }
    
    
    func asInt() -> Int? {
        return self as? Int
    }
    
    func asBool() -> Bool? {
        return self as? Bool
    }
    func asString() -> String? {
        return self as? String
    }
}

extension MapOptions {
    
    mutating func updateRender(_ map: FlutterMap) {
        self.render.preferredFramesPerSecond = PreferredFPS.init(rawValue: map["preferredFramesPerSecond"] as? Int ?? -1 ) ?? .normal
        self.render.prefetchesTiles =  map["prefetchesTiles"] as? Bool ?? false
        self.render.presentsWithTransaction =  map["presentsWithTransaction"] as? Bool ?? false
    }
    
    mutating func updateOrnaments(_ map:  FlutterMap) {
        self.ornaments.showsScale =  map["showsScale"] as? Bool ?? true
        self.ornaments.scaleBarPosition = LayoutPosition.from(rawValue: map["scaleBarPosition"] as? String) ?? .topLeft
        self.ornaments.scaleBarMargins = CGPoint.from(args: map["scaleBarMargins"].asMap()) ?? defaultOrnamentsMargin
    
        
        self.ornaments.showsCompass =  map["showsCompass"] as? Bool ?? true
        self.ornaments.compassViewPosition = LayoutPosition.from(rawValue: map["compassViewPosition"] as? String) ?? .topRight
        self.ornaments.compassViewMargins = CGPoint.from(args: map["compassViewMargins"].asMap()) ?? defaultOrnamentsMargin
        self.ornaments.compassVisiblity = LayoutVisibility.from(rawValue: map["compassVisiblity"] as? String) ?? .adaptive
        
       // self.showsLogoView =  map["showsLogoView"] as? Bool ?? true
        self.ornaments.logoViewPosition = LayoutPosition.from(rawValue: map["logoViewPosition"] as? String) ?? .bottomLeft
        self.ornaments.logoViewMargins = CGPoint.from(args: map["logoViewMargins"].asMap()) ?? defaultOrnamentsMargin
        
        //self.showsAttributionButton =  map["showsAttributionButton"] as? Bool ?? true
        self.ornaments.attributionButtonPosition = LayoutPosition.from(rawValue: map["attributionButtonPosition"] as? String) ?? .bottomRight
        self.ornaments.attributionButtonMargins = CGPoint.from(args: map["attributionButtonMargins"].asMap()) ?? defaultOrnamentsMargin
        
    }
    
    mutating func updateCamera(_ map: FlutterMap) {
        self.camera.minimumZoomLevel =  map["minimumZoomLevel"] as? CGFloat ?? 0.0
        self.camera.maximumZoomLevel =  map["maximumZoomLevel"] as? CGFloat ?? 22.0
        self.camera.minimumPitch =  map["minimumPitch"] as? CGFloat ?? 0.0
        self.camera.maximumPitch =  map["maximumPitch"] as? CGFloat ?? 85.0
        self.camera.animationDuration = TimeInterval.init(map["animationDuration"] as? CGFloat ?? 85.0)
        self.camera.decelerationRate =  map["decelerationRate"] as? CGFloat ?? UIScrollView.DecelerationRate.normal.rawValue
        
        self.camera.restrictedCoordinateBounds =  CoordinateBounds.from(args: map["restrictedCoordinateBounds"].asMap())
    }
    
    mutating func updateGestures(_ map: FlutterMap) {
        self.gestures.zoomEnabled  = map["zoomEnabled"] as? Bool ?? true
        self.gestures.rotateEnabled = map["rotateEnabled"] as? Bool ?? true
        self.gestures.scrollEnabled = map["scrollEnabled"] as? Bool ?? true
        self.gestures.scrollingMode = PanScrollingMode.from(rawValue: map["scrollingMode"] as? String) ?? .horizontalAndVertical
        self.gestures.pitchEnabled = map["pitchEnabled"] as? Bool ?? true
        self.gestures.hapticFeedbackEnabled = map["hapticFeedbackEnabled"] as? Bool ?? true
        self.gestures.decelerationRate =  map["decelerationRate"] as? CGFloat ?? UIScrollView.DecelerationRate.normal.rawValue
    }
    
    mutating func updateLocation(_ map: FlutterMap) {
        self.location.distanceFilter =  map["distanceFilter"] as? CLLocationDistance ?? kCLDistanceFilterNone
        self.location.desiredAccuracy =  map["desiredAccuracy"] as? CLLocationAccuracy ?? kCLLocationAccuracyBest
        self.location.activityType =  CLActivityType.from(rawValue: map["activityType"].asInt() ) ?? .other
        self.location.showUserLocation =  map["showUserLocation"] as? Bool ?? false
        /// Sets the type of backend that should be used for the PuckView
        //public var locationPuck: LocationPuck = .puck2D()
    }
    
}


extension CLActivityType {
    
    static func from(rawValue: Int?) -> CLActivityType? {
        guard let rawValue = rawValue else {
            return nil
        }
        return CLActivityType.init(rawValue: rawValue)
    }
    
}


extension PanScrollingMode {
    
    static func from(rawValue: String?) -> PanScrollingMode? {
        switch rawValue {
        case "horizontal":
            return  .horizontal
        case "vertical":
            return  .vertical
        case "horizontalAndVertical":
          return .horizontalAndVertical
        default:
            return nil
        }
    }
    
}
extension CoordinateBounds {
    
    static func from(args: FlutterMap?) -> CoordinateBounds? {
        guard let args = args,
              let southwest = CLLocationCoordinate2D.from(args: args["southwest"].asMap()),
              let northeast = CLLocationCoordinate2D.from(args: args["northeast"].asMap()) else {
            return nil
        }
        return CoordinateBounds.init(southwest: southwest, northeast: northeast)
    }
    
}

extension CLLocationCoordinate2D {
    
    static func from(args: FlutterMap?) -> CLLocationCoordinate2D? {
        guard let args = args,
              let latitude = args["latitude"] as? CLLocationDegrees,
              let longitude = args["longitude"] as? CLLocationDegrees else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}


extension CGPoint {
    
    static func from(args: FlutterMap?) -> CGPoint? {
        guard let args = args,
              let x = args["x"] as? CGFloat,
              let y = args["y"] as? CGFloat else {
            return nil
        }
        return CGPoint(x: x, y: y)
    }
    
}

extension LayoutPosition {
    
    static func from(rawValue: String?) -> LayoutPosition? {
        guard let rawValue = rawValue else {
            return nil
        }
        return LayoutPosition.init(rawValue: rawValue)
    }
    
}

extension LayoutVisibility {
    
    static func from(rawValue: String?) -> LayoutVisibility? {
        guard let rawValue = rawValue else {
            return nil
        }
        return LayoutVisibility.init(rawValue: rawValue)
    }
    
}


private let defaultOrnamentsMargin = CGPoint(x: 8.0, y: 8.0)


