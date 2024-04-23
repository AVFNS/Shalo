import Foundation
import CoreImage
import Then

struct SepiaFilter: Filter {
    let name: String = "DarkBrown".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(
            name:"CISepiaTone",
            parameters: [
                kCIInputImageKey: image,
                kCIInputIntensityKey: 0.5
            ]
        )?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
