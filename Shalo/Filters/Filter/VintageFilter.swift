import Foundation
import CoreImage
import Then

struct VintageFilter: Filter {
    let name: String = "Vintage".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIPhotoEffectInstant")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
