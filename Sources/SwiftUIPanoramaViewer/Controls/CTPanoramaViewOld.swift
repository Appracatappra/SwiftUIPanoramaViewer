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
//#endif
//
///// `CTPanoramaView` is a high-performance control that uses **SceneKit** to display complete spherical or cylindrical panoramas with touch or motion based controls that can be used in `UIKit` projects.
///// - Remark: When using in a SwiftUI `View` use the `PanoramaViewer` instead of calling `CTPanoramaView` directly
//@objc open class CTPanoramaView: UIView, UIGestureRecognizerDelegate {
//    // MARK: - Types
//    // Handler for user interaction that reports the `rotationAngle` and `fieldOfViewAngle`.
//    public typealias CTMovementHandler = (_ rotationAngle: CGFloat, _ fieldOfViewAngle: CGFloat) -> Void
//    
//    /// Handler for panorama rotation changes.
//    public typealias CTRotationHandler = (_ rotationKey: Int) -> Void
//    
//    /// Handler for the panorama camera changing rotation.
//    public typealias CTCameraMovedHandler = (_ pitch:Float, _ yaw:Float, _ roll:Float) -> Void
//
//    // MARK: Properties
//    /// An instance of a `CTPanoramaCompass` that is being controlled by the `CTPanoramaView`.
//    @available(*, deprecated, message: "The compass property is deprecated when using CTPanoramaView in a PanoramaView. Use a CompassView in your SwiftUI view instead.")
//    @objc public var compass: CTPanoramaCompass?
//    
//    /// Handle the user interacting with the `CTPanoramaView`.
//    @available(*, deprecated, message: "When working in SwiftUI, the movementHandler property is deprecated. Use cameraMoved instead.")
//    @objc public var movementHandler: CTMovementHandler?
//    
//    /// Handle the panorama rotating.
//    @available(*, deprecated, message: "When working in SwiftUI, the rotationHandler property is deprecated. Use cameraMoved instead.")
//    @objc public var rotationHandler: CTRotationHandler?
//    
//    /// Handles the panorama camera moving as a result of user interaction.
//    @objc public var cameraMoved: CTCameraMovedHandler?
//    
//    /// How fast should the panorama move in response to user interaction.
//    @objc public var panSpeed = CGPoint(x: 0.4, y: 0.4)
//    
//    /// The starting angle for the panorama view.
//    @objc public var startAngle: Float = 0
//    
//    /// The panorama angle of offset.
//    @objc public var angleOffset: Float = 0 {
//        didSet {
//            geometryNode?.rotation = SCNQuaternion(0, 1, 0, angleOffset)
//        }
//    }
//    
//    /// The minimum Field Of View Angle.
//    @objc public var minFoV: CGFloat = 40
//    
//    /// The maximum Field Of View Angle.
//    @objc public var maxFoV: CGFloat = 100
//    
//    /// The `UIImage` currently being displayed.
//    @objc public var image: UIImage? {
//        didSet {
//            panoramaType = panoramaTypeForCurrentImage
//        }
//    }
//    
//    /// A `UIview` that will be overlayed on the panorama view.
//    @objc public var overlayView: UIView? {
//        didSet {
//            replace(overlayView: oldValue, with: overlayView)
//        }
//    }
//    
//    /// The type of panorama image being displayed.
//    @objc public var panoramaType: CTPanoramaType = .cylindrical {
//        didSet {
//            createGeometryNode()
//            resetCameraAngles();
//        }
//    }
//    
//    /// The type of user interaction that is used to change the panorama view.
//    @objc public var controlMethod: CTPanoramaControlMethod = .touch {
//        didSet {
//            switchControlMethod(to: controlMethod)
//            resetCameraAngles();
//        }
//    }
//    
//    /// The background color for the viewer.
//    public override var backgroundColor: UIColor? {
//        didSet {
//            sceneView.backgroundColor = backgroundColor
//        }
//    }
//    
//    /// The pitch Eular Angle Converter.
//    private let pitchConverter = EularAngleConverter()
//    
//    /// The yaw Eular Angle Converter.
//    private let yawConverter = EularAngleConverter()
//    
//    /// The roll Eular Angle Converter.
//    private let rollConverter = EularAngleConverter()
//    
//    /// The maximum pan.
//    private let MaxPanGestureRotation: Float = GLKMathDegreesToRadians(360)
//    
//    /// The `SceneKit` projection sphere radius.
//    private let radius: CGFloat = 10
//    
//    /// The `SceneKit` view that the panorama is disolayed iin.
//    private let sceneView = SCNView()
//    
//    /// The `SceneKit` scene that is dislaying the panorama.
//    private let scene = SCNScene()
//    
//    /// The `SceneKit` geometry node.
//    private var geometryNode: SCNNode?
//    
//    /// The previous view location.
//    private var prevLocation = CGPoint.zero
//    
//    /// The previous panorama rotation.
//    private var prevRotation = CGFloat.zero
//    
//    /// The previous panorama view bounds.
//    private var prevBounds = CGRect.zero
//    
//    #if !os(tvOS)
//    /// The device motion manager.
//    private let motionManager = CMMotionManager()
//    #endif
//
//    /// The total amount of X movement.
//    private var totalX = Float.zero
//    
//    /// The total amount of Y movement.
//    private var totalY = Float.zero
//    
//    /// If `true` motion updates are paused.
//    private var motionPaused = false
//    
//    /// The starting zoom scale.
//    private var startScale: CGFloat = 0.0
//    
//    // MARK: - Pitch and Yaw accumulators.
//    /// The amount of Yaw change.
//    public var xDeltaTotal:CGFloat = 0.0
//    
//    /// The amount of Pitch change.
//    public var yDeltaTotal:CGFloat = 0.0
//    
//    /// Holds the current calculated Pitch.
//    public var pitch:Float = 0.0
//    
//    /// Holds the current calculated Yaw.
//    public var yaw:Float = 0.0
//
//    // MARK: - Computed Properties
//    /// The `SceneKit`camera node.
//    private lazy var cameraNode: SCNNode = {
//        let node = SCNNode()
//        let camera = SCNCamera()
//        node.camera = camera
//        return node
//    }()
//    
//    /// The `SceneKit` operation queue.
//    private lazy var opQueue: OperationQueue = {
//        let queue = OperationQueue()
//        queue.qualityOfService = .userInteractive
//        return queue
//    }()
//    
//    /// The field of vision height.
//    private lazy var fovHeight: CGFloat = {
//        return tan(self.yFov/2 * .pi / 180.0) * 2 * self.radius
//    }()
//    
//    /// The field of vision X coordinate.
//    private var xFov: CGFloat {
//        return yFov * self.bounds.width / self.bounds.height
//    }
//    
//    /// The field of vision Y coordinate.
//    private var yFov: CGFloat {
//        get {
//            if #available(iOS 11.0, *) {
//                return cameraNode.camera?.fieldOfView ?? 0
//            } else {
//                return CGFloat(cameraNode.camera?.yFov ?? 0)
//            }
//        }
//        set {
//            if #available(iOS 11.0, *) {
//                cameraNode.camera?.fieldOfView = newValue
//            } else {
//                cameraNode.camera?.yFov = Double(newValue)
//            }
//        }
//    }
//    
//    /// Automatically sets the panorama type when the image is changed.
//    /// - Remark: This currently always returns `.spherical` since the automatic setting was causing odd behavior.
//    private var panoramaTypeForCurrentImage: CTPanoramaType {
//        // KKM - Disabling for this specific game and always lock to spherical
//        //        if let image = image {
//        //            if image.size.width / image.size.height == 2 {
//        //                return .spherical
//        //            }
//        //        }
//        return .spherical
//    }
//
//    // MARK: - Initializers
//    /// Creates a new instance.
//    public init() {
//        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(HardwareInformation.screenWidth), height: CGFloat(HardwareInformation.screenHeight)))
//    }
//    
//    /// Creates a new instance.
//    /// - Parameter aDecoder: The `NSCoder` to build the view from.
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    /// Creates a new instance.
//    /// - Parameter frame: The frame to build the view in.
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//    /// Creates a new instance.
//    /// - Parameters:
//    ///   - frame: The frame to build the view in.
//    ///   - image: The `UIImage` to display in the viewer.
//    public convenience init(frame: CGRect, image: UIImage) {
//        self.init(frame: frame)
//        // Force Swift to call the property observer by calling the setter from a non-init context
//        ({ self.image = image })()
//    }
//    
//    /// Common operations that are performed during initialization.
//    private func commonInit() {
//        add(view: sceneView)
//
//        scene.rootNode.addChildNode(cameraNode)
//
//        sceneView.scene = scene
//        sceneView.backgroundColor = self.backgroundColor
//
//        switchControlMethod(to: controlMethod)
//     }
//    
//    // MARK: - Deinitializers
//    /// Handle the view being disposed of.
//    deinit {
//        #if !os(tvOS)
//        if motionManager.isDeviceMotionActive {
//            motionManager.stopDeviceMotionUpdates()
//        }
//        #endif
//    }
//
//    // MARK: - Functions
//    /// Resets the camera angle to the default position.
//    public func resetCameraAngles() {
//        if PanoramaManager.shouldResetCameraAngle {
//            yFov = maxFoV
//            cameraNode.eulerAngles = SCNVector3Make(0, startAngle, 0)
//            totalX = Float.zero
//            totalY = Float.zero
//            pitchConverter.reset()
//            yawConverter.reset()
//            rollConverter.reset()
//            pitch = 0.0
//            yaw = 0.0
//            self.reportMovement(CGFloat(startAngle), xFov.toRadians(), callHandler: false)
//        } else {
//            yFov = maxFoV
//            if let rotationHandler = rotationHandler {
//                rotationHandler(PanoramaManager.lastRotationKey)
//            }
//            self.reportCameraMovement()
//        }
//    }
//    
//    /// Creates the `SceneKit` geometry node to hold the panorama image.
//    private func createGeometryNode() {
//        guard let image = image else {return}
//
//        geometryNode?.removeFromParentNode()
//
//        let material = SCNMaterial()
//        material.diffuse.contents = image
//        material.diffuse.mipFilter = .nearest
//        material.diffuse.magnificationFilter = .nearest
//        material.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, 1, 1)
//        material.diffuse.wrapS = .repeat
//        material.cullMode = .front
//
//        if panoramaType == .spherical {
//            let sphere = SCNSphere(radius: radius)
//            sphere.segmentCount = 300
//            sphere.firstMaterial = material
//
//            let sphereNode = SCNNode()
//            sphereNode.geometry = sphere
//            geometryNode = sphereNode
//        } else {
//            let tube = SCNTube(innerRadius: radius, outerRadius: radius, height: fovHeight)
//            tube.heightSegmentCount = 50
//            tube.radialSegmentCount = 300
//            tube.firstMaterial = material
//
//            let tubeNode = SCNNode()
//            tubeNode.geometry = tube
//            geometryNode = tubeNode
//        }
//        geometryNode?.rotation = SCNQuaternion(0, 1, 0, angleOffset)
//        scene.rootNode.addChildNode(geometryNode!)
//    }
//    
//    /// Repalces the overlay view with a new overlay view.
//    /// - Parameters:
//    ///   - overlayView: The overlay to replace.
//    ///   - newOverlayView: The new overlay.
//    private func replace(overlayView: UIView?, with newOverlayView: UIView?) {
//        overlayView?.removeFromSuperview()
//        guard let newOverlayView = newOverlayView else {return}
//        add(view: newOverlayView)
//    }
//    
//    /// Starts providing motion updated to the caller.
//    private func startMotionUpdates(){
//
//        #if !os(tvOS)
//        guard motionManager.isDeviceMotionAvailable else {return}
//        motionManager.deviceMotionUpdateInterval = 0.015
//
//        motionPaused = false
//        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: opQueue,
//                                               withHandler: { [weak self] (motionData, error) in
//            guard let panoramaView = self else {return}
//            guard !panoramaView.motionPaused else {return}
//
//            guard (panoramaView.controlMethod == .motion || panoramaView.controlMethod == .both) else {return}
//
//            guard let motionData = motionData else {
//                Log.error(subsystem: "CTPanoramaView", category: "startMotionUpdates", "\(String(describing: error?.localizedDescription))")
//                panoramaView.motionManager.stopDeviceMotionUpdates()
//                return
//            }
//
//
//            Execute.onMain {
//                if panoramaView.panoramaType == .cylindrical {
//
//                    let rotationMatrix = motionData.attitude.rotationMatrix
//                    var userHeading = .pi - atan2(rotationMatrix.m32, rotationMatrix.m31)
//                    userHeading += .pi/2
//
//                    var startAngle = panoramaView.startAngle
//
//                    if (panoramaView.controlMethod == .both) {
//                        startAngle += panoramaView.totalY
//                    }
//                    // Prevent vertical movement in a cylindrical panorama
//                    panoramaView.cameraNode.eulerAngles = SCNVector3Make(0, startAngle + Float(-userHeading), 0)
//
//                } else {
//                    // Use quaternions when in spherical mode to prevent gimbal lock
//     
//                    var orientation = motionData.orientation()
//
//                    // Represent the orientation as a GLKQuaternion
//                    if(panoramaView.controlMethod == .both){
//
//                        // same code as pan rotation
//                        // but with our total accumulated
//                        // movements
//
//                        var glQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
//
//                        let xMultiplier = GLKQuaternionMakeWithAngleAndAxis(panoramaView.totalX, 1, 0, 0)
//                        glQuaternion = GLKQuaternionMultiply(glQuaternion, xMultiplier)
//
//                        let yMultiplier = GLKQuaternionMakeWithAngleAndAxis(panoramaView.totalY, 0, 1, 0)
//                        glQuaternion = GLKQuaternionMultiply(yMultiplier, glQuaternion)
//
//                        orientation = SCNQuaternion(x: glQuaternion.x, y: glQuaternion.y, z: glQuaternion.z, w: glQuaternion.w)
//
//                    }
//
//                    panoramaView.cameraNode.orientation = orientation
//
//                }
//
//                panoramaView.reportMovement(CGFloat(-panoramaView.cameraNode.eulerAngles.y), panoramaView.xFov.toRadians())
//            }
//        })
//        #endif
//    }
//    
//    /// Switch the method that users use to interact with the panorama viewer.
//    /// - Parameter method: The type of user control desired.
//    private func switchControlMethod(to method: CTPanoramaControlMethod) {
//        sceneView.gestureRecognizers?.removeAll()
//
//        if method == .touch {
//            let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panRec:)))
//            sceneView.addGestureRecognizer(panGestureRec)
//
//            #if !os(tvOS)
//            let pinchRec = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(pinchRec:)))
//            sceneView.addGestureRecognizer(pinchRec)
//
//            let rotateRec = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(rotRec:)))
//            sceneView.addGestureRecognizer(rotateRec)
//
//            pinchRec.delegate = self
//            rotateRec.delegate = self
//
//            if motionManager.isDeviceMotionActive {
//                motionManager.stopDeviceMotionUpdates()
//            }
//            #endif
//        }
//        else {
//            if method == .both {
//                let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panRec:)))
//                sceneView.addGestureRecognizer(panGestureRec)
//                
//                #if !os(tvOS)
//                let pinchRec = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(pinchRec:)))
//                sceneView.addGestureRecognizer(pinchRec)
//
//                let rotateRec = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(rotRec:)))
//                sceneView.addGestureRecognizer(rotateRec)
//
//                pinchRec.delegate = self
//                rotateRec.delegate = self
//                #endif
//            }
//
//            startMotionUpdates()
//
//        }
//    }
//    
//    /// Report panorama movement to the caller.
//    /// - Parameters:
//    ///   - rotationAngle: The rotation angle.
//    ///   - fieldOfViewAngle: The field of view angle.
//    ///   - callHandler: A callback handler to handle the rotation changing.
//    private func reportMovement(_ rotationAngle: CGFloat, _ fieldOfViewAngle: CGFloat, callHandler: Bool = true) {
//
//        // KKM - Since we are not using the embedded compass, we are commenting this code out.
//        compass?.updateUI(rotationAngle: rotationAngle, fieldOfViewAngle: fieldOfViewAngle)
//        if callHandler {
//            movementHandler?(rotationAngle, fieldOfViewAngle)
//        }
//        
//        if let rotationHandler = rotationHandler {
//            // HACK: Create a unique "key" value for rotation to key events off of.
//            let a = radiansToDegrees(Float(rotationAngle))
//            let b = radiansToDegrees(cameraNode.rotation.y * cameraNode.orientation.y)
//            //let resolution = Float(5.0)
//            let s = "\(Int(a * 0.50))\(Int(b * 0.70))"
//            let k = Int(s)!
//            rotationHandler(k)
//            PanoramaManager.lastRotationKey = k
//        }
//        
//        // Report camera movement to caller
//        reportCameraMovement()
//    }
//    
//    /// Report camera movement to the end user.
//    private func reportCameraMovement() {
//        if let cameraMoved = cameraMoved {
//            cameraMoved(round(pitch), round(yaw), 0.0)
//        }
//    }
//    
//    /// Convert radians to degrees.
//    /// - Parameter radians: The radians to convert.
//    /// - Returns: Returns the radian values converted to degrees.
//    private func radiansToDegrees(_ radians:Float) -> Float {
//        return fmodf(360.0 + radians * (180.0 / Float(Double.pi)), 360.0)
//    }
//    
//    // MARK: Gesture Handling
//    /// Handle the user panning the panorama view.
//    /// - Parameter panRec: The pan gesture recognizer.
//    @objc private func handlePan(panRec: UIPanGestureRecognizer) {
//        if panRec.state == .began {
//            prevLocation = CGPoint.zero
//
//        } else if panRec.state == .changed {
//
//            var modifiedPanSpeed = panSpeed
//
//            if (panoramaType == .cylindrical) {
//                modifiedPanSpeed.y = 0 // Prevent vertical movement in a cylindrical panorama
//            }
//
//            let orientation = cameraNode.orientation
//            let location = panRec.translation(in: sceneView)
//
//            let translationDelta = CGPoint(
//                x: (location.x - prevLocation.x) * modifiedPanSpeed.x,
//                y: (location.y - prevLocation.y) * modifiedPanSpeed.y
//            )
//            
//            // HACK: Use distance changes to simulate rotation about 360 degrees of freedom for pitch and yaw
//            // This hack is being used because reading the rotation directly from the camera was resulting in a weird drift.
//            // Calculate Pitch from current translation
//            let pitchTicks = 360 / self.bounds.size.height
//            yDeltaTotal += translationDelta.y
//            if yDeltaTotal > self.bounds.size.height {
//                yDeltaTotal -= self.bounds.size.height
//            } else if yDeltaTotal < 0 {
//                yDeltaTotal += self.bounds.size.height
//            }
//            pitch = Float(yDeltaTotal * pitchTicks)
//            
//            // Calculate Yaw from current translation
//            let yawTicks = 360 / self.bounds.size.width
//            xDeltaTotal += translationDelta.x
//            if xDeltaTotal > self.bounds.size.width {
//                xDeltaTotal -= self.bounds.size.width
//            } else if xDeltaTotal < 0 {
//                xDeltaTotal += self.bounds.size.width
//            }
//            yaw = Float(xDeltaTotal * yawTicks)
//
//            // Accumulate these if wheb using .both method so that we can apply the rotations
//            // to the sensor data and smoothly move with both touch and motion controls at the same time
//
//            // If both, just accumulate, our sensor callback will handle it
//            if (controlMethod == .both) {
//                
//                // Use the pan translation along the x axis to adjust the camera's rotation about the y axis (side to side navigation).
//                let yScalar = Float(translationDelta.x / self.bounds.size.width)
//                let yRadians = yScalar * MaxPanGestureRotation
//
//                let xScalar = Float(translationDelta.y / self.bounds.size.height)
//                let xRadians = xScalar * MaxPanGestureRotation
//
//                totalX += xRadians
//                totalY += yRadians
//            } else { // Otherwise, do the math here since we have no sensor
//                
//                // Use the pan translation along the x axis to adjust the camera's rotation about the y axis (side to side navigation).
//                let yScalar = Float(translationDelta.x / self.bounds.size.width)
//                let yRadians = yScalar * MaxPanGestureRotation
//
//                // Use the pan translation along the y axis to adjust the camera's rotation about the x axis (up and down navigation).
//                let xScalar = Float(translationDelta.y / self.bounds.size.height)
//                let xRadians = xScalar * MaxPanGestureRotation
//
//                // Represent the orientation as a GLKQuaternion
//                var glQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
//
//                // Perform up and down rotations around *CAMERA* X axis (note the order of multiplication)
//                let xMultiplier = GLKQuaternionMakeWithAngleAndAxis(xRadians, 1, 0, 0)
//                glQuaternion = GLKQuaternionMultiply(glQuaternion, xMultiplier)
//
//                // Perform side to side rotations around *WORLD* Y axis (note the order of multiplication, different from above)
//                let yMultiplier = GLKQuaternionMakeWithAngleAndAxis(yRadians, 0, 1, 0)
//                glQuaternion = GLKQuaternionMultiply(yMultiplier, glQuaternion)
//
//                cameraNode.orientation = SCNQuaternion(x: glQuaternion.x, y: glQuaternion.y, z: glQuaternion.z, w: glQuaternion.w)
//            }
//
//            prevLocation = location
//            reportMovement(CGFloat(-cameraNode.eulerAngles.y), xFov.toRadians())
//        }
//    }
//    
//    /// Handle the user panning the panorama view.
//    /// - Parameter location: The new location to move the panorama to.
//    @objc public func handlePan(location: CGPoint) {
//        var modifiedPanSpeed = panSpeed
//        
//        if (panoramaType == .cylindrical) {
//            modifiedPanSpeed.y = 0 // Prevent vertical movement in a cylindrical panorama
//        }
//        
//        let orientation = cameraNode.orientation
//        
//        let translationDelta = CGPoint(
//            x: (location.x) * modifiedPanSpeed.x,
//            y: (location.y) * modifiedPanSpeed.y
//        )
//        
//        // HACK: Use distance changes to simulate rotation about 360 degrees of freedom for pitch and yaw
//        // This hack is being used because reading the rotation directly from the camera was resulting in a weird drift.
//        // Calculate Pitch from current translation
//        let pitchTicks = 360 / self.bounds.size.height
//        yDeltaTotal += translationDelta.y
//        if yDeltaTotal > self.bounds.size.height {
//            yDeltaTotal -= self.bounds.size.height
//        } else if yDeltaTotal < 0 {
//            yDeltaTotal += self.bounds.size.height
//        }
//        pitch = Float(yDeltaTotal * pitchTicks)
//        
//        // Calculate Yaw from current translation
//        let yawTicks = 360 / self.bounds.size.width
//        xDeltaTotal += translationDelta.x
//        if xDeltaTotal > self.bounds.size.width {
//            xDeltaTotal -= self.bounds.size.width
//        } else if xDeltaTotal < 0 {
//            xDeltaTotal += self.bounds.size.width
//        }
//        yaw = Float(xDeltaTotal * yawTicks)
//        
//        // Accumulate these if wheb using .both method so that we can apply the rotations
//        // to the sensor data and smoothly move with both touch and motion controls at the same time
//        
//        // If both, just accumulate, our sensor callback will handle it
//        if (controlMethod == .both) {
//            
//            // Use the pan translation along the x axis to adjust the camera's rotation about the y axis (side to side navigation).
//            let yScalar = Float(translationDelta.x / self.bounds.size.width)
//            let yRadians = yScalar * MaxPanGestureRotation
//            
//            let xScalar = Float(translationDelta.y / self.bounds.size.height)
//            let xRadians = xScalar * MaxPanGestureRotation
//            
//            totalX += xRadians
//            totalY += yRadians
//        } else { // Otherwise, do the math here since we have no sensor
//            
//            // Use the pan translation along the x axis to adjust the camera's rotation about the y axis (side to side navigation).
//            let yScalar = Float(translationDelta.x / self.bounds.size.width)
//            let yRadians = yScalar * MaxPanGestureRotation
//            
//            // Use the pan translation along the y axis to adjust the camera's rotation about the x axis (up and down navigation).
//            let xScalar = Float(translationDelta.y / self.bounds.size.height)
//            let xRadians = xScalar * MaxPanGestureRotation
//            
//            // Represent the orientation as a GLKQuaternion
//            var glQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
//            
//            // Perform up and down rotations around *CAMERA* X axis (note the order of multiplication)
//            let xMultiplier = GLKQuaternionMakeWithAngleAndAxis(xRadians, 1, 0, 0)
//            glQuaternion = GLKQuaternionMultiply(glQuaternion, xMultiplier)
//            
//            // Perform side to side rotations around *WORLD* Y axis (note the order of multiplication, different from above)
//            let yMultiplier = GLKQuaternionMakeWithAngleAndAxis(yRadians, 0, 1, 0)
//            glQuaternion = GLKQuaternionMultiply(yMultiplier, glQuaternion)
//            
//            cameraNode.orientation = SCNQuaternion(x: glQuaternion.x, y: glQuaternion.y, z: glQuaternion.z, w: glQuaternion.w)
//        }
//        
//        prevLocation = CGPoint.zero
//        reportMovement(CGFloat(-cameraNode.eulerAngles.y), xFov.toRadians())
//    }
//
//    #if !os(tvOS)
//    /// Handle the user pinching to zoom the panorama view.
//    /// - Parameter pinchRec: The pinch gesture recognizer.
//    @objc func handlePinch(pinchRec: UIPinchGestureRecognizer) {
//        if pinchRec.numberOfTouches != 2 {
//            return
//        }
//
//        let zoom = CGFloat(pinchRec.scale)
//        switch pinchRec.state {
//        case .began:
//            if #available(iOS 11.0, *) {
//                startScale = cameraNode.camera!.fieldOfView
//            } else {
//                // Fallback on earlier versions
//                startScale = CGFloat(cameraNode.camera!.yFov)
//                
//            }
//        case .changed:
//            let fov = startScale / zoom
//            if fov > minFoV && fov <= maxFoV {
//                if #available(iOS 11.0, *) {
//                    cameraNode.camera!.fieldOfView = fov
//                } else {
//                    // Fallback on earlier versions
//                    cameraNode.camera!.yFov = Double(fov)
//                }
//            }
//        default:
//            break
//        }
//    }
//    
//    /// Handle the user rotating the device.
//    /// - Parameter rotRec: The rotation gesture handler.
//    @objc func handleRotate(rotRec: UIRotationGestureRecognizer) {
//
//        // no rotation for cylindrical
//        if panoramaType == .cylindrical{
//            return
//        }
//
//        if rotRec.state == .began {
//            prevRotation = CGFloat.zero
//
//            if (controlMethod == .both) {
//                motionPaused = true
//            }
//
//        } else if rotRec.state == .changed {
//
//            let orientation = cameraNode.orientation
//            let rotation = rotRec.rotation
//
//            let zRadians = rotation - prevRotation
//
//            // use a Quaternion instead of eluer angles
//            // so we can switch from sensor to finger rotation
//            // smoothly
//
//            var glQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
//
//            let zMultiplier = GLKQuaternionMakeWithAngleAndAxis(Float(zRadians), 0, 0, 1)
//            glQuaternion = GLKQuaternionMultiply(glQuaternion, zMultiplier)
//
//            cameraNode.orientation = SCNQuaternion(x: glQuaternion.x, y: glQuaternion.y, z: glQuaternion.z, w: glQuaternion.w)
//
//            prevRotation = rotation
//
//        }
//        else {
//            motionPaused = false
//        }
//    }
//    #endif
//    
//    /// Layout any subviews attached to this view.
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        if bounds.size.width != prevBounds.size.width || bounds.size.height != prevBounds.size.height {
//            sceneView.setNeedsDisplay()
//            reportMovement(CGFloat(-cameraNode.eulerAngles.y), xFov.toRadians(), callHandler: false)
//        }
//    }
//    
//    /// Checks to see if a given gesture recognizer is valid with this panorama viewer.
//    /// - Parameters:
//    ///   - gestureRecognizer: The gesture recognizer to check.
//    ///   - otherGestureRecognizer: A list of gesture recognizers already attached to the view.
//    /// - Returns: Returns `true` if the gesture is valid, else returns `false`.
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        // do not mix pan gestures with the others
//        if(gestureRecognizer is UIPanGestureRecognizer) || (otherGestureRecognizer is UIPanGestureRecognizer){
//            return false;
//        }
//        return true
//    }
//}
//
//
