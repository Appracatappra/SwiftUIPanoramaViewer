////
////  CTPanoramaView
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
//#if !os(tvOS)
//import CoreMotion
//
///// Extends `CMDeviceMotion`  for `CTPanoramaViewer`.
//public extension CMDeviceMotion {
//
//    // MARK: - Functions
//    /// Calculates an `SCNVector4` based on the device orientation.
//    /// - Returns: Returns a `SCNVector4`.
//    func orientation() -> SCNVector4 {
//
//        let attitude = self.attitude.quaternion
//        let attitudeQuanternion = GLKQuaternion(quanternion: attitude)
//
//        let result: SCNVector4
//
//        // From UIApplication.shared.statusBarOrientation
//        switch HardwareInformation.windowOrientation {
//
//        case .landscapeRight:
//            let cq1 = GLKQuaternionMakeWithAngleAndAxis(.pi/2, 0, 1, 0)
//            let cq2 = GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
//            var quanternionMultiplier = GLKQuaternionMultiply(cq1, attitudeQuanternion)
//            quanternionMultiplier = GLKQuaternionMultiply(cq2, quanternionMultiplier)
//
//            result = quanternionMultiplier.vector(for: .landscapeRight)
//
//        case .landscapeLeft:
//            let cq1 = GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 0, 1, 0)
//            let cq2 = GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
//            var quanternionMultiplier = GLKQuaternionMultiply(cq1, attitudeQuanternion)
//            quanternionMultiplier = GLKQuaternionMultiply(cq2, quanternionMultiplier)
//
//            result = quanternionMultiplier.vector(for: .landscapeLeft)
//
//        case .portraitUpsideDown:
//            let cq1 = GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
//            let cq2 = GLKQuaternionMakeWithAngleAndAxis(.pi, 0, 0, 1)
//            var quanternionMultiplier = GLKQuaternionMultiply(cq1, attitudeQuanternion)
//            quanternionMultiplier = GLKQuaternionMultiply(cq2, quanternionMultiplier)
//
//            result = quanternionMultiplier.vector(for: .portraitUpsideDown)
//
//        default:
//            let clockwiseQuanternion = GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
//            let quanternionMultiplier = GLKQuaternionMultiply(clockwiseQuanternion, attitudeQuanternion)
//
//            result = quanternionMultiplier.vector(for: .portrait)
//        }
//        return result
//    }
//}
//#endif
