import Foundation
import CoreImage

struct HalfToneFilter: Filter {
    let name: String = "HalfToned".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CICMYKHalftone")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(25, forKey: kCIInputWidthKey)
        }
        return filter?.outputImage ?? image
    }
}
