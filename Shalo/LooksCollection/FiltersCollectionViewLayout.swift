import UIKit
import SnapKit
import Then

final class FiltersCollectionViewLayout: UICollectionViewFlowLayout {

    init(itemSize: CGSize) {
        super.init()
        self.itemSize = itemSize
        self.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.minimumLineSpacing = 5
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
