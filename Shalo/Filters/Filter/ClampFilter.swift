import Foundation
import CoreImage
import Then

struct ClampFilter: Filter {
    let name: String = "Clamp".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIColorClamp")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(CIVector(x: 0.1, y: 0.0, z: 0.1, w: 0), forKey: "inputMinComponents")
            $0.setValue(CIVector(x: 0.8, y: 0.8, z: 0.8, w: 0.8), forKey: "inputMaxComponents")
        }
        return filter?.outputImage ?? image
    }
}
