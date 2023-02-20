//
//  MapView.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 19/02/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var vm: ViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = vm  // définition du délégué sur le view model
        vm.mapView = mapView // transmission de la référence de la vue cartographique au view model
        
        mapView.showsUserLocation = true // affiche l'emplacement actuel de l'utilisateur sur la carte
        mapView.showsScale = true // affiche l'échelle de la carte
        mapView.showsCompass = true // affichage de la boussole sur la carte
        mapView.isPitchEnabled = false // désactiver le pitch
        
        let tapRecognizer = UITapGestureRecognizer(target: vm, action: #selector(ViewModel.handleTap))// création d'un outil de reconnaissance de gestes tactiles et définition de la méthode handleTap du model view
        mapView.addGestureRecognizer(tapRecognizer) // adding the tap gesture recognizer to the map view
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {}
}
