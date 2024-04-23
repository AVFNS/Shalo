import Foundation
import CoreImage

struct LightTool: Tool {
    let icon = ImageAsset.Tools.tune
    let name = "Light".localized()
    
    private(set) var filter = LightFilter()
    
    func apply(image: CIImage) -> CIImage {
        filter.apply(image: image)
    }
}

extension LightTool: Parameterized {
    var allParameters: [Parameter] { Parameter.allCases }
    
    func value(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return Double(filter.inputBrightness) * parameter.k
        }
    }
    
    func minValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return -1.0 * parameter.k
        }
    }
    
    func maxValue(for parameter: Parameter) -> Double {
        switch parameter {
        case .brightness:
            return 1.0 * parameter.k
        }
    }
    
    mutating func setValue(value: Double, for parameter: Parameter) {
        switch parameter {
        case .brightness:
            filter.inputBrightness = value / parameter.k
        }
    }
}

extension LightTool {
    enum Parameter: String, CaseIterable {
        case brightness
        
        var k: Double {
            switch self {
            case .brightness:
                return 100.0
            }
        }
    }
}

extension LightTool.Parameter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension LightTool.Parameter: ExpressibleByString {
    init?(string: String) {
        self.init(rawValue: string.lowercased())
    }
}
