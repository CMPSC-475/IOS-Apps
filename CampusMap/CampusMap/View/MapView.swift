//
//  MapView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last?.coordinate {
            location = newLocation
        }
    }
    
    private let customPinsKey = "customPins"

    // Save custom pins
    func saveCustomPins(_ pins: [MKPointAnnotation]) {
        let coordinates = pins.map { ["latitude": $0.coordinate.latitude, "longitude": $0.coordinate.longitude, "title": $0.title ?? ""] }
        UserDefaults.standard.setValue(coordinates, forKey: customPinsKey)
    }

    // Load custom pins
    func loadCustomPins() -> [MKPointAnnotation] {
        guard let savedPins = UserDefaults.standard.array(forKey: customPinsKey) as? [[String: Any]] else {
            return []
        }

        return savedPins.compactMap { dict in
            if let latitude = dict["latitude"] as? CLLocationDegrees,
               let longitude = dict["longitude"] as? CLLocationDegrees,
               let title = dict["title"] as? String {
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                pin.title = title
                return pin
            }
            return nil
        }
    }
    
    // Function to delete a custom pin
    func deleteCustomPin(_ pin: MKPointAnnotation) {
        var existingPins = loadCustomPins()
        existingPins.removeAll { $0.coordinate.latitude == pin.coordinate.latitude && $0.coordinate.longitude == pin.coordinate.longitude }
        saveCustomPins(existingPins)
    }
    
    // Delete all custom pins
    func deleteAllCustomPins() {
        UserDefaults.standard.removeObject(forKey: customPinsKey)
    }
}

