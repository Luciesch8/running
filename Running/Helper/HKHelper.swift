//
//  HKHelper.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 23/01/2023.
//

import Foundation
import HealthKit
import CoreLocation
import MapKit

struct HKHelper {
    static let healthStore = HKHealthStore()
    static let available = HKHealthStore.isHealthDataAvailable()
    
    // La méthode requestAuth() demande à l'utilisateur l'autorisation d'accéder à ses données de santé.
    static func requestAuth() async -> HKAuthorizationStatus {
        // Définition des types de données à partager et à lire dans HealthKit.
        let types: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // Demande de l'autorisation d'accéder aux types de données définis ci-dessus.
        try? await healthStore.requestAuthorization(toShare: types, read: types)
        return status
    }
    
    // La méthode status renvoie l'état actuel de l'autorisation d'accéder aux données de santé.
    static var status: HKAuthorizationStatus {
        // Vérification de l'état d'autorisation pour les types de données d'entraînement et de parcours.
        let workoutStatus = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        let routeStatus = healthStore.authorizationStatus(for: HKSeriesType.workoutRoute())
        
        // Détermine si les deux types de données ont été autorisés à être partagés.
        if workoutStatus == .sharingAuthorized && routeStatus == .sharingAuthorized {
            return .sharingAuthorized
        } else if workoutStatus == .notDetermined && routeStatus == .notDetermined {
            return .notDetermined
        } else {
            return .sharingDenied
        }
    }
    
    // La méthode loadWorkouts charge une liste d'entraînements à partir des données de santé de l'utilisateur.
    static func loadWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        // Définition d'un tri pour les résultats de la requête d'entraînement pour trier par date de début, de la plus récente à la plus ancienne.
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { query, samples, error in
            guard let workouts = samples as? [HKWorkout] else {
                completion([])
                return
            }
            completion(workouts)
        }
        healthStore.execute(query)
    }
    
    // La méthode loadWorkoutRoute charge un parcours d'entraînement à partir des données de santé de l'utilisateur.
    static func loadWorkoutRoute(hkWorkout: HKWorkout, completion: @escaping ([CLLocation]) -> Void) {
        // Définition du type d'échantillon de série d'entraînement pour les parcours d'entraînement.
        let type = HKSeriesType.workoutRoute()
        
        // Prédicat pour récupérer les séries d'entraînement
        let predicate = HKQuery.predicateForObjects(from: hkWorkout)
        
        let routeQuery = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let route = samples?.first as? HKWorkoutRoute else {
                completion([])
                return
            }
            
            var locations = [CLLocation]()
            let locationsQuery = HKWorkoutRouteQuery(route: route) { query, newLocations, finished, error in
                locations.append(contentsOf: newLocations ?? [])
                if finished {
                    completion(locations)
                }
            }
            self.healthStore.execute(locationsQuery)
        }
        healthStore.execute(routeQuery)
    }
}
