import Foundation
import CoreImage

struct ProcessFilter: Filter {
    let name: String = "Processes".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIPhotoEffectProcess")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}

