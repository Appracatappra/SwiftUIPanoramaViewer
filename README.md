# SwiftUIPanoramaViewer

![](https://img.shields.io/badge/license-MIT-green) ![](https://img.shields.io/badge/maintained%3F-Yes-green) ![](https://img.shields.io/badge/swift-5.4-green) ![](https://img.shields.io/badge/iOS-17.0-red) ![](https://img.shields.io/badge/macOS-14.0-red) ![](https://img.shields.io/badge/tvOS-17.0-red) ![](https://img.shields.io/badge/dependency-LogManager-orange) ![](https://img.shields.io/badge/dependency-SoundManager-orange) ![](https://img.shields.io/badge/dependency-SwiftletUtilities-orange)

`SwiftUIPanoramaViewer` is a high-performance library that uses **SceneKit** to display complete spherical or cylindrical panoramas with touch, Gamepad or motion based controls that can be used in **SwiftUI** projects.

## Origin

`SwiftUIPanoramaViewer` is based off of the source code from **scihant's** [CTPanoramaView](https://github.com/scihant/CTPanoramaView), which has been heavily modified by me to support modern **OSes**, **SwiftUI**, reading **Pitch** & **Yaw**, support for **Gamepads** and many more features.

> **Why Make a New Library?** I released `SwiftUIPanoramaViewer` as a new library/package instead of making a pull request on `CTPanoramaView` for several reasons, but the main two are as follows: First, it looks like the `CTPanoramaView` is no longer being supported. Second, the SwiftUI changes that I've made take `CTPanoramaView` away from its original design of supporting `UIKit` and Objective-C.

As a result, you'll find both my MIT License included in the package, as well as, **scihant's** original MIT License from the `CTPanoramaView` open source library.

## Support

If you find `SwiftUIPanoramaViewer` useful and would like to help support its continued development and maintenance, please consider making a small donation, especially if you are using it in a commercial product:

<a href="https://www.buymeacoffee.com/KevinAtAppra" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

It's through the support of contributors like yourself, I can continue to build, release and maintain high-quality, well documented Swift Packages like `SwiftUIPanoramaViewer` for free.

## Installation

**Swift Package Manager** (Xcode 11 and above)

1. In Xcode, select the **File** > **Add Package Dependency…** menu item.
2. Paste `https://github.com/Appracatappra/SwiftUIPanoramaViewer.git` in the dialog box.
3. Follow the Xcode's instruction to complete the installation.

> Why not CocoaPods, or Carthage, or etc?

Supporting multiple dependency managers makes maintaining a library exponentially more complicated and time consuming.

Since, the **Swift Package Manager** is integrated with Xcode 11 (and greater), it's the easiest choice to support going further.

## Overview

`SwiftUIPanoramaViewer` provides a simply way to add an interactive spherical or cylindrical panorama viewer to any SwiftUI `View`. 


# Documentation

The **Package** includes full **DocC Documentation** for all of its features.
