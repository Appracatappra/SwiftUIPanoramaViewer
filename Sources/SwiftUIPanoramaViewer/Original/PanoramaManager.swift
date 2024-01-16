//
//  PanoramaManager.swift
//  Escape from Mystic Manor (iOS)
//
//  Created by Kevin Mullins on 2/9/22.
//
//  From: https://github.com/scihant/CTPanoramaView

import Foundation
import SwiftUI
import UIKit

// Handles comminication with any panoramaview that has been embedded in a SwiftUI `View`.
/// - Remark: Only one `PanoramaViewer` can be active in an app at one time.
public class PanoramaManager {
    
    // MARK: - Enumerations
    /// The type of target being worked with.
    public enum TargetType {
        /// A navigation target.
        case navigation
        
        /// An interaction target.
        case interaction
    }
    
    // MARK: - Static Properties
    /// Value that demarks an empty point.
    static public let emptyPoint:Float = 1000.0
    
    /// Reference to the last panorama viewer that has been added to the app.
    static public weak var lastPanoramaViewer:CTPanoramaView? = nil
    
    /// If `true` the panorama view should updated the current image being displayed, if `false` the image will update.
    /// - Remark: This feature is used to keep the panorama viewer from reseting itself when the SwiftUI view it is on updates layout but the "location" being viewed hasn't hanged.
    static public var shouldUpdateImage:Bool = false
    
    /// If `true` when the image changes the rotation of the camera resets when a new image is loaded, else it does not.
    static public var shouldResetCameraAngle:Bool = true
    
    /// The value of the last rotation key.
    static public var lastRotationKey:Int = 0
    
    /// Defines the offsets used to make a navigation target.
    static public let targetSizeNavigation:Float = 10.0
    
    /// Defines the offsets used to make an interaction target.
    static public let targetSizeInteraction:Float = 5.0
    
    // MARK: - Static Functions
    /// Connects a panorama "pie slice" compass to the viewier.
    /// - Parameter compass: The compass view to attach.
    public static func connectCompass(_ compass:CTPieSliceView) {
        // Ensure a panorama is connected
        guard let viewer = PanoramaManager.lastPanoramaViewer else {
            return
        }
        
        // Attach compass to viewer
        viewer.compass = compass
        
        // Release connection to viewer
        PanoramaManager.lastPanoramaViewer = nil
    }
    
    /// Moves the panorama rotation to the given X and Y coordinates.
    ///
    /// This function can be used with our `SwiftUIGamepad` package to allow a Gamepad attached to the device to rotate the panorama:
    ///
    /// ```
    /// contents()
    ///.onGamepadLeftThumbstick(viewID: viewID) { xAxis, yAxis in
    ///     PanoramaManager.moveCamera(xAxis: xAxis, yAxis: yAxis)
    ///}
    /// ```
    /// See: https://github.com/Appracatappra/SwiftUIGamepad for details.
    ///
    /// - Parameters:
    ///   - xAxis: The new X axis location.
    ///   - yAxis: The new Y axis location.
    public static func moveCamera(xAxis:Float, yAxis:Float) {
        let location = CGPoint(x: CGFloat(xAxis * -10.0), y: CGFloat(yAxis * 10.0))
        PanoramaManager.lastPanoramaViewer?.handlePan(location: location)
    }
    
    /// Calculate the leading target point.
    /// - Parameters:
    ///   - point: The center of the target.
    ///   - targetType: The type of target to generate.
    /// - Returns: The leading target point.
    static public func leadingTarget(_ point:Float, targetType:TargetType = .navigation) -> Float {
        var target = point
        
        guard point != emptyPoint else {
            return emptyPoint
        }
        
        switch targetType {
        case .navigation:
            target += targetSizeNavigation
        case .interaction:
            target += targetSizeInteraction
        }
        
        if target > 360.0 {
            target -= 360.0
        }
        
        return target
    }
    
    /// Calculates the trailing target point.
    /// - Parameters:
    ///   - point: The center of the target.
    ///   - targetType: The type of target to generate.
    /// - Returns: The trailing target point.
    static public func trailingTarget(_ point:Float, targetType:TargetType = .navigation) -> Float {
        var target = point
        
        guard point != emptyPoint else {
            return emptyPoint
        }
        
        switch targetType {
        case .navigation:
            target -= targetSizeNavigation
        case .interaction:
            target -= targetSizeInteraction
        }
        
        if target < 0.0 {
            target += 360.0
        }
        
        return target
    }
    
    /// Tests the given Pitch and Yaw to see in they are inside of the target specified by the given points.
    /// - Parameters:
    ///   - pitch: The pitch to test.
    ///   - yaw: The yaw to test.
    ///   - pitchLeading: The leading pitch point.
    ///   - pitchTrailing: The trailing pitch point.
    ///   - yawLeading: The leading yaw point.
    ///   - yawTrailing: The trailing yaw point.
    /// - Returns: Returns `true` if the pitch and yaw are inside of the target, else returns `false`.
    static public func targetHit(pitch:Float, yaw:Float, pitchLeading:Float, pitchTrailing:Float, yawLeading:Float, yawTrailing:Float) -> Bool {
        var result = false
        
        // Generated against an empty point?
        if pitchLeading == emptyPoint {
            return false
        }
        
        result = inRange(point: pitch, pointLeading: pitchLeading, pointTrailing: pitchTrailing)
        result = result && inRange(point: yaw, pointLeading: yawLeading, pointTrailing: yawTrailing)
        
        return result
    }
    
    /// Tests the given rotational point to see if it is inside of the specified range.
    /// - Parameters:
    ///   - point: The point to test.
    ///   - pointLeading: The leading rotation point.
    ///   - pointTrailing: The trailing rotation point.
    /// - Returns: Returns `true` if the point is inside of the range, else returns `false`.
    static private func inRange(point:Float, pointLeading:Float, pointTrailing:Float) -> Bool {
        if pointTrailing > pointLeading {
            return (point >= pointTrailing && point <= 360.0) || ( point >= 0 && point <= pointLeading)
        } else {
            return (point >= pointTrailing && point <= pointLeading)
        }
    }
}
