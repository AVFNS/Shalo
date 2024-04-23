import Foundation
import CoreImage
import Then

struct MonochromeFilter: Filter {
    let name: String = "Monochrome".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIColorMonochrome")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5), forKey: "inputColor")
            $0.setValue(1.0, forKey: "inputIntensity")
        }
        return filter?.outputImage ?? image
    }
}
