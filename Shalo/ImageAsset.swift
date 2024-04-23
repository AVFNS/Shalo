import Foundation
import UIKit

protocol ImageAssets: ImageRepresentable, RawRepresentable, CustomStringConvertible where RawValue == String { }

protocol ImageRepresentable {
    func image() -> UIImage
}

extension ImageAssets {
    func image() -> UIImage {
        return UIImage(named: rawValue, in: .main, with: nil) ?? UIImage()
    }
    
    var description: String {
        rawValue.description
    }
}

enum ImageAsset: String, ImageAssets, Equatable {
    case cancel
    case done
    case logo
}

extension ImageAsset {
    enum Tools: String, ImageAssets, Equatable {
        case exposure
        case highlights
        case vibrance
        case details
        case speed
        case tune
        case straighten
    }
}
