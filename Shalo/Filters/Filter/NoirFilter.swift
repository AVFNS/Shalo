import Foundation
import CoreImage
import Then

struct NoirFilter: Filter {
    let name: String = "느와르".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIPhotoEffectNoir")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
