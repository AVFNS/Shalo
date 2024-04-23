import CoreImage
import Then

struct ExposureFilter: Filter {
    let name: String = "Exposure".localized()
    var exposure: Double
    
    init(exposure: Double) {
        self.exposure = exposure
    }
    
    func apply(image: CIImage) -> CIImage {
        let filters = CIFilter(name: "CIExposureAdjust")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(exposure, forKey: kCIInputEVKey)
        }
        return filters?.outputImage ?? image
    }
}
