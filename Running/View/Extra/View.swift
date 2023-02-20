//
//  View.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 11/02/2023.
//


import SwiftUI

// Une vue modifier nommée Background qui définit un fond pour une vue avec un effet de bordure et une ombre
struct Background: ViewModifier {
    
    // Récupère le mode de couleur actuel de l'appareil (clair ou foncé) à partir de l'environnement
    @Environment(\.colorScheme) var colorScheme
    
    // Détermine le matériau de fond en fonction du mode de couleur
    var background: Material { colorScheme == .light ? .regularMaterial : .thickMaterial }
    
    // Applique le fond, l'effet de bordure, l'effet de composition et l'ombre à la vue
    func body(content: Content) -> some View {
        content
            .background(background)
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(.systemFill), radius: 5)
    }
}

// Une extension de la vue qui ajoute plusieurs méthodes de modification pratique
extension View {
    // Ajoute un fond de matériau à la vue en utilisant la vue modifier Background définie ci-dessus
    func materialBackground() -> some View {
        self.modifier(Background())
    }
    
    // Applique un contenu de vue conditionnellement, en fonction d'un booléen applyModifier
    @ViewBuilder
    func `if`<Content: View>(_ applyModifier: Bool = true, @ViewBuilder content: (Self) -> Content) -> some View {
        if applyModifier {
            content(self)
        } else {
            self
        }
    }
    
    // Centre horizontalement la vue en l'entourant de deux espaces de longueur minimale nulle
    func horizontallyCentred() -> some View {
        HStack {
            Spacer(minLength: 0)
            self
            Spacer(minLength: 0)
        }
    }
    
    // Ajoute des modifications à la vue pour créer un grand bouton avec une police en gras, un rembourrage, une couleur de texte et de fond, et du radius
    func bigButton() -> some View {
        self
            .font(.body.bold())
            .padding()
            .horizontallyCentred()
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(15)
    }
}
