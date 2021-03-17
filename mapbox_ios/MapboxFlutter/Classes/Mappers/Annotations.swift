//
//  Annotations.swift
//  mapbox_ios
//
//  Created by Jaime Blasco on 17/3/21.
//

import Foundation
import MapboxMaps



extension PointAnnotation {
    
    static func from(_ map: FlutterMap?) -> PointAnnotation? {
        guard let map = map,
        let coordinate = CLLocationCoordinate2D.from(args: map["coordinate"].asMap()) else {
            return nil
        }
        var annotation = PointAnnotation.init(coordinate: coordinate)
        annotation.update(map)
        return annotation
    }
    
    mutating func update(_ map: FlutterMap?) {
        guard let map = map,
        let coordinate = CLLocationCoordinate2D.from(args: map["coordinate"].asMap()) else {
            return
        }
        self.coordinate = coordinate
        self.title = map["title"] as? String
    }
}

extension Array {
     func safeMap<T>(_ transform: (Element) -> T?) -> Array<T>? {
        var result : Array<T> = []
        for item in self {
            if  let element = transform(item) {
                result.append(element)
            }  else {
                return nil
            }
        }
        return result
    }
}



extension LineAnnotation {
    
    static func from(_ map: FlutterMap?) -> LineAnnotation? {
        guard let map = map,
              let anyCordinates  = map["coordinates"].asList(),
              let coordinates = anyCordinates.safeMap({ CLLocationCoordinate2D.from(args: $0 as? FlutterMap) }) else {
            return nil
        }
        var annotation =  LineAnnotation.init(coordinates: coordinates)
        annotation.update(map)
        return annotation
    }
    
    mutating func update(_ map: FlutterMap?) {
        guard let map = map,
              let anyCordinates  = map["coordinates"].asList(),
              let coordinates = anyCordinates.safeMap({ CLLocationCoordinate2D.from(args: $0 as? FlutterMap) })  else {
            return
        }
        var cordinates = self.coordinates
        cordinates.removeAll()
        cordinates.append(contentsOf: coordinates)
        self.title = map["title"] as? String
    
    }
}


extension PolygonAnnotation {
    
    static func from(_ map: FlutterMap?) -> PolygonAnnotation? {
        guard let map = map,
              let anyCordinates  = map["coordinates"].asList(),
              let coordinates = anyCordinates.safeMap({ CLLocationCoordinate2D.from(args: $0 as? FlutterMap) }) else {
            return nil
        }
        var interiorPolygons :  Array<Array<CLLocationCoordinate2D>>?
        if let anyInterior = map["interiorPolygons"].asList() {
             interiorPolygons = anyInterior.safeMap({ value in
                var polygon :  Array<CLLocationCoordinate2D>? = nil
                if let cordinates = (value as? Any).asList() {
                polygon = cordinates.safeMap {CLLocationCoordinate2D.from(args: $0 as? FlutterMap) }
                }
                return polygon
            }) as Array<Array<CLLocationCoordinate2D>>?
        }
        
       
        var annotation =  PolygonAnnotation.init(coordinates: coordinates, interiorPolygons: interiorPolygons)
        annotation.update(map)
        return annotation
    }
    
    
    
    mutating func update(_ map: FlutterMap?) {
        guard let map = map,
              let anyCordinates  = map["coordinates"].asList(),
              let coordinates = anyCordinates.safeMap({ CLLocationCoordinate2D.from(args: $0 as? FlutterMap) })  else {
            return
        }
        var cordinates = self.coordinates
        cordinates.removeAll()
        cordinates.append(contentsOf: coordinates)
    
    }
}
