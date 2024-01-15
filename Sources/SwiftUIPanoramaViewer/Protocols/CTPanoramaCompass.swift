////
////  CTPanoramaCompass
////  CTPanoramaView
////
////  Created by Cihan Tek on 11/10/16.
////  Copyright © 2016 Home. All rights reserved.
////
////  From: https://github.com/scihant/CTPanoramaView
////
////  Heavily modified by Kevin Mullins for Appracatappra, LLC. to support modern OSes, SwiftUI, reading pitch & yaw and support for Gamepads.
////  All modifications are released under the MIT License. See included License file for full details.
//
//import UIKit
//import SceneKit
//import ImageIO
//import SwiftUI
//import SwiftletUtilities
//import LogManager
//
///// The `CTPanoramaCompass` is used to tie a `CTPieSliceView` to a `CTPanoramaView` for automatic rotation when the Panorama rotates.
///// - Remark: This protocol is deprecated when using the panorama viewer in a SwiftUI app.
//@available(*, deprecated, message: "This protocol is deprecated when using the panorama viewer in a SwiftUI app. Use a CompassView in your app directly instead.")
//@objc public protocol CTPanoramaCompass {
//    
//    // MARK: - Functions
//    /// Called when the panorama view is rotated.
//    /// - Parameters:
//    ///   - rotationAngle: The new rotation angle.
//    ///   - fieldOfViewAngle: The new field of view angle.
//    func updateUI(rotationAngle: CGFloat, fieldOfViewAngle: CGFloat)
//}
