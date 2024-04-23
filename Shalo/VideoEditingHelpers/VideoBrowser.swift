import AVFoundation
import MobileCoreServices
import UIKit
import Then

enum VideoBrowser {
    static func startMediaBrowser(
        delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate,
        sourceType: UIImagePickerController.SourceType
    ) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        
        let mediaUI = UIImagePickerController().then {
            $0.sourceType = sourceType
            $0.mediaTypes = [kUTTypeMovie as String]
            $0.allowsEditing = true
            $0.delegate = delegate
        }        
        delegate.present(mediaUI, animated: true, completion: nil)
    }
}
