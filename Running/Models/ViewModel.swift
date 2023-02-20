//
//  ViewModel.swift
//  Running
//
//  Created by Ah lucie nous gênes 🍄 on 21/01/2023.
//


import Foundation
import HealthKit
import MapKit
import SwiftUI
import Combine

// Utilisez MainActor pour assurer que toutes les mises à jour du modèle de vue sont effectuées sur le thread principal.
@MainActor
class ViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    
    // Utilise le wrapper de propriété @Published pour permettre à SwiftUI de mettre automatiquement à jour les vues lorsque les valeurs changent.
    // Workout Tracking
    @Published var recording = false // Si oui ou non le suivi de l'entraînement est actuellement actif
    @Published var type = WorkoutType.other // Le type d'entraînement suivi
    @Published var startDate = Date() // La date/heure de début du suivi
    @Published var metres = 0.0 // La distance parcourue lors du suivi
    @Published var locations = [CLLocation]() // Un tableau d'objets CLLocation représentant le chemin tracé
    
    // Propriété calculée qui renvoie une MKPolyline basée sur le tableau locations
    var polyline: MKPolyline {
        let coords = locations.map(\.coordinate)
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    // Propriété calculée qui renvoie un nouvel objet d'entraînement basé sur l'état actuel du ViewModel.
    var newWorkout: Workout {
        let duration = Date.now.timeIntervalSince(startDate)
        return Workout(type: type, polyline: polyline, locations: locations, date: startDate, duration: duration)
    }
    
    
    // Propriétés liées à HealthKit et permissions
    @Published var showPermissionsView = false
    @Published var healthUnavailable = !HKHelper.available
    @Published var healthStatus = HKAuthorizationStatus.notDetermined
    @Published var healthLoading = false
    
    // Propriété calculée qui renvoie true si l'autorisation HealthKit a été accordée
    var healthAuth: Bool { healthStatus == .sharingAuthorized }
    
    // HealthKit store used to request HealthKit authorization.
    let healthStore = HKHealthStore()
    
    // CLLocationManager utilisé pour suivre l'emplacement de l'utilisateur pendant un entraînement.
    var locationManager = CLLocationManager()
    
    // HKWorkoutBuilder et HKWorkoutRouteBuilder sont utilisés pour suivre les entraînements dans HealthKit.
    var workoutBuilder: HKWorkoutBuilder?
    var routeBuilder: HKWorkoutRouteBuilder?
    
    // Annulable utilisé pour annuler la minuterie qui met à jour le temps écoulé de l'entraînement pendant l'enregistrement.
    var timer: Cancellable?
    
    // Map
    // Propriétés liées à la carte
    @Published var trackingMode = MKUserTrackingMode.none
    @Published var mapType = MKMapType.standard
    @Published var accuracyAuth = false
    @Published var locationStatus = CLAuthorizationStatus.notDetermined
    
    // Propriété calculée qui renvoie true si l'autorisation de localisation a été accordée.
    var locationAuth: Bool { locationStatus == .authorizedAlways }
    // Le MKMapView qui affiche la carte
    var mapView: MKMapView?
    
    // Workouts
    // Le tableau des entraînements que l'utilisateur a terminés.
    @Published var workouts = [Workout]()
    
    // Le tableau des entraînements qui ont été filtrés en fonction de workoutType et workoutDate.
    @Published var filteredWorkouts = [Workout]()
    
    // Booléen qui indique si les entraînements sont en cours de chargement.
    @Published var loadingWorkouts = true
    
    // L'entraînement actuellement sélectionné
    @Published var selectedWorkout: Workout? { didSet {
        updatePolylines()
        filterWorkouts()
    }}
    
    // Filters
    // Le filtre de type d'entraînement actuellement sélectionné.
    @Published var workoutType: WorkoutType? { didSet {
        filterWorkouts()
    }}
    
    
    // Le filtre de date d'entraînement actuellement sélectionné.
    @Published var workoutDate: WorkoutDate? { didSet {
        filterWorkouts()
    }}
    
    // View
    @Published var degrees = 0.0
    @Published var scale = 1.0
    @Published var pulse = false
    @Published var showInfoView = false
    @Defaults(key: "shownNoWorkoutsError", defaultValue: false) var shownNoWorkoutsError
    
    // Errors
    @Published var showErrorAlert = false
    @Published var error = MyMapError.noWorkouts
    func showError(_ error: MyMapError) {
        self.error = error
        self.showErrorAlert = true
        Haptics.error()
    }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        setupLocationManager() // Appel de la fonction pour configurer le gestionnaire de localisation
        updateHealthStatus() // Mise à jour du statut de la santé
        if healthAuth { // Si l'application a l'autorisation d'accès aux données de santé
            loadWorkouts() // Charge les données de l'historique de l'utilisateur
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self // Définit le délégué pour la gestion des mises à jour de localisation
    }
    
    func requestLocationAuthorisation() {
        if locationStatus == .notDetermined { // Si le statut de l'autorisation de localisation n'est pas encore déterminé
            locationManager.requestWhenInUseAuthorization() // Demande l'autorisation d'accéder à la localisation en cours d'utilisation
        } else { // Si l'autorisation de localisation est déjà déterminée
            locationManager.requestAlwaysAuthorization() // Demande l'autorisation d'accéder à la localisation en permanence
        }
    }
    
    func updateHealthStatus() {
        healthStatus = HKHelper.status // Met à jour le statut d'autorisation pour accéder aux données de santé
        if !healthAuth {// Si l'application n'a pas encore l'autorisation pour accéder aux données de santé
            showPermissionsView = true // Affiche la vue d'autorisation pour accéder aux données de santé
        }
    }
    
    func requestHealthAuthorisation() async {
        healthLoading = true // Active le spinner de chargement
        healthStatus = await HKHelper.requestAuth() // Attend l'autorisation pour accéder aux données de santé
        if healthAuth { // Si l'application a l'autorisation d'accéder aux données de santé
            loadWorkouts() // Charge les données de l'historique de l'utilisateur
        }
        healthLoading = false // Désactive le spinner de chargement
    }
    
    // MARK: - Workouts
    
    // Charge les entraînements depuis l'API HealthKit
    func loadWorkouts() {
        loadingWorkouts = true
        HKHelper.loadWorkouts { hkWorkouts in
            // Vérifie si des entraînements ont été retournés
            guard hkWorkouts.isNotEmpty else {
                DispatchQueue.main.async {
                    self.loadingWorkouts = false
                    // Si aucun entraînement n'a été retourné et que l'erreur n'a pas déjà été affichée, affiche l'erreur
                    if !self.shownNoWorkoutsError {
                        self.shownNoWorkoutsError = true
                        self.showError(.noWorkouts)
                    }
                }
                return
            }
            
            var tally = 0
            for hkWorkout in hkWorkouts {
                // Charge les coordonnées de l'entraînement depuis l'API HealthKit
                HKHelper.loadWorkoutRoute(hkWorkout: hkWorkout) { locations in
                    tally += 1
                    // Vérifie si des coordonnées ont été retournées
                    if locations.isNotEmpty {
                        // Crée un nouvel objet Workout à partir des données de l'entraînement et des coordonnées
                        let workout = Workout(hkWorkout: hkWorkout, locations: locations)
                        DispatchQueue.main.async {
                            // Ajoute l'entraînement à la liste des entraînements
                            self.workouts.append(workout)
                            // Vérifie si l'entraînement doit être affiché
                            if self.showWorkout(workout) {
                                // Si l'entraînement doit être affiché, ajoute-le à la liste des entraînements filtrés et affiche-le sur la carte
                                self.filteredWorkouts.append(workout)
                                self.mapView?.addOverlay(workout, level: .aboveRoads)
                            }
                        }
                    }
                    // Vérifie si tous les entraînements ont été traités
                    if tally == hkWorkouts.count {
                        DispatchQueue.main.async {
                            // Si tous les entraînements ont été traités, arrête l'animation de chargement
                            Haptics.success()
                            self.loadingWorkouts = false
                        }
                    }
                }
            }
        }
    }
    
    // Filtre les entraînements en fonction des critères de recherche
    func filterWorkouts() {
        // Supprime les entraînements existants de la carte
        mapView?.removeOverlays(mapView?.overlays(in: .aboveRoads) ?? [])
        // Filtre les entraînements en fonction des critères de recherche
        filteredWorkouts = workouts.filter { showWorkout($0) }
        // Ajoute les entraînements filtrés à la carte
        mapView?.addOverlays(filteredWorkouts, level: .aboveRoads)
        // Vérifie si l'entraînement sélectionné n'est plus visible et le désélectionne si c'est le cas
        if let selectedWorkout, !filteredWorkouts.contains(selectedWorkout) {
            self.selectedWorkout = nil
        }
    }
    
    
    // Détermine si un entraînement doit être affiché en fonction des critères de recherche
    func showWorkout(_ workout: Workout) -> Bool {
        // Vérifie si le workout courant est sélectionné ou si aucun workout n'a été sélectionné
            // Vérifie également si le type de workout correspond au type de workout sélectionné ou si aucun type n'a été sélectionné
            // Vérifie enfin si la date du workout correspond à la date sélectionnée ou si aucune date n'a été sélectionnée
            
        (selectedWorkout == nil || workout == selectedWorkout) &&
        (workoutType == nil || workoutType == workout.type) &&
        (workoutDate == nil || Calendar.current.isDate(workout.date, equalTo: .now, toGranularity: workoutDate!.granularity))
    }
    
    func selectClosestWorkout(to targetCoord: CLLocationCoordinate2D) {
        let targetLocation = targetCoord.location
        var shortestDistance = Double.infinity
        var closestWorkout: Workout?
        
        // Vérifie si la carte est actuellement visible, sinon arrête la fonction
        guard let rect = mapView?.visibleMapRect else { return }
        let left = MKMapPoint(x: rect.minX, y: rect.midY)
        let right = MKMapPoint(x: rect.maxX, y: rect.midY)
        let maxDelta = left.distance(to: right) / 20
        
        
        // Itère à travers tous les workouts filtrés
        for workout in filteredWorkouts {
            // Itère à travers tous les emplacements de chaque workout
            for location in workout.locations {
                let delta = location.distance(from: targetLocation)
                
                // Met à jour le workout le plus proche s'il est plus proche que le workout précédent et s'il est à l'intérieur de la zone de détection maximale
                if delta < shortestDistance && delta < maxDelta {
                    shortestDistance = delta
                    closestWorkout = workout
                }
            }
        }
        selectWorkout(closestWorkout)
    }
    
    func selectWorkout(_ workout: Workout?) {
        // Sélectionne le workout spécifié
        selectedWorkout = workout
        // Zoome sur le workout sélectionné si un workout est sélectionné
        if let workout {
            zoomTo(workout)
        }
    }
    
    func zoomTo(_ overlay: MKOverlay) {
        var bottomPadding = 20.0
        // Ajoute un padding supplémentaire si un workout est sélectionné
        if selectedWorkout != nil {
            bottomPadding += 160
        }
        // Ajoute un padding supplémentaire si l'enregistrement est actif
        if recording {
            bottomPadding += 160
        }
        // Définit le padding pour le zoom et zoome sur l'overlay spécifié
        let padding = UIEdgeInsets(top: 20, left: 20, bottom: bottomPadding, right: 20)
        mapView?.setVisibleMapRect(overlay.boundingMapRect, edgePadding: padding, animated: true)
    }
    
    // MARK: - Workout Tracking
    func startWorkout(type: HKWorkoutActivityType) async {
        updateHealthStatus()
        guard healthAuth else { return }
        
        let config = HKWorkoutConfiguration() // créer une configuration pour l'entraînement
        config.activityType = type // définit le type d'activité en fonction du paramètre d'entrée
        config.locationType = .outdoor // définit le type d'emplacement sur extérieur
        self.type = WorkoutType(hkType: type) // définit le type d'entraînement sur le type approprié
        
        routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local()) // créer un générateur d'itinéraire pour capturer les données GPS
        workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: config, device: .local()) // créer un constructeur d'entraînement pour capturer les données d'entraînement
        do {
            try await workoutBuilder?.beginCollection(at: .now)
        } catch {
            self.showError(.startingWorkout)
            return
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        updateTrackingMode(.followWithHeading) // met à jour la vue de la carte pour suivre l'emplacement de l'utilisateur
        
        Haptics.success()
        startDate = .now // définir la date de début de l'entraînement
        recording = true
        timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect().sink { _ in // crée une minuterie pour pulser l'interface utilisateur toutes les 0,5 secondes
            self.pulse.toggle()
        }
    }
    
    func discardWorkout() { // interdire les mises à jour de localisation en arrière-plan
        locationManager.allowsBackgroundLocationUpdates = false
        
        timer?.cancel()
        recording = false
        
        metres = 0
        locations = []
        updatePolylines()
        
        workoutBuilder?.discardWorkout()
        routeBuilder?.discard()
        Haptics.success()
    }
    
    func endWorkout() async {
        locationManager.allowsBackgroundLocationUpdates = false
        
        timer?.cancel()
        recording = false
        
        let workout = newWorkout
        workouts.append(workout)
        updatePolylines()
        filterWorkouts()
        selectWorkout(workout)
        
        metres = 0
        locations = []
        
        do {
            try await workoutBuilder?.endCollection(at: .now) // termine la collecte des données d'entraînement
            if let workout = try await workoutBuilder?.finishWorkout() { // terminer l'entraînement
                try await routeBuilder?.finishRoute(with: workout, metadata: nil) // terminer les données GPS
            }
            Haptics.success()
        } catch {
            showError(.endingWorkout) // affiche un message d'erreur s'il y a un problème pour terminer l'entraînement
        }
    }
    
    // MARK: - Map
    func updateTrackingMode(_ newMode: MKUserTrackingMode) {
        // Mettre à jour le mode de suivi des utilisateurs de la vue carte
        mapView?.setUserTrackingMode(newMode, animated: true)
        // Anime le changement de mode tracking avec un effet d'échelle
        if trackingMode == .followWithHeading || newMode == .followWithHeading {
            withAnimation(.easeInOut(duration: 0.25)) {
                scale = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.trackingMode = newMode
                withAnimation(.easeInOut(duration: 0.25)) {
                    self.scale = 1
                }
            }
        } else {
            DispatchQueue.main.async {
                self.trackingMode = newMode
            }
        }
    }
    
    func updateMapType(_ newType: MKMapType) {
        // Mettre à jour le type de carte de la vue cartographique
        mapView?.mapType = newType
        // Anime le changement de type de carte avec un effet de rotation
        withAnimation(.easeInOut(duration: 0.25)) {
            degrees += 90
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.mapType = newType
            withAnimation(.easeInOut(duration: 0.25)) {
                self.degrees += 90
            }
        }
    }
    
    func updatePolylines() {
        // Supprime les superpositions existantes et ajoute des polylignes mises à jour à la vue de la carte
        mapView?.removeOverlays(mapView?.overlays(in: .aboveLabels) ?? [])
        mapView?.addOverlay(polyline, level: .aboveLabels)
        // Ajoute la polyligne de l'entraînement sélectionné, le cas échéant
        if let selectedWorkout {
            mapView?.addOverlay(selectedWorkout.polyline, level: .aboveLabels)
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        // Sélectionnez l'entraînement le plus proche de l'emplacement sélectionné sur la vue de la carte
        guard let mapView = mapView else { return }
        let tapPoint = tap.location(in: mapView)
        let tapCoord = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        selectClosestWorkout(to: tapCoord)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewModel: CLLocationManagerDelegate {
    
    // Fonction appelée lorsqu'une nouvelle location est disponible
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard recording else { return }
        
        // Filtrage des locations selon la précision
        let filteredLocations = locations.filter { location in
            location.horizontalAccuracy < 50
        }

        // Calcul des mètres parcourus entre chaque nouvelle location
        for location in filteredLocations {
            if let lastLocation = self.locations.last {
                metres += location.distance(from: lastLocation)
            }
            self.locations.append(location)
        }
        
        updatePolylines()
        
        // Ajout des données de la route pour la construction de la carte
        routeBuilder?.insertRouteData(locations) { success, error in
            guard success else {
                print("Error inserting locations")
                return
            }
        }
    }
    
    // Fonction appelée lorsqu'il y a un changement d'autorisation de localisation
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        if locationAuth {
            manager.startUpdatingLocation()
            updateTrackingMode(.follow)
        } else {
            showPermissionsView = true
        }
        accuracyAuth = manager.accuracyAuthorization == .fullAccuracy
        if !accuracyAuth {
            showPermissionsView = true
        }
    }
}

