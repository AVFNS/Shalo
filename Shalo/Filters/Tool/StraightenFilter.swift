import CoreImage
import Then

struct StraightenFilter: Filter {
    let name: String = "스트레이트"
    var angle: Double
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIStraightenFilter")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(angle, forKey: kCIInputAngleKey)
        }
        
        return filter?.outputImage ?? image
    }
}

