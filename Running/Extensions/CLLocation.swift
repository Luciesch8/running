//
//  CLLocation.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 02/02/2023.
//

import Foundation
import CoreLocation

extension Array where Element == CLLocation {
    
    // Calcule la distance totale parcourue à travers une série de CLLocation
    var distance: Double {
        guard count > 1 else { return 0 }
        var distance = Double.zero
        
        // Parcoure tous les éléments dans le tableau, en calculant la distance entre chaque paire de CLLocation
        for i in 0..<count-1 {
            let location = self[i]
            let nextLocation = self[i+1]
            distance += nextLocation.distance(from: location)
        }
        return distance
    }
    
    
    // Calcule l'élévation totale à travers une série de CLLocation
    var elevation: Double {
        guard count > 1 else { return 0 }
        var elevation = Double.zero
        
        
        // Parcoure tous les éléments dans le tableau, en calculant la différence d'altitude entre chaque paire de CLLocation
        for i in 0..<count-1 {
            let location = self[i]
            let nextLocation = self[i+1]
            let delta = nextLocation.altitude - location.altitude
            if delta > 0 {
                elevation += delta
            }
        }
        return elevation
    }
}
