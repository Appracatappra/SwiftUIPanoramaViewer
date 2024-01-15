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

public struct CompassView: UIViewRepresentable {
    public typealias UIViewType = CTPieSliceView
    
    public var sliceColor: UIColor = .red
    public var outerRingColor: UIColor = .green
    public var bgColor: UIColor = .black
    
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
