import Foundation
import CoreImage
import Then

struct SharpAndWarmFilter: Filter {
    let name: String = "Warm".localized()
    let inputSharpness: Double
    
    init(inputSharpness: Double) {
        self.inputSharpness = inputSharpness
    }
    
    func apply(image: CIImage) -> CIImage {
        let optionalSharpFilter = CIFilter(name: "CISharpenLuminance")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(inputSharpness, forKey:kCIInputSharpnessKey)
        }

        guard let sharpImage = optionalSharpFilter?.outputImage else {
            return image
        }
        
        let optionalBrightFilter = CIFilter(name: "CIColorControls")?.then {
            $0.setValue(sharpImage, forKey: kCIInputImageKey)
            $0.setValue(1.25, forKey: kCIInputContrastKey)
        }
        
        guard let brightAndSharpImage = optionalBrightFilter?.outputImage else {
            return image
        }
        
        let optionalTempFilter = CIFilter(name: "CITemperatureAndTint")?.then {
            $0.setValue(brightAndSharpImage, forKey: kCIInputImageKey)
            $0.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
            $0.setValue(CIVector(x: 4000, y: 0), forKey: "inputTargetNeutral")
        }

        return optionalTempFilter?.outputImage ?? image
    }
}


