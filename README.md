# SwiftUIPanoramaViewer

![](https://img.shields.io/badge/license-MIT-green) ![](https://img.shields.io/badge/maintained%3F-Yes-green) ![](https://img.shields.io/badge/swift-6.0-green) ![](https://img.shields.io/badge/iOS-18.0-red) ![](https://img.shields.io/badge/macOS-15.0-red) ![](https://img.shields.io/badge/tvOS-18.0-red) ![](https://img.shields.io/badge/dependency-LogManager-orange) ![](https://img.shields.io/badge/dependency-SoundManager-orange) ![](https://img.shields.io/badge/dependency-SwiftletUtilities-orange)

`SwiftUIPanoramaViewer` is a high-performance library that uses **SceneKit** to display complete spherical or cylindrical panoramas with touch, Gamepad or motion based controls that can be used in **SwiftUI** projects.

## Origin

`SwiftUIPanoramaViewer` is based off of the source code from **scihant's** [CTPanoramaView](https://github.com/scihant/CTPanoramaView) open source library, which has been heavily modified by me to support modern **OSes**, **SwiftUI**, reading **Pitch** & **Yaw**, support for **Gamepads** and many more features.

> **Why Make a New Library?** I released `SwiftUIPanoramaViewer` as a new library/package instead of making a pull request on `CTPanoramaView` for several reasons, but the main two are as follows: First, it looks like the `CTPanoramaView` is no longer being supported. Second, the SwiftUI changes that I've made take `CTPanoramaView` away from its original design of supporting `UIKit` and Objective-C.

As a result, you'll find both my MIT License included in the package, as well as, **scihant's** original MIT License from the `CTPanoramaView` open source library.

## Support

If you find `SwiftUIPanoramaViewer` useful and would like to help support its continued development and maintenance, please consider making a small donation, especially if you are using it in a commercial product:

<a href="https://www.buymeacoffee.com/KevinAtAppra" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

It's through the support of contributors like yourself, I can continue to build, release and maintain high-quality, well documented Swift Packages like `SwiftUIPanoramaViewer` for free.

## Installation

**Swift Package Manager** using Xcode:

1. In Xcode, select the **File** > **Add Package Dependency…** menu item.
2. Paste `https://github.com/Appracatappra/SwiftUIPanoramaViewer.git` in the dialog box.
3. Follow the Xcode's instruction to complete the installation.

> Why not CocoaPods, or Carthage, or etc?

Supporting multiple dependency managers makes maintaining a library exponentially more complicated and time consuming.

Since, the **Swift Package Manager** is integrated with Xcode, it's the easiest choice to support going further.

## Overview

`SwiftUIPanoramaViewer` provides a simply way to add an interactive spherical or cylindrical panorama viewer to any SwiftUI `View`. Let's look at the following example:

```swift
@State var rotationIndicator:Float = 0.0
...

ZStack {
	// Display the panorama
	PanoramaViewer(image: SwiftUIPanoramaViewer.bindImage("PanoramaImageName")) {key in }
	cameraMoved: { pitch, yaw, roll in
	    rotationIndicator = yaw
	}

	VStack {
		Spacer()
	
		CompassView()
	   .frame(width: 50.0, height: 50.0)
	   .rotationEffect(Angle(degrees: Double(rotationIndicator)))
	}
}
// If using `SwiftUIGamepad` package, allow the gamepad to rotate the view.
.onGamepadLeftThumbstick(viewID: viewID) { xAxis, yAxis in
    PanoramaManager.moveCamera(xAxis: xAxis, yAxis: yAxis)
}
```

Let's break down the key points:

* `rotationIndicator` - We created a **State** variable to track changes in the panorama's rotation.
* `PanoramaViewer` - This displays the panorama with the default user interaction of touch on mobile devices.
* `SwiftUIPanoramaViewer.bindImage("PanoramaImageName")` - The helper function `SwiftUIPanoramaViewer.bindImage` returns a bound `UIImage` of the given name. This image should either be a spherical or cylindrical panorama held in the app's asset catalog or downloaded via **On Demand Resources**.
* `cameraMoved` - The `cameraMoved` event is called when the user interacts with the panorama moving the view. Here we are storing the **yaw** (or X Axis movement) in the `rotationIndicator` variable to update the compass.
* `CompassView()` - Displays a compass overlay at the bottom of the panorama indicating the direct the user is looking.
* `rotationEffect` - We are using `rotationEffect` on the `CompassView` along with the `rotationIndicator` variable to point the compass in the direction that the user is "looking" in the panorama.

If you want to store your panorama images in **On Demand Resources**, please see our [ODRManager Package](https://github.com/Appracatappra/ODRManager) to help make working with ODR easier.

> In its current implementation, only one `PanoramaViewer` can be active in your app at one time. You can use the `PanoramaManager` singleton class to communicate with the currently active viewer.

### Adding Gamepad Support

By including our [SwiftUIGamepad Package](https://github.com/Appracatappra/SwiftUIGamepad) in your SwiftUI app, it's easy to add gamepad support to the `PanoramaViewer`. The following lines of code allow the left thumbstick of an attached gamepad to move the panorama view:

```swift
// If using `SwiftUIGamepad` package, allow the gamepad to rotate the view.
.onGamepadLeftThumbstick(viewID: viewID) { xAxis, yAxis in
    PanoramaManager.moveCamera(xAxis: xAxis, yAxis: yAxis)
}
```

Use `PanoramaManager.moveCamera` to communicate the amount of change in the `xAxis` (or yaw) and `yAxis` (or pitch) in the panorama's view. The `cameraMoved` event will be raised on the `PanoramaViewer` is response to this change.

> There is more setup required to use `SwiftUIGamepad` in a SwiftUI `View` than is shown here. Only the `SwiftUIPanoramaViewer` specific parts are shown for brevity. Please see the `SwiftUIGamepad` DocC documentation for the full setup required.

### Displaying View Markers and Interaction Points

By creating your own storage class and noting specific `pitch` and `yaw` points in a given panorama image, you can create **Indicators** or **Interaction Points** that can be displayed in response to `cameraMoved` events.

If the `pitch` and `yaw` points returned to the `cameraMoved` events match specific points in your structure, simply display an **Icon** or **Button** overlaying the `PanoramaViewer` using a `ZStack`.

The `PanoramaManager` singleton class provides several helper function to assist in this task:

* `leadingTarget` - Calculates the **Top Left** corner of a given hit target (yaw, pitch).
* `trailingTarget` - Calculates the **Bottom Right** corner of a given hit target (yaw, pitch).
* `targetHit` - Given the current `pitch` and `yaw` from the `PanoramaViewer` check to see if it is within the given target point.
* `inRange` - Tests the given rotational point to see if it is inside of the specified range.

> Because of all the different ways that the `PanoramaViewer` can be used in a SwiftUI app, providing all of the data structures to support interaction and node navigation was out of the scope of this library. Any "default" implementation could either be too limiting or too complex for any given apps needs.
> 
> As a result, I've decided to provide the tools to easily implement this functionality, while leaving the specifics up the the consuming app's code.

### Changing the Panorama Image on User Interaction

If you need to change the panorama image that is being displayed in the `PanoramaViewer` due to user interaction (or any other in app event), there are a few extra steps that will need to be taken. See the following code snipit:

```swift
@State var panoImage:String = "MyImage"
...

PanoramaViewer(image: SwiftUIPanoramaViewer.bindImage(panoImage))
...

// Change the displayed image
PanoramaManager.shouldUpdateImage = true
PanoramaManager.shouldResetCameraAngle = false
panoImage = "newPanoImage"

```

In this code we are using **State** variable `panoImage` to hold the current panorama image being displayed. Here are the key points:

* `PanoramaManager.shouldUpdateImage` - By setting this property to `true` you are informing the `PanoramaViewer` that it needs to look for an upcoming image change. This allows the viewer to do the necessary housekeeping to insure the image changes smoothly without unwanted flickering in the UI.
* `PanoramaManager.shouldResetCameraAngle` - By setting this property to `false` we are telling the `PanoramaViewer` to maintain the current `pitch` and `yaw` when the image changes. If this property is `true` both `pitch` and `yaw` will be reset to zero (0) when the image changes.
* `panoImage` - When we specify a new image, the `PanoramaViewer` will make the change and reset the `PanoramaManager.shouldUpdateImage` property to `false`.

> The request to change the panorama image displayed in the `PanoramaViewer` should be executed on the main thread for best results.

# Documentation

The **Package** includes full **DocC Documentation** for all of its features.
