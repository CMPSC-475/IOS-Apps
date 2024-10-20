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
        
        viewController.view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        
        // Set up buttons
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select Buildings", for: .normal)
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

        let stackView = UIStackView(arrangedSubviews: [selectButton, centerButton, toggleVisibilityButton, deselectButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
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
            
            // Update annotations based on the displayed buildings
            mapView.removeAnnotations(mapView.annotations)
            let annotations = viewModel.displayedBuildings.map { building in
                let annotation = MKPointAnnotation()
                annotation.coordinate = building.coordinate
                annotation.title = building.name
                return annotation
            }
            mapView.addAnnotations(annotations)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapView: MKMapView?

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotationTitle = view.annotation?.title else { return }
            if let building = parent.viewModel.displayedBuildings.first(where: { $0.name == annotationTitle }) {
                parent.viewModel.selectedBuilding = building
                showBuildingDetail(for: building)
            }
        }

        func showBuildingDetail(for building: Building) {
            let buildingDetailView = BuildingDetailView(building: building, viewModel: parent.viewModel)
            
            // Present the BuildingDetailView
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let rootViewController = scene.windows.first?.rootViewController {
                    let hostingController = UIHostingController(rootView: buildingDetailView)
                    rootViewController.present(hostingController, animated: true)
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
    }
}

#Preview {
    MapView(viewModel: BuildingViewModel())
}
