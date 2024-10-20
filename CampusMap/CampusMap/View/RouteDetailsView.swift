import SwiftUI

struct RouteDetailsView: View {
    let expectedTravelTime: TimeInterval // Travel time in seconds
    let steps: [String] // Step instructions
    
    @State private var currentStepIndex = 0
    
    var body: some View {
        VStack {
            Text("Estimated Travel Time: \(formattedTravelTime)")
                .font(.headline)
            
            if !steps.isEmpty {
                VStack {
                    Text("Step \(currentStepIndex + 1)/\(steps.count)")
                        .font(.subheadline)
                    Text(steps[currentStepIndex])
                        .padding()
                    
                    HStack {
                        Button(action: previousStep) {
                            Text("Previous")
                        }
                        .disabled(currentStepIndex == 0)

                        Spacer()

                        Button(action: nextStep) {
                            Text("Next")
                        }
                        .disabled(currentStepIndex == steps.count - 1)
                    }
                }
                .padding()
            }
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private var formattedTravelTime: String {
        let minutes = Int(expectedTravelTime / 60)
        let seconds = Int(expectedTravelTime.truncatingRemainder(dividingBy: 60))
        return "\(minutes)m \(seconds)s"
    }
    
    private func previousStep() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
    
    private func nextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        }
    }
}