// MARK: - MKMapView Delegate
extension ViewModel: MKMapViewDelegate {
    
    // Fonction appelée lorsque la carte doit afficher une superposition (overlay)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Si l'overlay est une polyline
        if let polyline = overlay as? MKPolyline {
            // Créer un rendu pour la polyline
            let render = MKPolylineRenderer(polyline: polyline)
            render.lineWidth = 2
            // Si la polyline est la sélection de l'entraînement en cours, utiliser la couleur orange, sinon indigo
            render.strokeColor = UIColor(polyline == selectedWorkout?.polyline ? .orange : .indigo)
            return render
            // Si l'overlay est un entraînement (Workout)
        } else if let workout = overlay as? Workout {
            // Créer un rendu pour la polyline de l'entraînement
            let render = MKPolylineRenderer(polyline: workout.polyline)
            render.lineWidth = 2
            // Utiliser la couleur associée au type d'entraînement
            render.strokeColor = UIColor(workout.type.colour)
            return render
        }
        // Si l'overlay n'est ni une polyline ni un entraînement, utiliser le rendu par défaut
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // Fonction appelée lorsque le mode de suivi de l'utilisateur sur la carte a changé
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        // Si le changement de mode n'est pas animé, mettre à jour le mode de suivi en aucun
        if !animated {
            updateTrackingMode(.none)
        }
    }
    
    // Fonction appelée lorsque l'utilisateur a sélectionné une annotation sur la carte
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Désélectionner l'annotation sans animation
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
