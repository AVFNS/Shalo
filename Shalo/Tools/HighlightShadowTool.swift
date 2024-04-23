import Foundation
import UIKit
import CoreImage

struct HighlightShadowTool: Tool {
    static func == (lhs: HighlightShadowTool, rhs: HighlightShadowTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.highlights
    let name = "ToneContrast".localized()
    
    private(set) var filter = HighlightShadowFilter(highlight: 1, shadow: 0, radius: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension HighlightShadowTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .highlight:
            return filter.highlight * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .highlight:
            filter.highlight = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .highlight:
            return 0.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .highlight:
            return 1.0 * parameter.k
        }
    }
}

extension HighlightShadowTool {
    enum Parameter: String, CaseIterable {
        case highlight
        
        var k: Double {
            switch self {
            case .highlight:
                return 100.0
            }
        }
    }
}

extension HighlightShadowTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension HighlightShadowTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
