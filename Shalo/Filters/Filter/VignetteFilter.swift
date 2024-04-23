import Foundation
import CoreImage

struct VignetteFilter: Filter {
    let name: String = "Vignette".localized()
    var radius: Double = 2
    var intensity: Double = 1
    
    private let filter = CIFilter(name: "CIVignette", parameters: nil)!
    
    func parameters(with image: CIImage) -> [String : Any] {
        [
            kCIInputImageKey:  image,
            kCIInputRadiusKey : NSNumber(floatLiteral: radius),
            kCIInputIntensityKey : NSNumber(floatLiteral: intensity),
        ]
    }
    
    func apply(image: CIImage) -> CIImage {
        filter.createOutputImage(for: parameters(with: image)) ?? image
    }
}

extension CIFilter {
    func createOutputImage(for parameters: [String : Any]) -> CIImage? {
        setValuesForKeys(parameters)
        return outputImage
    }
}
