//
//  CompassView.swift
//  Escape from Mystic Manor (iOS)
//
//  Created by Kevin Mullins on 2/9/22.
//
//  From: https://github.com/scihant/CTPanoramaView

import Foundation
import SwiftUI
import UIKit

/// The `CompassView` wraps a `CTPieSliceView` so that it can be used in a SwiftUI view.
///
/// When displaying a `CompassView` in your SwiftUI `View`, place it in a `Zstack` to overlay the `PanoramaViewer` and use the `rotationEffect` attribute to rotate it to match the panorama's rotation. See:
///
/// ```swift
/// @State var rotationIndicator:Float = 0.0
/// ...
///
/// ZStack {
/// PanoramaViewer(image: SwiftUIPanoramaViewer.bindImage("PanoramaImageName")) {key in }
/// cameraMoved: { pitch, yaw, roll in
///     rotationIndicator = yaw
/// }
///
/// CompassView()
///    .frame(width: 50.0, height: 50.0)
///    .rotationEffect(Angle(degrees: Double(rotationIndicator)))
/// }
/// ```
public struct CompassView: UIViewRepresentable {
    /// The type of view being created and managed by `CompassView`.
    public typealias UIViewType = CTPieSliceView
    
    // MARK: - Properties
    /// The color to draw the indicator slice in.
    public var sliceColor: UIColor = .red
    
    /// The outer ring color.
    public var outerRingColor: UIColor = .green
    
    /// The background color.
    public var bgColor: UIColor = .black
    
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameters:
    ///   - sliceColor: The color to draw the indicator slice in.
    ///   - outerRingColor: The outer ring color.
    ///   - bgColor: The background color.
    public init(sliceColor: UIColor = .red, outerRingColor: UIColor = .green, bgColor: UIColor = .black) {
        self.sliceColor = sliceColor
        self.outerRingColor = outerRingColor
        self.bgColor = bgColor
    }
    
    // MARK: - Functions
    /// Creates a new `CompassView` in the given context.
    /// - Parameter context: The context to build the view in.
    /// - Returns: Returns the new `CompassView`.
    public func makeUIView(context: Context) -> UIViewType {
        // Create and configure
        let view = CTPieSliceView()
        view.sliceColor = sliceColor
        view.outerRingColor = outerRingColor
        view.bgColor = bgColor
        
        // Attach compass to viewer
        //PanoramaManager.connectCompass(view)
        
        // Return view
        return view
    }
    
    /// Handles the `CompassView` needing to be updated.
    /// - Parameters:
    ///   - uiView: The `CompassView` to update.
    ///   - context: The update context.
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        //uiView.attributedText = text
    }
}
