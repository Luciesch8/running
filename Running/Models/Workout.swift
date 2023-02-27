//
//  Workout.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 15/01/2023.
//

import Foundation
import HealthKit
import MapKit
import CoreLocation

class Workout: NSObject {
    let type: WorkoutType // type d'exercice
    let polyline: MKPolyline // polyline de l'itinéraire
    let locations: [CLLocation] // liste des locations
    let date: Date // date de l'exercice
    let duration: Double // durée de l'exercice en secondes
    let distance: Double // distance totale parcourue pendant l'exercice
    let elevation: Double // dénivelé total de l'exercice
    let heartRate: Int // mesure de la fréquence cardiaque
    
    
    
    init(type: WorkoutType, polyline: MKPolyline, locations: [CLLocation], date: Date, duration: Double, heartRate: Int) {
        self.type = type
        self.polyline = polyline
        self.locations = locations
        self.date = date
        self.duration = duration
        self.distance = locations.distance // calcule la distance totale en utilisant une extension de la classe CLLocation
        self.elevation = locations.elevation // calcule le dénivelé total en utilisant une extension de la classe CLLocation
        self.heartRate = heartRate
    }
    
    convenience init(hkWorkout: HKWorkout, locations: [CLLocation]) {
        let coords = locations.map(\.coordinate)
        let type = WorkoutType(hkType: hkWorkout.workoutActivityType) // convertit le type d'exercice HealthKit en type d'exercice local
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        let date = hkWorkout.startDate
        let duration = hkWorkout.duration
        var heartRate = 0
        
        // Récupération des données de fréquence cardiaque
        let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
        let predicate = HKQuery.predicateForSamples(withStart: hkWorkout.startDate, end: hkWorkout.endDate, options: .strictEndDate)
        
        let query = HKSampleQuery(sampleType: HKQuantityType.quantityType(forIdentifier: .heartRate)!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let heartRates = results as? [HKQuantitySample] {
                let averageHeartRate = heartRates.reduce(0.0) { $0 + $1.quantity.doubleValue(for: heartRateUnit) } / Double(heartRates.count)
                if averageHeartRate.isFinite {
                    heartRate = Int(averageHeartRate)
                } else {
                    heartRate = 0
                }
            }
        }
        HKHealthStore().execute(query)
        
        let workout = Workout(type: type, polyline: polyline, locations: locations, date: date, duration: duration, heartRate: heartRate)
        self.init(type: workout.type, polyline: workout.polyline, locations: workout.locations, date: workout.date, duration: workout.duration, heartRate: workout.heartRate)
    }

    

    
    static let example = Workout(type: .walk, polyline: MKPolyline(), locations: [], date: .now, duration: 3456, heartRate: 70) // un exemple d'exercice

}

extension Workout: MKOverlay {
    var coordinate: CLLocationCoordinate2D {
        polyline.coordinate
    }
    
    var boundingMapRect: MKMapRect {
        polyline.boundingMapRect
    }
}
