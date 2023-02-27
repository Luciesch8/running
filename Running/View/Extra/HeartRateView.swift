//
//  HeartRateView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 26/02/2023.
//

import SwiftUI

struct HeartRateView: View{
    
    @Environment(\.presentationMode) var presentationMode
    var heartRate: Int // dernier rythme cardiaque enregistré

    var body: some View {
        VStack(spacing: 20) {

            RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 350, height: 120)
                        .background()
                        .overlay(
                            Text("Last Heart Rates")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.bottom, 60)

                        )
                        .overlay(
                            Text("\(heartRate)")
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                        .overlay(
                            Text("BPM")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 60)
                        )
                }
        .padding(.bottom, 450)

    
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }

    
    
        private var backButton: some View {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Retour")
                }
                .foregroundColor(.blue)
                .padding(.bottom, 30) // Déplace le bouton vers le haut de la vue
            })
        }
    }






struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView(heartRate : 80)
    }

}
