import Foundation
import CoreImage
import Then

struct ColorInvertFilter: Filter {
    let name: String = "Contrast".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIColorInvert")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
