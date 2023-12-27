//
//  EularAngleConverter.swift
//  SwiftUIPanoramaViewer Package
//
//  Created by Kevin Mullins on 3/31/22.
//

import Foundation

// Handles turning a SceneKit camera's eular angles into a 360 degree rotation offset.
open class EularAngleConverter {
    
    // MARK: - Enumerations
    /// The quadrant that the angle represents.
    public enum Quadrant {
        /// The top left quadrant.
        case topLeft
        
        /// The top right quadrant.
        case topRight
        
        /// The bottom left quadrant.
        case bottomLeft
        
        /// The bottom right quadrant.
        case bottomRight
    }
    
    // MARK: - Properties
    /// The quadrant being converted.
    private var quad:Quadrant = .topLeft
    
    /// The last angle of conversion.
    private var lastAngle:Float = 0.0
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - quad: The quadrant being converted.
    ///   - lastAngle: The last angle of conversion.
    public init(quad: Quadrant, lastAngle: Float) {
        self.quad = quad
        self.lastAngle = lastAngle
    }
    
    // MARK: - Functions
    /// Resets the converter.
    public func reset() {
        quad = .topLeft
        lastAngle = 0.0
    }
    
    /// Calculates the degress from the given eular angles.
    /// - Parameter angle: The angle to be converted.
    /// - Returns: Returns the eular angle in degrees.
    public func eularToDegrees(_ angle:Float) -> Float {
        // Calculate the initial angle which will fall into two chunks (0...90) & (90...180)
        // with two "magic" numbers 90 and -90.
        let rawAngle = (angle * 180.0) / Float(Double.pi)
        let angleRounded = round(rawAngle)
        var degrees = angleRounded
        
        // If less than zero adjust the number to be positive.
        if degrees < 0.0 {
            degrees += 180.0
        }
        
        // Generate the initial output angle.
        var outputAngle: Float = 0.0
        
        // Handle debouncing the rotation.
        if angleRounded != lastAngle {
            // Handle the debounced angle changing.
            if angleRounded == 90.0 {
                // Handle swinging past the top and bottom sides of the sphere.
                if quad == .topRight {
                    quad = .bottomRight
                } else if quad == .bottomRight {
                    quad = .topRight
                }
                
                // Adjust the right side magic number.
                outputAngle = 270
            } else if angleRounded == -90.0 {
                // Handle swinging past the top and bottom sides of the sphere.
                if quad == .topLeft {
                    quad = .bottomLeft
                } else if quad == .bottomLeft {
                    quad = .topLeft
                }
                
                // Adjust the left side magic number.
                outputAngle = 90
            } else if degrees >= 0 && degrees <= 89 {
                // Handle being on the left side of the sphere and the possibility of swinging from the left to the right side.
                switch quad {
                case .topLeft:
                    outputAngle = degrees
                case .topRight:
                    quad = .topLeft
                case .bottomLeft:
                    outputAngle = 180 - degrees
                case .bottomRight:
                    quad = .bottomLeft
                }
            } else if degrees >= 89 && degrees <= 180 {
                // Handle being on the right side of the sphere and the possibility of swinging from the left to the right side.
                switch quad {
                case .topLeft:
                    quad = .topRight
                case .topRight:
                    outputAngle = 175 + degrees
                case .bottomLeft:
                    quad = .bottomRight
                case .bottomRight:
                    outputAngle = 360 - degrees
                }
            }
        } else {
            // Handle non debounced values.
            if angleRounded == 90 {
                // Adjust the right side magic number.
                outputAngle = 270
            } else if angleRounded == -90 {
                // Adjust the left side magic number.
                outputAngle = 90
            } else if degrees >= 0 && degrees <= 89 {
                // Handle being on the left side of the sphere.
                if quad == .bottomLeft {
                    outputAngle = 180 - degrees
                } else {
                    outputAngle = degrees
                }
            } else if degrees >= 89 && degrees <= 180 {
                // Handle being on the right side of the sphere.
                if quad == .bottomRight {
                    outputAngle = 360 - degrees
                } else {
                    outputAngle = 175 + degrees
                }
            }
        }
        
        // Save the last angle.
        lastAngle = angleRounded
        
        // Return the computed degrees of rotation.
        return outputAngle
    }
}
