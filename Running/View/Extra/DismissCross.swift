//
//  DismissCross.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//


import SwiftUI

struct DismissCross: View {
    // Le corps de la vue qui retourne une image système représentant une croix avec une couleur de premier plan (foregroundStyle) spécifiée et une taille de police de titre 2
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.title2)
            .foregroundStyle(.secondary, Color(.tertiarySystemFill))
    }
}
