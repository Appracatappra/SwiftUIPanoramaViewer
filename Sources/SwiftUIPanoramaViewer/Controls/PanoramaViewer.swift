//
//  PanoramaViewer.swift
//  Escape from Mystic Manor (iOS)
//
//  Created by Kevin Mullins on 2/8/22.
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-wrap-a-custom-uiview-for-swiftui
//
//  From: https://github.com/scihant/CTPanoramaView

import Foundation
import SwiftUI
import UIKit

struct PanoramaViewer: UIViewRepresentable {
    typealias UIViewType = CTPanoramaView
    
    @Binding var image: UIImage?
    var panoramaType: CTPanoramaType = .spherical
    var controlMethod: CTPanoramaControlMethod = .touch
    var rotationHandler: ((_ rotationKey: Int) -> Void)?
    var cameraMoved: ((_ pitch:Float, _ yaw:Float, _ roll:Float) -> Void)?
    
    func makeUIView(context: Context) -> UIViewType {
        // Create and initialize
        let view = CTPanoramaView()
        view.image = image
        view.panoramaType = panoramaType
        view.controlMethod = controlMethod
        view.rotationHandler = rotationHandler
        view.cameraMoved = cameraMoved
        
        // Save reference to connect to compass view
        PanoramaManager.lastPanoramaViewer = view
        
        // Return viewer
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if PanoramaManager.shouldUpdateImage {
            uiView.image = image
            PanoramaManager.shouldUpdateImage = false
        }
    }
}
