import Foundation
import UIKit
import CoreImage

protocol Tool: CustomStringConvertible, Equatable, Parameterized {
    associatedtype Icon: ImageAssets
    associatedtype F: Filter
    
    var filter: F { get }
    var icon: Icon { get }
    var name: String { get }
    
    func apply(image: CIImage) -> CIImage
}

extension Tool {
    var description: String { name }
}

enum ToolEnum: Equatable {
    case colourCorrection(tool: LightTool)
    case exposureTool(tool: ExposureTool)
    case highlightShadowTool(tool: HighlightShadowTool)
    case vibranceTool(tool: VibranceTool)
    case straightenTool(tool: StraightenTool)
    case speed
    
    var name: String {
        switch self {
        case let .colourCorrection(tool):
            return tool.name
        case let .exposureTool(tool):
            return tool.name
        case let .highlightShadowTool(tool):
            return tool.name
        case let .vibranceTool(tool):
            return tool.name
        case let .straightenTool(tool):
            return tool.name
        case .speed:
            return "속도"
        }
    }
    
    var icon: UIImage {
        switch self {
        case let .colourCorrection(tool):
            return tool.icon.image()
        case let .exposureTool(tool):
            return tool.icon.image()
        case let .highlightShadowTool(tool):
            return tool.icon.image()
        case let .vibranceTool(tool):
            return tool.icon.image()
        case let .straightenTool(tool):
            return tool.icon.image()
        case .speed:
            return ImageAsset.Tools.speed.image()
        }
    }
}
