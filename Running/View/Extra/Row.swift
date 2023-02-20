//
//  Row.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 17/01/2023.
//

import SwiftUI

// Une structure nommée Row générique avec des types d'argument Leading et Trailing qui sont des vues
struct Row<Leading: View, Trailing: View>: View {
    
    // Définit deux fermetures leading et trailing pour fournir la vue de chaque côté de la rangée
    let leading: () -> Leading
    let trailing: () -> Trailing
    
    // La vue du corps qui crée une rangée horizontale avec un espacement égal entre la vue de gauche et de droite, avec la vue leading à gauche et la vue trailing à droite
    var body: some View {
        HStack {
            leading()
            Spacer()
            trailing()
        }
    }
}
