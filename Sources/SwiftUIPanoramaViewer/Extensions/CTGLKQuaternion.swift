//
//  CTPanoramaView
//  CTPanoramaView
//
//  Created by Cihan Tek on 11/10/16.
//  Copyright © 2016 Home. All rights reserved.
//
//  From: https://github.com/scihant/CTPanoramaView
//
//  Heavily modified by Kevin Mullins for Appracatappra, LLC. to support modern OSes, SwiftUI, reading pitch & yaw and support for Gamepads.
//  All modifications are released under the MIT License. See included License file for full details.

import UIKit
import SceneKit
import ImageIO
import SwiftUI
import SwiftletUtilities
import LogManager

#if !os(tvOS)
import CoreMotion

/// Extends `GLKQuaternion` for `CTPanoramaViewer`.
public extension GLKQuaternion {
   
    // MARK: - Initializers
    /// Creates a new instance.
    /// - Parameter quanternion: The `CMQuaternion` to initialize with.
    init(quanternion: CMQuaternion) {
        self.init(q: (Float(quanternion.x), Float(quanternion.y), Float(quanternion.z), Float(quanternion.w)))
    }
    
    /// Calculates a vector for the given orientation.
    /// - Parameter orientation: The current device `UIInterfaceOrientation`.
    /// - Returns: Returns a `SCNVector4` for the orientation.
    func vector(for orientation: UIInterfaceOrientation) -> SCNVector4 {
        switch orientation {
        case .landscapeRight:
            return SCNVector4(x: -self.y, y: self.x, z: self.z, w: self.w)

        case .landscapeLeft:
            return SCNVector4(x: self.y, y: -self.x, z: self.z, w: self.w)

        case .portraitUpsideDown:
            return SCNVector4(x: -self.x, y: -self.y, z: self.z, w: self.w)

        default:
            return SCNVector4(x: self.x, y: self.y, z: self.z, w: self.w)
        }
    }
    
}
#endif
