import UIKit
import SnapKit

final class ToolsViewController: UIViewController {
    typealias Callback = ((Int) -> Void)
    
    let dataSource: ToolsCollectionDataSource
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ToolsCollectionViewLayout()
    )
    var didSelectToolCallback: Callback?

    init(tools: [ToolEnum]) {
        self.dataSource = ToolsCollectionDataSource(collectionView: collectionView, tools: tools)
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let toolsLayout = collectionView.collectionViewLayout as? ToolsCollectionViewLayout {
            toolsLayout.setContainerWidth(view.frame.width)
        }
    }
    
    func attribute() {
        collectionView.backgroundColor = .white
    }
    
    func layout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ToolsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectToolCallback?(indexPath.row)
    }
}

extension ToolsViewController {
    func getContainerHeight(forWidth width: CGFloat) -> CGFloat {
        let itemSize = ToolsCollectionViewLayout.getItemSize(containerWidth: width)
        let numberOfRows = max(1, dataSource.tools.count/ToolsCollectionViewLayout.numberOfItemsInRow)

        return itemSize.height * CGFloat(numberOfRows) + ToolsCollectionViewLayout.spacing * 7
    }
}
