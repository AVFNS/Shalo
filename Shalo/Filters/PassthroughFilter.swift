import Foundation
import CoreImage

struct PassthroughFilter: Filter {
    let name: String = "Original".localized()
    
    func apply(image: CIImage) -> CIImage { image }
}