struct MapView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: BuildingViewModel
    @StateObject private var locationManager = LocationManager()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Enable user location
        mapView.showsUserLocation = true
        
        // Add long press gesture recognizer to drop a marker
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
        
        viewController.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = .white
        buttonContainer.layer.cornerRadius = 10
        buttonContainer.layer.shadowColor = UIColor.black.cgColor
        buttonContainer.layer.shadowOpacity = 0.2
        buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonContainer.layer.shadowRadius = 4
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Create buttons for the first row
        let selectButton = UIButton(type: .system)
        selectButton.setImage(UIImage(systemName: "building.2"), for: .normal)
        selectButton.addTarget(context.coordinator, action: #selector(Coordinator.selectBuildings), for: .touchUpInside)

        let centerButton = UIButton(type: .system)
        centerButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        centerButton.addTarget(context.coordinator, action: #selector(Coordinator.centerOnUser), for: .touchUpInside)

        let toggleVisibilityButton = UIButton(type: .system)
        toggleVisibilityButton.setImage(UIImage(systemName: "eye"), for: .normal)
        toggleVisibilityButton.addTarget(context.coordinator, action: #selector(Coordinator.toggleVisibility), for: .touchUpInside)

        let deselectButton = UIButton(type: .system)
        deselectButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        deselectButton.addTarget(context.coordinator, action: #selector(Coordinator.deselectAll), for: .touchUpInside)

        // Create buttons for the second row
        let removeRouteButton = UIButton(type: .system)
        removeRouteButton.setTitle("Remove Route", for: .normal)
        removeRouteButton.addTarget(context.coordinator, action: #selector(Coordinator.removeRoute), for: .touchUpInside)

        let deleteAllPinsButton = UIButton(type: .system)
        deleteAllPinsButton.setTitle("Delete All Pins", for: .normal)
        deleteAllPinsButton.addTarget(context.coordinator, action: #selector(Coordinator.deleteAllPins), for: .touchUpInside)

        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete Pin", for: .normal)
        deleteButton.addTarget(context.coordinator, action: #selector(Coordinator.deleteCustomPin), for: .touchUpInside)

        // Create buttons for the third row (map type selection)
        let standardButton = UIButton(type: .system)
        standardButton.setTitle("Standard", for: .normal)
        standardButton.addTarget(context.coordinator, action: #selector(Coordinator.setStandardMap), for: .touchUpInside)

        let hybridButton = UIButton(type: .system)
        hybridButton.setTitle("Hybrid", for: .normal)
        hybridButton.addTarget(context.coordinator, action: #selector(Coordinator.setHybridMap), for: .touchUpInside)

        let imageryButton = UIButton(type: .system)
        imageryButton.setTitle("Satellite", for: .normal)
        imageryButton.addTarget(context.coordinator, action: #selector(Coordinator.setImageryMap), for: .touchUpInside)

        // Create stack views for button rows
        let firstRowStackView = UIStackView(arrangedSubviews: [selectButton, centerButton, toggleVisibilityButton, deselectButton])
        firstRowStackView.axis = .horizontal
        firstRowStackView.spacing = 65
        firstRowStackView.translatesAutoresizingMaskIntoConstraints = false

        let secondRowStackView = UIStackView(arrangedSubviews: [removeRouteButton, deleteAllPinsButton, deleteButton])
        secondRowStackView.axis = .horizontal
        secondRowStackView.spacing = 25
        secondRowStackView.translatesAutoresizingMaskIntoConstraints = false

        let thirdRowStackView = UIStackView(arrangedSubviews: [standardButton, hybridButton, imageryButton])
        thirdRowStackView.axis = .horizontal
        thirdRowStackView.spacing = 70
        thirdRowStackView.translatesAutoresizingMaskIntoConstraints = false

        // Combine all three rows into a vertical stack view
        let mainStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView, thirdRowStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        buttonContainer.addSubview(mainStackView)
        viewController.view.addSubview(buttonContainer)

        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonContainer.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            buttonContainer.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            buttonContainer.heightAnchor.constraint(equalToConstant: 120) // Adjust height as necessary
        ])

        
        // Store the mapView in the view model
        context.coordinator.mapView = mapView
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let mapView = context.coordinator.mapView {
            if let userLocation = locationManager.location {
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
            
            // Update annotations
            mapView.removeAnnotations(mapView.annotations)
            let annotations = viewModel.displayedBuildings.map { building in
                let annotation = MKPointAnnotation()
                annotation.coordinate = building.coordinate
                annotation.title = building.name
                return annotation
            }
            mapView.addAnnotations(annotations)
            
            // Load and add custom pins
            let customPins = locationManager.loadCustomPins()
            mapView.addAnnotations(customPins)
            
            // Display the route as a polyline
            if viewModel.route != nil {
                context.coordinator.displayRoute()
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapView: MKMapView?
        var droppedPin: MKPointAnnotation?
        var selectedCustomPin: MKPointAnnotation?
        
        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Return nil for the user's location annotation
            if annotation is MKUserLocation {
                return nil
            }
            
            // Check if it's a building annotation by title
            if let annotationTitle = annotation.title, let building = parent.viewModel.displayedBuildings.first(where: { $0.name == annotationTitle }) {
                let identifier = "BuildingAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                
                // Set the marker color based on whether the building is favorited
                annotationView?.markerTintColor = building.isFavorited ? .red : .blue
                return annotationView
            }
            
            // Handle custom dropped pin
            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            // Set the color for the dropped pin (if it's the dropped pin)
            if annotation === droppedPin {
                annotationView?.markerTintColor = .green
            }
            
            return annotationView
        }
        // Add long press gesture recognizer to mapView
        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            guard let mapView = mapView else { return }

            if gestureRecognizer.state == .began {
                let touchPoint = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

                // Add a new pin at the touched location
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "Custom Pin"
                mapView.addAnnotation(annotation)

                // Store a reference to the dropped pin
                selectedCustomPin = annotation

                // Load existing pins
                let existingPins = parent.locationManager.loadCustomPins()
                var allPins = existingPins
                allPins.append(annotation)

                // Save the updated pins
                parent.locationManager.saveCustomPins(allPins)
            }
        }

        @objc func deleteAllPins() {
            // Remove all annotations of type MKPointAnnotation
            guard let mapView = mapView else { return }
            let annotationsToRemove = mapView.annotations.filter { $0 is MKPointAnnotation }
            mapView.removeAnnotations(annotationsToRemove)
            // Clear custom pins from storage
            parent.locationManager.deleteAllCustomPins()
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotationTitle = view.annotation?.title else { return }
            if let building = parent.viewModel.displayedBuildings.first(where: { $0.name == annotationTitle }) {
                parent.viewModel.selectedBuilding = building
                showBuildingDetail(for: building)
            } else if annotationTitle == "Custom Pin" {
                
                if let coordinate = view.annotation?.coordinate {
                    let customBuilding = Building(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                        name: annotationTitle!,
                        opp_bldg_code: 0,
                        year_constructed: nil,
                        photo: nil
                    )
                    
                    parent.viewModel.selectedBuilding = customBuilding
                    showBuildingDetail(for: customBuilding)
                }
            }
            if let customPin = view.annotation as? MKPointAnnotation, customPin.title == "Custom Pin" {
                selectedCustomPin = customPin
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func displayRoute() {
            guard let route = parent.viewModel.route else { return }
            
            // Remove existing overlays
            mapView?.removeOverlays(mapView?.overlays ?? [])
            
            // Add new polyline overlay for the route
            mapView?.addOverlay(route.polyline)
        }
        
        func showBuildingDetail(for building: Building) {
            let buildingDetailView = BuildingDetailView(building: building, viewModel: parent.viewModel)
            
            // Present the BuildingDetailView
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let rootViewController = scene.windows.first?.rootViewController {
                    let hostingController = UIHostingController(rootView: buildingDetailView)
                    hostingController.modalPresentationStyle = .fullScreen
                    rootViewController.present(hostingController, animated: true, completion: nil)
                }
            }
        }

        @objc func selectBuildings() {
            let buildingSelectionViewController = BuildingSelectionViewController(viewModel: parent.viewModel)
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let rootViewController = scene.windows.first?.rootViewController {
                    let hostingController = UIHostingController(rootView: buildingSelectionViewController)
                    rootViewController.present(hostingController, animated: true)
                }
            }
        }

        @objc func centerOnUser() {
            if let userLocation = parent.locationManager.location {
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView?.setRegion(region, animated: true)
            }
        }

        @objc func toggleVisibility() {
            if parent.viewModel.displayedBuildings.isEmpty {
                parent.viewModel.showAllBuildings()
            } else {
                parent.viewModel.hideDisplayedBuildings()
            }
        }

        @objc func deselectAll() {
            parent.viewModel.deselectAllBuildings()
        }

        @objc func removeRoute() {
            parent.viewModel.clearRoute() // Clear the route from the view model
            mapView?.removeOverlays(mapView?.overlays ?? []) // Remove the route from the map
        }

        @objc func deleteCustomPin() {
            guard let pinToDelete = selectedCustomPin else { return }
            mapView?.removeAnnotation(pinToDelete)
            parent.locationManager.deleteCustomPin(pinToDelete)
            selectedCustomPin = nil // Clear selection after deletion
        }
        
        @objc func setStandardMap() {
            mapView?.mapType = .standard
        }

        @objc func setHybridMap() {
            mapView?.mapType = .hybrid
        }

        @objc func setImageryMap() {
            mapView?.mapType = .satellite
        }
    }
}


#Preview {
    MapView(viewModel: BuildingViewModel())
}
