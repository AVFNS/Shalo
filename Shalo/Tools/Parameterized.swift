import Foundation

protocol ExpressibleByString {
    init?(string: String)
}

protocol Parameterized {
    associatedtype Parameter: CustomStringConvertible & ExpressibleByString
    
    var allParameters: [Parameter] { get }
    
    func value(for parameter: Parameter) -> Double
    
    func minValue(for parameter: Parameter) -> Double
    
    func maxValue(for parameter: Parameter) -> Double
    
    mutating func setValue(value: Double, for parameter: Parameter)
}
