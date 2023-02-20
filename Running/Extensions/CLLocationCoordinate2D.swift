//
//  CLLocationCoordinate2D.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 02/02/2023.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude) // Crée une instance CLLocation à partir des coordonnées
    }
}
