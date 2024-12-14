//
//  EstimateImageRenderer.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/14/24.
//

import UIKit
import SwiftUI

struct EstimateImageRenderer: UIViewRepresentable {
    let estimateView: EstimateView

    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: estimateView)
        hostingController.view.frame = UIScreen.main.bounds
        hostingController.view.backgroundColor = .white
        return hostingController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func renderAsImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        return renderer.image { _ in
            let hostingController = UIHostingController(rootView: estimateView)
            hostingController.view.frame = UIScreen.main.bounds
            hostingController.view.backgroundColor = .white
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
    }
}
