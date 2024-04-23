import Foundation
import AVFoundation
import Photos

struct VideoEditor {
    static func saveEditedVideo(filter: Filter, asset: AVAsset, completion: @escaping () -> Void) {
        exportSession(filter: filter, asset: asset)?
            .export { result in
                switch result {
                case let .success(url):
                    self.saveToPhotoLibrary(url, completion: completion)
                case .failure:
                    completion()
                }
            }
    }
    
    static func saveToPhotoLibrary(_ exportUrl: URL, completion: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportUrl)
        }) { saved, error in
            let title: String
            let body: String
            if saved && error == nil {
                title = "Saved successfully".localized()
                body = "Click to open it".localized()
            } else {
                title = "Could not save the video".localized()
                body = "Please try again".localized()
            }

            AppDelegate().scheduleNotification(title: title, body: body)
            completion()
        }
    }
    
    static func exportSession(
        filter: Filter,
        asset: AVAsset
    ) -> AVAssetExportSession? {
        guard let session = exportSession(asset: asset) else {
            return nil
        }
        session.videoComposition = setUpComposition(choosenFilter: filter, asset: asset)
        return session
    }
    
    static func trimSession(
        asset: AVAsset,
        startTime: Double,
        endTime: Double
    ) -> AVAssetExportSession? {
        guard let session = exportSession(asset: asset) else {
            return nil
        }
        session.timeRange = CMTimeRange(
            start: CMTime(seconds: startTime, preferredTimescale: 1000),
            end: CMTime(seconds: endTime, preferredTimescale: 1000)
        )
        return session
    }
    
    static var exportURL: URL {
        let exportPath = NSTemporaryDirectory().appendingFormat("/\(UUID().uuidString).mov")
        return URL(fileURLWithPath: exportPath)
    }
    
    static func exportSession(asset: AVAsset) -> AVAssetExportSession? {
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        session?.outputFileType = AVFileType.mov
        session?.outputURL = exportURL
        return session
    }
    
    private static func setUpComposition(choosenFilter: Filter, asset: AVAsset ) -> AVVideoComposition {
        AVVideoComposition(asset: asset) { request in
            let filteredImage = choosenFilter.apply(image: request.sourceImage)
            request.finish(with: filteredImage, context: nil)
        }
    }
}

extension AVAssetExportSession {
    enum `Error`: Swift.Error {
        case cancelled
        case failed(Swift.Error)
        case unknown
    }
    
    func export(completion: @escaping (Result<URL, Error>) -> Void) {
        exportAsynchronously { [weak self] in
            guard let self = self else {
                completion(.failure(.cancelled))
                return
            }
            
            switch (self.status, self.outputURL, self.error) {
            case let (.completed, .some(url), .none):
                completion(.success(url))
                
            case (.cancelled, _, _):
                completion(.failure(.cancelled))
                
            case let (.failed, _, .some(error)):
                completion(.failure(.failed(error)))
                
            default:
                completion(.failure(.unknown))
            }
        }
    }
}
