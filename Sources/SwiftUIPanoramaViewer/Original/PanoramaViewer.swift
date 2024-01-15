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

public struct PanoramaViewer: UIViewRepresentable {
    public typealias UIViewType = CTPanoramaView
    
    @Binding public var image: UIImage?
    public var panoramaType: CTPanoramaType = .spherical
    public var controlMethod: CTPanoramaControlMethod = .touch
    public var backgroundColor:UIColor = .black
    public var rotationHandler: ((_ rotationKey: Int) -> Void)?
    public var cameraMoved: ((_ pitch:Float, _ yaw:Float, _ roll:Float) -> Void)?
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - image: The `UIImage` being displayed in the `PanoramaViewer`.
    ///   - panoramaType: The type of panorama image being displayed.
    ///   - controlMethod: The type of user interaction that the `PanoramaViewer` supports.
    ///   - rotationHandler: Handle the panorama being rotated.
    ///   - cameraMoved: Handles the panorama camera being moved and returns the new Pitch, Yaw and Rotation.
    public init(image: Binding<UIImage?>, panoramaType: CTPanoramaType = .spherical, controlMethod: CTPanoramaControlMethod = .touch, backgroundColor:UIColor = .black, rotationHandler: ((_ rotationKey: Int) -> Void)? = nil, cameraMoved: ((_ pitch:Float, _ yaw:Float, _ roll:Float) -> Void)? = nil) {
        self._image = image
        self.panoramaType = panoramaType
        self.controlMethod = controlMethod
        self.backgroundColor = backgroundColor
        self.rotationHandler = rotationHandler
        self.cameraMoved = cameraMoved
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        // Create and initialize
        let view = CTPanoramaView()
        view.image = image
        view.panoramaType = panoramaType
        view.controlMethod = controlMethod
        view.backgroundColor = backgroundColor
        view.rotationHandler = rotationHandler
        view.cameraMoved = cameraMoved
        
        // Save reference to connect to compass view
        PanoramaManager.lastPanoramaViewer = view
        
        // Return viewer
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        if PanoramaManager.shouldUpdateImage {
            uiView.image = image
            PanoramaManager.shouldUpdateImage = false
        }
    }
}
