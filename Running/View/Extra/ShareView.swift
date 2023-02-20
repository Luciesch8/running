//
//  ShareView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//


import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    let url: URL
    
    // makeUIViewController est une fonction qui crée et retourne un UIViewController personnalisé, dans ce cas UIActivityViewController, configuré avec une URL à partager
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    // updateUIViewController est une fonction qui met à jour un UIViewController existant en réponse à des changements d'état, mais n'est pas utilisé ici
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

extension View {
    func shareSheet(url: URL, isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            if #available(iOS 16, *) { //vérifie si l'appareil exécute iOS 16 ou une version ultérieure.
                ShareView(url: url)
                    .ignoresSafeArea()
                    .presentationDetents([.medium, .large])
            } else {
                ShareView(url: url)
            }
        }
    }
}
