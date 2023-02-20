//
//  Blur.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 11/02/2023.
//


import SwiftUI

// Définition d'une vue personnalisée nommée Blur qui implémente l'interface UIViewRepresentable
struct Blur: UIViewRepresentable {
    
    // Méthode requise pour UIViewRepresentable qui crée et renvoie l'instance d'UIView
    func makeUIView(context: Context) -> UIVisualEffectView {
        // Créer une instance d'UIVisualEffectView qui applique un effet de flou UIBlurEffect avec un style régulier
        UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    }
    
    // Méthode requise pour UIViewRepresentable qui met à jour la vue UIView
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // Laisser cette méthode vide, car nous n'avons pas besoin de mettre à jour la vue
    }
    
}
