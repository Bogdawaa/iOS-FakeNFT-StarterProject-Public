import UIKit

protocol NftCollectionDetailControllerDepsFactory {
    func nftCollectionViewController() -> UIViewController?
}

protocol NftCollectionDetailController: UIViewController {
    func initData(nftCollection: NftCollection)
}

final class NftCollectionDetailControllerImpl: StatLoggedUIViewController {
    private let contentView: NftCollectionDetailView
    private var presenter: NftCollectionDetailPresenter
    private let depsFactory: NftCollectionDetailControllerDepsFactory

    init(
        contentView: NftCollectionDetailView,
        presenter: NftCollectionDetailPresenter,
        depsFactory: NftCollectionDetailControllerDepsFactory,
        statlog: StatLog
    ) {
        self.contentView = contentView
        self.presenter = presenter
        self.depsFactory = depsFactory

        super.init(statLog: statlog)

        navigationItem.title = ""
    }

    override func loadView() {
        view = contentView
    }
}

extension NftCollectionDetailControllerImpl: NftCollectionDetailController, ErrorView {
    func initData(nftCollection: NftCollection) {
        self.presenter.initData(nftCollection: nftCollection)
    }
}

extension NftCollectionDetailControllerImpl: NftCollectionDetailPresenterDelegate {
    func didSelectRow(rowData: Nft) {
        let nftCollectionViewController = depsFactory.nftCollectionViewController()
        guard let nftCollectionViewController else { return }
        navigationController?.pushViewController(nftCollectionViewController, animated: true)
    }
}
