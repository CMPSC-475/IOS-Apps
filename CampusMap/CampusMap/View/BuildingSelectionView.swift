//
//  BuildingSelectionView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI

struct BuildingSelectionViewController: UIViewControllerRepresentable {
    @ObservedObject var viewModel: BuildingViewModel

    func makeUIViewController(context: Context) -> UIHostingController<BuildingSelectionView> {
        let hostingController = UIHostingController(rootView: BuildingSelectionView(viewModel: viewModel, onDone: {
            context.coordinator.dismissViewController()
        }))
        hostingController.view.backgroundColor = .white // Set a background color if needed
        return hostingController
    }

    func updateUIViewController(_ uiViewController: UIHostingController<BuildingSelectionView>, context: Context) {
        // Update the root view with the latest view model
        uiViewController.rootView = BuildingSelectionView(viewModel: viewModel, onDone: {
            context.coordinator.dismissViewController()
        })
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: BuildingSelectionViewController

        init(_ parent: BuildingSelectionViewController) {
            self.parent = parent
        }

        func dismissViewController() {
            // Get the current UIViewController that presented this view
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}


struct BuildingSelectionView: View {
    @ObservedObject var viewModel: BuildingViewModel
    var onDone: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(BuildingFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ForEach(viewModel.displayedBuildings.sorted(by: { $0.name < $1.name })) { building in
                    HStack {
                        Toggle(isOn: Binding<Bool>(
                            get: { building.isSelected },
                            set: { _ in viewModel.toggleBuildingSelection(building) }
                        )) {
                            Text(building.name)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.toggleFavoriteStatus(building)
                        }) {
                            Image(systemName: building.isFavorited ? "heart.fill" : "heart")
                                .foregroundColor(building.isFavorited ? .red : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationBarTitle("Select Buildings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                //viewModel.showingDetail = false
                onDone()
            })
        }
    }
}
