import Foundation
import CoreImage
import Then

struct RetroFilter: Filter {
    let name: String = "Retro".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIPhotoEffectTransfer")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
