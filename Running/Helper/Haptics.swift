//
//  Haptics.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 03/02/2023.
//

import UIKit

struct Haptics {
    
    // Définit une fonction qui génère une vibration de type "tap"
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    // Définit une fonction qui génère une vibration de type "impact"
    static func impact() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    // Définit une fonction qui génère une vibration de type "notification" pour indiquer une action réussie
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    // Définit une fonction qui génère une vibration de type "notification" pour indiquer une action en erreur
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
