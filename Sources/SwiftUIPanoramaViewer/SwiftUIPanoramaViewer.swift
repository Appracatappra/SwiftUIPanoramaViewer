// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import SwiftletUtilities

/// `SwiftUIPanoramaViewer` is a helper class for working with `PanoramaViewers`.
public class SwiftUIPanoramaViewer {
    
    // MARK: - Static Functions
    /// Creates a binding around a `UIImage` for use in a `PanoramaViewer`.
    /// - Parameter name: The name of the image to load.
    /// - Returns: Returns a bound `UIImage`.
    public static func bindImage(_ name:String) -> Binding<UIImage?> {
      return .init(
        get: { UIImage(named: name) },
        set: { let _ = $0 }
      )
    }
    
    /// Creates a binding around a `UIImage` for use in a `PanoramaViewer`.
    /// - Parameter image: The `UIImage`to bind.
    /// - Returns: Returns a bound `UIImage`.
    public static func bindImage(_ image:UIImage?) -> Binding<UIImage?> {
      return .init(
        get: { image },
        set: { let _ = $0 }
      )
    }
}
