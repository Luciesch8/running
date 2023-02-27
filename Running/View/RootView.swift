//
//  RootView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 19/02/2023.
//


import SwiftUI
import CoreLocation

struct RootView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var vm = ViewModel()
    @AppStorage("launchedBefore") var launchedBefore = false
    @State var welcome = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Blur()
                    .ignoresSafeArea()
                Spacer()
                    .layoutPriority(1)
            }
            /*
            VStack(spacing: 10) {
                AccountButtons()
            }*/
            
            VStack(spacing: 10) {
                Spacer()
                if let workout = vm.selectedWorkout { // affiche une autre WorkoutBar en cas d'enregistrement
                    WorkoutBar(workout: workout, new: false)
                }
                FloatingButtons()
                if vm.recording { // affiche une WorkoutBar si un entraînement est sélectionné
                    WorkoutBar(workout: vm.newWorkout, new: true)
                }
            }
            .padding(10)
        }
        .animation(.default, value: vm.recording) // anime les changements d'enregistrement
        .animation(.default, value: vm.selectedWorkout) // anime les modifications apportées à l'entraînement sélectionné
        .alert(vm.error.rawValue, isPresented: $vm.showErrorAlert) {} message: { // affiche une alerte avec le message d'erreur
            Text(vm.error.message)
        }
        .onAppear { // affiche un message de bienvenue et l'InfoView au premier lancement
            if !launchedBefore {
                launchedBefore = true
                welcome = true
                vm.showInfoView = true
                vm.showAccountView = false

            }
        }
        .fullScreenCover(isPresented: $vm.healthUnavailable) { // affiche une ErrorView si l'accès à la santé n'est pas disponible
            ErrorView(systemName: "heart.slash", title: "Health Unavailable", message: "\(NAME) needs access to the Health App to store and load workouts. Unfortunately, this device does not have these capabilities so the app will not work.")
        }
        .sheet(isPresented: $vm.showInfoView, onDismiss: {
            welcome = false
        }) {
            InfoView(welcome: welcome)
        }
        
        .sheet(isPresented: $vm.showAccountView, onDismiss: {
            welcome = false
        }) {
            AccountView(welcome: welcome)
        }

        .sheet(isPresented: $vm.showPermissionsView) { // affiche PermissionsView sous forme de feuille
            PermissionsView()
        }
        .onChange(of: scenePhase) { newPhase in // met à jour l'état de santé sur scenePhase de phase
            if newPhase == .active {
                vm.updateHealthStatus()
            }
        }
        .environmentObject(vm) // définit l'objet ViewModel comme objet d'environnement
    }
}
