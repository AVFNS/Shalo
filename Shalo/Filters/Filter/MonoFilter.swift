import Foundation
import CoreImage
import Then

struct MonoFilter: Filter {
    let name: String = "Solid".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIPhotoEffectMono")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
