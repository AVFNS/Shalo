//import Foundation
//import CoreImage
//
//struct SaturationFilter: Filter, Equatable {
//    let name: String = "Saturation Control"
//    
//    private var colorControlFilter = ColorControlFilter(
//        inputSaturation: 1.0,
//        inputBrightness: 0.0,
//        inputContrast: 1.0
//    )
//    
//    var inputSaturation: Double {
//        get {
//            colorControlFilter.inputSaturation
//        }
//        set {
//            colorControlFilter.inputSaturation = newValue
//        }
//    }
//    
//    func apply(image: CIImage) -> CIImage {
//        colorControlFilter.apply(image: image)
//    }
//}
