import UIKit

protocol NftCollectionViewControllerDepsFactory {
    func nftCollectionDetailController() -> NftCollectionDetailController?
}

final class NftCollectionViewController: StatLoggedUIViewController {
    private let contentView: NftCollectionView
    private var presenter: NftCollectionPresenter
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

        self.presenter.delegate = self
        self.presenter.view = contentView
        self.contentView.delegate = self.presenter

        navigationItem.title = ""
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }

}

extension NftCollectionViewController: NftCollectionPresenterDelegate {
    func didSelectRow(rowData: NftCollection) {
        let nftCollectionDetailController = depsFactory.nftCollectionDetailController()
        guard let nftCollectionDetailController else { return }
        nftCollectionDetailController.initData(nftCollection: rowData)
        nftCollectionDetailController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nftCollectionDetailController, animated: true)
    }
}
