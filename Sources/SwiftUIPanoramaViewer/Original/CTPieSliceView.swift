//
//  CTPieSliceView.swift
//  CTPanoramaView
//
//  Created by Cihan Tek on 15/10/16.
//  Copyright © 2016 Home. All rights reserved.
//
//  From: https://github.com/scihant/CTPanoramaView

import UIKit

/// The `CTPieSliceView` provides an indicator of which direction the panorama  viewer is pointing.
/// - Remark: When using is a SwiftUI `View`, don't use `CTPieSliceView` directly, use a `CompassView` instead.
@IBDesignable @objcMembers public class CTPieSliceView: UIView {

    // MARK: - Properties
    /// The angle of the indicator "slice".
    @IBInspectable public var sliceAngle: CGFloat = .pi/2 {
        didSet { setNeedsDisplay() }
    }

    /// The color of the indicator slice.
    @IBInspectable public var sliceColor: UIColor = .red {
        didSet { setNeedsDisplay() }
    }

    /// The color of the outer ring.
    @IBInspectable public var outerRingColor: UIColor = .green {
        didSet { setNeedsDisplay() }
    }

    /// The background color.
    @IBInspectable public var bgColor: UIColor = .black {
        didSet { setNeedsDisplay() }
    }

    #if !TARGET_INTERFACE_BUILDER
    /// Creates a new instance.
    /// - Parameter aDecoder: The `NSCoder` to build the view from.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// Creates a new instance.
    /// - Parameter frame: The frame to build the view in.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    #endif

    /// Common procedures used in all initializers.
    func commonInit() {
        backgroundColor = UIColor.clear
        contentMode = .redraw
    }

    // MARK: - Functions
    /// Draws the indicator into the view with the given size.
    /// - Parameter rect: The size and location of the view.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let ctx = UIGraphicsGetCurrentContext() else {return}

        // Draw the background
        ctx.addEllipse(in: bounds)
        ctx.setFillColor(bgColor.cgColor)
        ctx.fillPath()

        // Draw the outer ring
        ctx.addEllipse(in: bounds.insetBy(dx: 2, dy: 2))
        ctx.setStrokeColor(outerRingColor.cgColor)
        ctx.setLineWidth(2)
        ctx.strokePath()

        let radius = (bounds.width/2)-6
        let localCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let startAngle = -(.pi/2 + sliceAngle/2)
        let endAngle = startAngle + sliceAngle
        let arcStartPoint = CGPoint(x: localCenter.x + radius * cos(startAngle),
                                    y: localCenter.y + radius * sin(startAngle))

        // Draw the inner slice
        ctx.beginPath()
        ctx.move(to: localCenter)
        ctx.addLine(to: arcStartPoint)
        ctx.addArc(center: localCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx.closePath()
        ctx.setFillColor(sliceColor.cgColor)
        ctx.fillPath()
    }
}

/// Extends `CTPanoramaCompass` and provides a common update function.
extension CTPieSliceView: CTPanoramaCompass {
    
    // MARK: - Functions
    /// Updates the control's UI.
    /// - Parameters:
    ///   - rotationAngle: The new rotation angle.
    ///   - fieldOfViewAngle: The field of view.
    public func updateUI(rotationAngle: CGFloat, fieldOfViewAngle: CGFloat) {
        sliceAngle = fieldOfViewAngle
        transform = CGAffineTransform.identity.rotated(by: rotationAngle)
    }
}
