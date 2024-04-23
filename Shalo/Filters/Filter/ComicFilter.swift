import Foundation
import CoreImage
import Then

struct ComicFilter: Filter {
    let name: String = "Comic".localized()
    
    func apply(image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIComicEffect")?.then {
            $0.setValue(image, forKey: kCIInputImageKey)
        }
        return filter?.outputImage ?? image
    }
}
