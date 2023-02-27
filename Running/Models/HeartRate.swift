//
//  HeartRate.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 23/02/2023.
//

import SwiftUI
import Foundation

// Création d'une classe HeartRate qui hérite de la classe Dimension
class HeartRate: Dimension {
    // Définition d'une propriété statique "beatsPerMinute" de type HeartRate avec un symbole "bpm" et un convertisseur "UnitConverterLinear" qui utilise un coefficient de 1.0/60.0
    static let beatsPerMinute = HeartRate(symbol: "bpm", converter: UnitConverterLinear(coefficient: 1.0/60.0))
    
    // Méthode de classe qui retourne l'unité de base de la classe HeartRate (qui est "beatsPerMinute")
    override class func baseUnit() -> Self {
        return beatsPerMinute as! Self
    }
}
