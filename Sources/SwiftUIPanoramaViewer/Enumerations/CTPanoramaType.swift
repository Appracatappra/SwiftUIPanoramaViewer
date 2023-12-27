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

/// Defines the type of panorama being displayed.
@objc public enum CTPanoramaType: Int {
    /// The panorama image is a cylinder.
    case cylindrical
    
    /// The panorama image is a sphere.
    case spherical
}
