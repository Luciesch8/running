//
//  MyMapError.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//

import Foundation

// Définition d'une énumération de type de date d'entraînement
enum MyMapError: String {
    case endingWorkout = "Save Failed"
    case startingWorkout = "Start Failed"
    case noWorkouts = "No Workouts Yet"
    case emptyWorkout = "Workout Discarded"
    
    // Définition d'un message pour chaque cas d'erreur de la carte
    var message: String {
        switch self {
        case .endingWorkout:
            return "I was unable to save this workout to the Health App."
        case .startingWorkout:
            return "I was unable to start a new workout. Please try again."
        case .noWorkouts:
            return "Currently you have no workouts stored in the Health App. When you record a new workout, it will appear on the map."
        case .emptyWorkout:
            return "This workout has been discarded because it had no route locations."
        }
    }
}
