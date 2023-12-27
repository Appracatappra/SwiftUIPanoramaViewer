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
public struct CompassView: UIViewRepresentable {
    public typealias UIViewType = CTPieSliceView
    
    public var sliceColor: UIColor = .red
    public var outerRingColor: UIColor = .green
    public var bgColor: UIColor = .black
    
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
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        //uiView.attributedText = text
    }
}
