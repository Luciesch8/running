//
//  FloatingButtons.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 13/01/2023.
//

import SwiftUI
import MapKit
import HealthKit

struct FloatingButtons: View {
    @EnvironmentObject var vm: ViewModel
    @State var showWorkoutTypeChoice = false
    @State var showStopConfirmation = false
    @State var showFilterView = false
    
    var body: some View {
        
        HStack(spacing: 0) {
            // Bouton pour mettre à jour le mode de suivi de l'utilisateur
            Button {
                updateTrackingMode()
            } label: {
                Image(systemName: trackingModeImage)
                    .frame(width: SIZE, height: SIZE)
                    .scaleEffect(vm.scale)
            }
            Divider().frame(height: SIZE)
            
            // Bouton pour mettre à jour le type de carte
            Button {
                updateMapType()
            } label: {
                Image(systemName: mapTypeImage)
                    .frame(width: SIZE, height: SIZE)
                    .rotation3DEffect(.degrees(vm.mapType == .standard ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(vm.degrees), axis: (x: 0, y: 1, z: 0))
            }
            Divider().frame(height: SIZE)
            
            // Menu pour filtrer les séances d'entraînement
            Menu {
                Picker("Date", selection: $vm.workoutDate) {
                    Text("All")
                        .tag(nil as WorkoutDate?)
                    ForEach(WorkoutDate.allCases.reversed(), id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type as WorkoutDate?)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Type", selection: $vm.workoutType) {
                    Text("All")
                        .tag(nil as WorkoutType?)
                    ForEach(WorkoutType.allCases.reversed(), id: \.self) { type in
                        Label {
                            Text(type.rawValue + "s")
                        } icon: {
                            Image(uiImage: UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: UIColor(type.colour)))!)
                        }
                        .tag(type as WorkoutType?)
                    }
                }
                .pickerStyle(.menu)
                
                // Option pour filtrer les séances d'entraînement
                Text("Filter Workouts")
            } label: {
                if vm.loadingWorkouts {
                    ProgressView()
                        .frame(width: SIZE, height: SIZE)
                } else if  vm.workouts.isNotEmpty {
                    Image(systemName: "line.3.horizontal.decrease.circle" + (vm.workoutType == nil && vm.workoutDate == nil ? "" : ".fill"))
                        .frame(width: SIZE, height: SIZE)
                }
            }
            Divider().frame(height: SIZE)
            
            // Bouton pour arrêter une séance d'entraînement en cours
            if vm.recording {
                Button {
                    showStopConfirmation = true
                } label: {
                    Image(systemName: "stop.fill")
                        .frame(width: SIZE, height: SIZE)
                }
                .confirmationDialog("Stop Workout?", isPresented: $showStopConfirmation, titleVisibility: .visible) {
                    Button("Cancel", role: .cancel) {}
                    Button("Stop & Discard", role: .destructive) {
                        vm.discardWorkout()
                    }
                    Button("Finish & Save") {
                        Task {
                            await vm.endWorkout()
                        }
                    }
                }
            } else {
                // Bouton pour démarrer une nouvelle
                Button {
                    showWorkoutTypeChoice = true
                } label: {
                    Image(systemName: "record.circle")
                        .frame(width: SIZE, height: SIZE)
                }
                .confirmationDialog("Record a Workout", isPresented: $showWorkoutTypeChoice, titleVisibility: .visible) {
                    Button("Cancel", role: .cancel) {}
                    ForEach(WorkoutType.allCases, id: \.self) { type in
                        Button(type.rawValue) {
                            Task {
                                await vm.startWorkout(type: type.hkType)
                            }
                        }
                    }
                }
            }
            Divider().frame(height: SIZE)
            
            Button {
                // Ce bouton définit la propriété showInfoView sur true lorsqu'il est tapé
                vm.showInfoView = true
            } label: {
                Image(systemName: "info.circle")
                    .frame(width: SIZE, height: SIZE)
            }
        }
        .font(.system(size: SIZE/2))
        .materialBackground()
    }
    
    // Cette vue a deux fonctions appelées updateTrackingMode() et updateMapType()
    func updateTrackingMode() {
        // Cette fonction a une variable appelée "mode" qui est calculée en fonction de la valeur de la propriété trackingMode dans le ViewModel
        var mode: MKUserTrackingMode {
            switch vm.trackingMode {
            case .none:
                return .follow
            case .follow:
                return .followWithHeading
            default:
                return .none
            }
        }
        // Cette fonction appelle la fonction updateTrackingMode() sur le ViewModel et passe la variable "mode" calculée
        vm.updateTrackingMode(mode)
    }
    
    func updateMapType() {
        // Cette fonction a une variable appelée "type" qui est calculée en fonction de la valeur de la propriété mapType dans le ViewModel
        var type: MKMapType {
            switch vm.mapType {
            case .standard:
                return .hybrid
            default:
                return .standard
            }
        }
        // Cette fonction appelle la fonction updateMapType() sur le ViewModel et passe la variable "type" calculée
        vm.updateMapType(type)
    }
    
    
    // Cette vue a deux propriétés calculées appelées trackingModeImage et mapTypeImage
    var trackingModeImage: String {
        switch vm.trackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    var mapTypeImage: String {
        switch vm.mapType {
        case .standard:
            return "globe.europe.africa.fill"
        default:
            return "map"
        }
    }
}

struct FloatingButtons_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtons()
            .environmentObject(ViewModel())
    }
}
