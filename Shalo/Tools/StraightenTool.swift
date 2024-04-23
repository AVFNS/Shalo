import Foundation
import UIKit
import CoreImage

struct StraightenTool: Tool {
    static func == (lhs: StraightenTool, rhs: StraightenTool) -> Bool {
      lhs.icon == rhs.icon
    }
  
    let icon = ImageAsset.Tools.straighten
    let name = "Slope".localized()
    
    private(set) var filter = StraightenFilter(angle: 0)
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}
extension StraightenTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .angle:
            return filter.angle * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .angle:
            filter.angle = value / parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .angle:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .angle:
            return 1.0 * parameter.k
        }
    }
}

extension StraightenTool {
    enum Parameter: String, CaseIterable {
        case angle
        
        var k: Double {
            switch self {
            case .angle:
                return 100.0
            }
        }
    }
}

extension StraightenTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension StraightenTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
