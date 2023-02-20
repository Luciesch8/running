//
//  WorkoutType.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//

import HealthKit
import SwiftUI

// Enum pour les types d'entraînement
enum WorkoutType: String, CaseIterable {
    case walk = "Walk"
    case run = "Run"
    case cycle = "Cycle"
    case other = "Other"
    
    
    // Couleur correspondant à chaque type d'entraînement
    var colour: Color {
        switch self {
        case .walk:
            return .green
        case .run:
            return .red
        case .cycle:
            return .blue
        case .other:
            return .yellow
        }
    }
    
    // Type d'activité HealthKit correspondant à chaque type d'entraînement
    var hkType: HKWorkoutActivityType {
        switch self {
        case .walk:
            return .walking
        case .run:
            return .running
        case .cycle:
            return .cycling
        case .other:
            return .other
        }
    }
    
    // Initialisation d'un type d'entraînement à partir d'un type d'activité HealthKit
    init(hkType: HKWorkoutActivityType) {
        switch hkType {
        case .walking:
            self = .walk
        case .running:
            self = .run
        case .cycling:
            self = .cycle
        default:
            self = .other
        }
    }
}
