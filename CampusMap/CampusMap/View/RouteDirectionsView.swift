//
//  RouteDirectionsView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/14/24.
//

import SwiftUI

struct RouteDirectionsView: View {
    @ObservedObject var viewModel: BuildingViewModel

    var body: some View {
        VStack {
            Text("Expected Travel Time: \(formatTravelTime(viewModel.expectedTravelTime))")
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(.bottom, 5)

            Text(viewModel.routeSteps[viewModel.currentStepIndex].instructions)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < 0 {
                                
                                if viewModel.currentStepIndex < viewModel.routeSteps.count - 1 {
                                    viewModel.currentStepIndex += 1
                                }
                            } else if value.translation.width > 0 {
                                
                                if viewModel.currentStepIndex > 0 {
                                    viewModel.currentStepIndex -= 1
                                }
                            }
                        }
                )
        }
        .padding()
    }

    func formatTravelTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return "\(minutes) min \(seconds) sec"
    }
}
