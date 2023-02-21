//
//  InfoView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 12/02/2023.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @State var showShareSheet = false
    
    let welcome: Bool //Propriété pour déterminer si l'utilisateur est un nouvel utilisateur

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 0) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .cornerRadius(15)
                        .padding(.bottom)
                    Text((welcome ? "Welcome to\n" : "") + NAME) //Texte de bienvenue et nom de l'application
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                    if !welcome { //Si l'utilisateur n'est pas un nouvel utilisateur
                        Text("Version " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""))
                            .foregroundColor(.secondary)
                    }
                }
                .horizontallyCentred()
                .padding(.bottom, 30)
                
                //Affichage de trois rangées d'informations
                InfoRow(systemName: "map", title: "Browse all your Routes", description: "See all your routes stored in the Health App on one map.")
                InfoRow(systemName: "record.circle", title: "Record Workouts", description: "Record runs, walks and cycles and see your route update live.")
                InfoRow(systemName: "line.3.horizontal.decrease.circle", title: "Filter Workouts", description: "Filter the workouts shown on the map by date and type.")
                Spacer()
                
                if welcome { //Si l'utilisateur est un nouvel utilisateur
                    Button {
                        dismiss() //Fermer la vue
                    } label: {
                        Text("Continue")
                            .bigButton()
                    }
                } else { //Sinon, s'il s'agit d'un utilisateur existant
                    //Afficher un menu avec trois options
                    Menu {
                        Button {
                            Emails.compose(subject: "\(NAME) Feedback") //Ouvrir une fenêtre de composition de courriel avec le sujet prérempli
                        } label: {
                            Label("Send us Feedback", systemImage: "envelope")
                        }
            
                    } label: {
                        Text("Contribute...")
                            .bigButton()
                    }
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline) //Afficher le titre de la vue en inline dans la barre de navigation
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if !welcome { //Si l'utilisateur est un utilisateur existant
                        Button {
                            dismiss()
                        } label: {
                            DismissCross()
                        }
                        .buttonStyle(.plain)
                    }
                }
                // Item de la barre d'outils pour le titre ou la barre de déplacement
                ToolbarItem(placement: .principal) {
                    if welcome {
                        Text("")
                    } else {
                        DraggableBar()
                    }
                }
            }

        }
        // Désactiver le balayage de défilement sur la vue si l'utilisateur est nouveau

        .interactiveDismissDisabled(welcome)
    }
}

// Prévisualisation de la vue
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                InfoView(welcome: true)
            }
    }
}

struct InfoRow: View {
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
