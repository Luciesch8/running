//
//  AccountView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 21/02/2023.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var showShareSheet = false
    
    let welcome: Bool //Propriété pour déterminer si l'utilisateur est un nouvel utilisateur
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
                
                            
            
                NavigationView {
                        VStack(spacing: 20) {
                            Spacer()
                            NavigationLink(
                                destination: HeartRateView(heartRate : 80)
,
                                label: {
                                    HStack {
                                        Text("Heart Rate")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.leading, 16)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 16)
                                    }
                                    .frame(height: 75)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                })
                            NavigationLink(
                                destination: RunListView(),
                                label: {
                                    HStack {
                                        Text("Running List")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.leading, 16)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 16)
                                    }
                                    .frame(height: 75)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                })
                            Spacer()
                        }
                }
                .horizontallyCentred()
                .padding(.bottom, 30)
                
               Spacer()
                
    
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline) //Afficher le titre de la vue en inline dans la barre de navigation
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                        Button {
                            dismiss()
                        } label: {
                            DismissCross()
                        }
                        .buttonStyle(.plain)
                    
                }
                // Item de la barre d'outils pour le titre ou la barre de déplacement
                ToolbarItem(placement: .principal) {
                        DraggableBar()
                    }
                
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                AccountView(welcome: true)
            }
    }
}



//info Row
struct AccountRow: View {
    let systemName: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.accentColor)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
    }
}

