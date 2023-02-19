//
//  ShareView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//


import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

extension View {
    func shareSheet(url: URL, isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            if #available(iOS 16, *) {
                ShareView(url: url)
                    .ignoresSafeArea()
                    .presentationDetents([.medium, .large])
            } else {
                ShareView(url: url)
            }
        }
    }
}
