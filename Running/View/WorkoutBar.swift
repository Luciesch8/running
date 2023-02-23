//
//  WorkoutBar.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 15/01/2023.
//

import SwiftUI
import MapKit

struct WorkoutBar: View {
    @EnvironmentObject var vm: ViewModel
    @State var showWorkoutView = false
    @State var offset = Double.zero
    
    let workout: Workout
    //let heartRate: HeartRate
    let new: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(workout.type.rawValue)
                    .font(.headline)
                Spacer()
                if new {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .opacity(vm.pulse ? 1 : 0)
                } else {
                    Text(workout.date.formattedApple()) // Afficher la date formatée

                }
            }
            .animation(.default, value: vm.pulse)
            
            HStack {
                WorkoutStat(name: "Distance", value: Measurement(value: workout.distance, unit: UnitLength.meters).formatted())// Afficher la distance formatée
                Spacer(minLength: 0)
                WorkoutStat(name: "Duration", value: DateComponentsFormatter().string(from: workout.duration) ?? "")// Afficher la durée formatée
                Spacer(minLength: 0)
                WorkoutStat(name: "Speed", value: Measurement(value: workout.distance / workout.duration, unit: UnitSpeed.metersPerSecond).formatted()) // Afficher la vitesse formatée
                Spacer(minLength: 0)

                WorkoutStat(name: "Elevation", value: Measurement(value: workout.elevation, unit: UnitLength.meters).formatted())// Afficher l'élévation formatée
                Spacer(minLength: 0)

                WorkoutStat(name: "Heart Rate", value: workout.heartRate)// Afficher rythme cardique
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .materialBackground()
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            vm.zoomTo(workout)
        }
        .if(!new) { $0
            .offset(x: 0, y: offset)
            .opacity((100 - offset)/100)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if value.translation.height > 0 {
                        offset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.predictedEndTranslation.height > 50 {
                        vm.selectedWorkout = nil // Ignorer l'entraînement lorsqu'il dépasse le seuil
                    } else {
                        withAnimation(.spring()) {
                            offset = 0 // Réinitialiser le décalage à la fin du geste de glisser
                        }
                    }
                }
            )
        }
    }
}

struct WorkoutBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Map(mapRect: .constant(MKMapRect()))
            WorkoutBar(workout: .example, new: true)
                .environmentObject(ViewModel())
        }
    }
}

struct WorkoutStat: View {
    let name: String
    let value: String
    
    var body: some View {
        VStack(spacing: 3) {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
    }
}
