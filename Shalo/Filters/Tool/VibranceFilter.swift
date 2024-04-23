import CoreImage
import Then

struct VibranceFilter: Filter {
    let name: String = "Concentration filter".localized()
    var vibrance: Double
    
    func apply(image: CIImage) -> CIImage {
        let filters = CIFilter(name: "CIVibrance")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(vibrance, forKey: kCIInputAmountKey)
        }
        
        return filters?.outputImage ?? image
    }
}
