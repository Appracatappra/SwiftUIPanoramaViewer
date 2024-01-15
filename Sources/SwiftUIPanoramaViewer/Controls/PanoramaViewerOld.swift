////
////  PanoramaViewer.swift
////  SwiftUIPanoramaViewer Package
////
////  Created by Kevin Mullins on 2/8/22.
////  https://www.hackingwithswift.com/quick-start/swiftui/how-to-wrap-a-custom-uiview-for-swiftui
////
////  From: https://github.com/scihant/CTPanoramaView
//
//import Foundation
//import SwiftUI
//import UIKit
//
///// The `PanoramaViewer` allows you to display an interactive panorama viewer in a SwiftUI `View`.
/////
///// Take the following example:
/////
///// ```swift
///// @State var rotationIndicator:Float = 0.0
///// ...
/////
///// ZStack {
///// PanoramaViewer(image: SwiftUIPanoramaViewer.bindImage("PanoramaImageName")) {key in }
///// cameraMoved: { pitch, yaw, roll in
/////     rotationIndicator = yaw
///// }
/////
///// CompassView()
/////    .frame(width: 50.0, height: 50.0)
/////    .rotationEffect(Angle(degrees: Double(rotationIndicator)))
///// }
///// // If using `SwiftUIGamepad` package, allow the gamepad to rotate the view.
///// .onGamepadLeftThumbstick(viewID: viewID) { xAxis, yAxis in
/////     PanoramaManager.moveCamera(xAxis: xAxis, yAxis: yAxis)
///// }
///// ```
/////
//public struct PanoramaViewer: UIViewRepresentable {
//    // MARK: - Type
//    /// The type of view being managed by the `PanoramaViewer`.
//    public typealias UIViewType = CTPanoramaView
//    
//    // MARK: - Properties
//    /// The `UIImage` being displayed in the `PanoramaViewer`.
//    @Binding public var image: UIImage?
//    
//    /// The type of panorama image being displayed.
//    public var panoramaType: CTPanoramaType = .spherical
//    
//    /// The type of user interaction that the `PanoramaViewer` supports.
//    public var controlMethod: CTPanoramaControlMethod = .touch
//    
//    public var backgroundColor:UIColor = .black
//    
//    /// Handle the panorama being rotated.
//    @available(*, deprecated, message: "The rotationHandler property has been deprecated. Please use the cameraMoved property instead.")
//    public var rotationHandler: CTPanoramaView.CTRotationHandler? = nil
//    
//    /// Handles the panorama camera being moved and returns the new Pitch, Yaw and Rotation.
//    public var cameraMoved: CTPanoramaView.CTCameraMovedHandler? = nil
//    
//    // MARK: - Initializers
//    /// Creates a new instance.
//    /// - Parameters:
//    ///   - image: The `UIImage` being displayed in the `PanoramaViewer`.
//    ///   - panoramaType: The type of panorama image being displayed.
//    ///   - controlMethod: The type of user interaction that the `PanoramaViewer` supports.
//    ///   - rotationHandler: Handle the panorama being rotated.
//    ///   - cameraMoved: Handles the panorama camera being moved and returns the new Pitch, Yaw and Rotation.
//    public init(image: Binding<UIImage?>, panoramaType: CTPanoramaType = .spherical, controlMethod: CTPanoramaControlMethod = .touch, backgroundColor:UIColor = .black, rotationHandler: CTPanoramaView.CTRotationHandler? = nil, cameraMoved: CTPanoramaView.CTCameraMovedHandler? = nil) {
//        self._image = image
//        self.panoramaType = panoramaType
//        self.controlMethod = controlMethod
//        self.backgroundColor = backgroundColor
//        self.rotationHandler = rotationHandler
//        self.cameraMoved = cameraMoved
//    }
//    
//    // MARK: - Functions
//    /// Creates a new instance of the `PanoramaViewer`.
//    /// - Parameter context: The context to create the viewer in.
//    /// - Returns: Returns the new `PanoramaViewer`.
//    public func makeUIView(context: Context) -> UIViewType {
//        // Create and initialize
//        let view = CTPanoramaView()
//        view.image = image
//        view.panoramaType = panoramaType
//        view.backgroundColor = backgroundColor
//        view.controlMethod = controlMethod
//        view.rotationHandler = rotationHandler
//        view.cameraMoved = cameraMoved
//        
//        // Save reference to connect to compass view
//        PanoramaManager.lastPanoramaViewer = view
//        
//        // Return viewer
//        return view
//    }
//    
//    /// Handles the `PanoramaViewer` being updated.
//    /// - Parameters:
//    ///   - uiView: The `PanoramaViewer` that is updating.
//    ///   - context: The context that the view is updating in.
//    public func updateUIView(_ uiView: UIViewType, context: Context) {
//        // NOTE: shouldUpdateImage should be set to `true` only when the displayed panorama image needs to be changed.
//        // This is used to keep the view and rotation from reseting any time an image is changed. It also keeps the viewer from "flickering" in the UI when the user iteracts with the viewer.
//        if PanoramaManager.shouldUpdateImage {
//            uiView.image = image
//            PanoramaManager.shouldUpdateImage = false
//        }
//    }
//}
