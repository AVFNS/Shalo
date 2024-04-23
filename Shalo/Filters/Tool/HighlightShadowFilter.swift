import Foundation
import CoreImage
import Then

struct HighlightShadowFilter: Filter {
    let name: String = "그림자 강조"
    var highlight: Double
    var shadow: Double
    var radius: Double
    
    func apply(image: CIImage) -> CIImage {
        let filters = CIFilter(name: "CIHighlightShadowAdjust")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
            $0.setValue(highlight, forKey: "inputHighlightAmount")
            $0.setValue(shadow, forKey: "inputShadowAmount")
            $0.setValue(radius, forKey: kCIInputRadiusKey)
          
        }
        return filters?.outputImage ?? image
    }
}

