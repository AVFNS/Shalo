import AVFoundation
import UIKit

extension AVAsset {
    var videoTransform: CGAffineTransform {
        let videoTrack = self.tracks(withMediaType: .video)[0]
        return videoTrack.preferredTransform
    }
    
    var videoOrientation: CGImagePropertyOrientation {
        switch (videoTransform.a, videoTransform.b, videoTransform.c, videoTransform.d) {
        case ( 0.0,  1.0, -1.0,  0.0): return .right
        case ( 0.0, -1.0,  1.0,  0.0): return .left
        case (-1.0,  0.0,  0.0, -1.0): return .down
        case ( 1.0,  0.0,  0.0,  1.0): return .up
        default: return .right
        }
    }
    
    var isPortrait: Bool {
        return videoOrientation == .up || videoOrientation == .down
    }
}

extension AVAsset {
    func adjustedSpeed(mode: SpeedMode) -> AVMutableComposition? {
        guard let videoTrack = tracks(withMediaType: AVMediaType.video).first else {
            return nil
        }
        let mixComposition = AVMutableComposition()
        guard let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        
        let scaledVideoDuration = getScaledVideoDuration(mode: mode)
        let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)
        
        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        
        if let audioTrack = tracks(withMediaType: .audio).first,
           let compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
            do {
                try compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: CMTime.zero)
                compositionAudioTrack.scaleTimeRange(timeRange, toDuration: scaledVideoDuration)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return mixComposition
    }
    
    func getScaledVideoDuration(mode: SpeedMode) -> CMTime {
        let videoDuration: Int64
        switch mode {
        case let .slowDown(scale):
            videoDuration = duration.value * scale
        case let .speedUp(scale):
            videoDuration = duration.value / scale
        }
        return CMTimeMake(value: videoDuration, timescale: duration.timescale)
    }
}
