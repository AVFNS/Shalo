import AVFoundation
import UIKit
import Then

struct AssetImageGenerator {
    static func getThumbnailImageFromVideoAsset(
        asset: AVAsset,
        maximumSize: CGSize = .zero,
        queue: DispatchQueue = .global(),
        completion: @escaping (UIImage?) -> Void
    ) {
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset).then {
            $0.maximumSize = maximumSize
            $0.appliesPreferredTrackTransform = true
            $0.requestedTimeToleranceBefore = .indefinite
        }
        
        queue.async {
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                completion(thumbImage)
            } catch {
                completion(nil)
            }
        }
    }
}
