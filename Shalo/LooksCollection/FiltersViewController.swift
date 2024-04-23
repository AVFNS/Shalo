import UIKit
import SnapKit
import Then

final class FiltersViewController: UIViewController {
    typealias Callback = (Int, Int) -> Void
    
    let dataSource: FiltersCollectionDataSource
    let collectionView: UICollectionView
    var didSelectLook: Callback?
    var currentlySelectedFilterIndex: Int?
    var initiallySelectedFilterIndex: Int
    
    var selectedFilter: Filter {
        dataSource.filters[initiallySelectedFilterIndex]
    }
    
    convenience init(itemSize: CGSize, selectedFilterIndex: Int, filters: [Filter]) {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: FiltersCollectionViewLayout(itemSize: itemSize)
        )
        
        self.init(itemSize: itemSize, selectedFilterIndex: selectedFilterIndex, filters: filters, collectionView: collectionView)
    }
    
    init(itemSize: CGSize, selectedFilterIndex: Int, filters: [Filter], collectionView: UICollectionView) {
        self.initiallySelectedFilterIndex = selectedFilterIndex
        self.currentlySelectedFilterIndex = selectedFilterIndex
        self.collectionView = collectionView
        
        self.dataSource = FiltersCollectionDataSource(
            collectionView: collectionView,
            filters: filters,
            context: CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
        )
        super.init(nibName: nil, bundle: nil)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        collectionView.selectItem(at: IndexPath(item: initiallySelectedFilterIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(item: initiallySelectedFilterIndex, section: 0))
    }
    
    func setUpCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.bounces = false
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func deselectFilter() {
        if let currentlySelectedFilterIndex = currentlySelectedFilterIndex {
            collectionView.deselectItem(at: IndexPath(item: currentlySelectedFilterIndex, section: 0), animated: false)
        }
        let indexPath = IndexPath(row: initiallySelectedFilterIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        currentlySelectedFilterIndex = nil
    }
}

extension FiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = initiallySelectedFilterIndex
        let pendingFilterIndex = indexPath.row
        self.currentlySelectedFilterIndex = pendingFilterIndex
        
        didSelectLook?(pendingFilterIndex, previousIndex)
        
        // 선택된 아이템을 화면의 가운데로 스크롤하여 보여주도록 합니다.
        if pendingFilterIndex != 0 {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
