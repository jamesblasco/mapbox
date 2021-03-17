//
//  Errors.swift
//  mapbox_ios
//
//  Created by Jaime Blasco on 16/3/21.
//

import Foundation
import MapboxMaps

extension FlutterError {
    static let invalidArguments : FlutterError = FlutterError(code: "Invalid Arguments", message: "No arguments where provided", details: nil)
    
}

extension AnnotationManager.AnnotationError {
    
    func toFlutterError() -> FlutterError {
        switch self {
        case .featureGenerationFailed(let string):
           return FlutterError(code: "AnnotationError.featureGenerationFailed", message: string, details: nil)
        case .annotationAlreadyExists(let string):
            return FlutterError(code: "AnnotationError.annotationAlreadyExists", message: string, details: nil)
        case .annotationDoesNotExist(let string):
                return FlutterError(code: "AnnotationError.annotationDoesNotExist", message: string, details: nil)
        case .styleLayerGenerationFailed(let error):
            return FlutterError(code: "AnnotationError.styleLayerGenerationFailed", message: error?.localizedDescription, details: nil)
        case .addAnnotationFailed(let error):
                return FlutterError(code: "AnnotationError.addAnnotationFailed", message: error?.localizedDescription, details: nil)
        case .annotationAlreadyRemoved(let string):
                return FlutterError(code: "AnnotationError.annotationAlreadyRemoved", message: string, details: nil)
        case .removeAnnotationFailed(let string):
                return FlutterError(code: "AnnotationError.removeAnnotationFailed", message: string, details: nil)
        case .updateAnnotationFailed(let error):
                return FlutterError(code: "AnnotationError.updateAnnotationFailed", message: error?.localizedDescription, details: nil)
        }
    }
}

