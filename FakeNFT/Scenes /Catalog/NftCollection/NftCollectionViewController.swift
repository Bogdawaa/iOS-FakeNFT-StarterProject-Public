import UIKit

protocol NftCollectionViewController: UIViewController {}

protocol NftCollectionViewControllerDepsFactory {
    func nftCollectionDetailController() -> NftCollectionDetailController?
}

final class NftCollectionViewControllerImpl: StatLoggedUIViewController {
    private let contentView: NftCollectionView
    private let presenter: NftCollectionPresenter
    private let depsFactory: NftCollectionViewControllerDepsFactory

    init(
        contentView: NftCollectionView,
        presenter: NftCollectionPresenter,
        depsFactory: NftCollectionViewControllerDepsFactory,
        statlog: StatLog
    ) {
        self.contentView = contentView
        self.presenter = presenter
        self.depsFactory = depsFactory

        super.init(statLog: statlog)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .ypSort, style: .plain, target: self, action: #selector(sort)
        )
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
        navigationItem.title = ""
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }

    @objc
    func sort() {
        statLog.report(from: Self.self, event: .click(item: "sort"))
        presenter.selectOrder()
    }
}

extension NftCollectionViewControllerImpl: NftCollectionViewController, SortableView, ErrorView {}

extension NftCollectionViewControllerImpl: NftCollectionPresenterDelegate {
    func didSelectRow(rowData: NftCollection) {
        let nftCollectionDetailController = depsFactory.nftCollectionDetailController()
        guard let nftCollectionDetailController else { return }
        nftCollectionDetailController.initData(nftCollection: rowData)
        nftCollectionDetailController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nftCollectionDetailController, animated: true)
    }
}
