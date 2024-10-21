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
        
        // Set up buttons for the first row
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

        let removeRouteButton = UIButton(type: .system)
        removeRouteButton.setTitle("Remove Route", for: .normal)
        removeRouteButton.addTarget(context.coordinator, action: #selector(Coordinator.removeRoute), for: .touchUpInside)

        // Create buttons for map type selection (second row)
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
        let firstRowStackView = UIStackView(arrangedSubviews: [selectButton, centerButton, toggleVisibilityButton, deselectButton, removeRouteButton])
        firstRowStackView.axis = .horizontal
        firstRowStackView.spacing = 20
        firstRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let secondRowStackView = UIStackView(arrangedSubviews: [standardButton, hybridButton, imageryButton])
        secondRowStackView.axis = .horizontal
        secondRowStackView.spacing = 50
        secondRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Combine both rows into a vertical stack view
        let mainStackView = UIStackView(arrangedSubviews: [firstRowStackView, secondRowStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 5
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonContainer.addSubview(mainStackView)
        viewController.view.addSubview(buttonContainer)

        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonContainer.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            buttonContainer.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            buttonContainer.heightAnchor.constraint(equalToConstant: 100)
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
            
            // Display the route as a polyline
            if viewModel.route != nil {
                context.coordinator.displayRoute()
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapView: MKMapView?

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            guard let annotationTitle = annotation.title else { return nil }


            let identifier = "BuildingAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }


            if let building = parent.viewModel.displayedBuildings.first(where: { $0.name == annotationTitle }) {
                annotationView?.markerTintColor = building.isFavorited ? .red : .blue
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotationTitle = view.annotation?.title else { return }
            if let building = parent.viewModel.displayedBuildings.first(where: { $0.name == annotationTitle }) {
                parent.viewModel.selectedBuilding = building
                showBuildingDetail(for: building)
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
