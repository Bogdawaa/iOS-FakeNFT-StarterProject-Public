import UIKit

protocol NftCollectionDetailControllerDepsFactory {
    func nftCollectionViewController() -> UIViewController?
}

final class NftCollectionDetailController: StatLoggedUIViewController {
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

        self.presenter.delegate = self
        self.presenter.view = contentView
        self.contentView.delegate = self.presenter

        navigationItem.title = ""

    }

    override func loadView() {
        view = contentView
    }

    func initData(nftCollection: NftCollection) {
        self.presenter.initData(nftCollection: nftCollection)
    }

}

extension NftCollectionDetailController: NftCollectionDetailPresenterDelegate {
    func didSelectRow(rowData: Nft) {
        let nftCollectionViewController = depsFactory.nftCollectionViewController()
        guard let nftCollectionViewController else { return }
//        nftCollectionViewController.delegate = self
//        nftCollectionViewController.initData(category: editTrackerViewModel.category)
        navigationController?.pushViewController(nftCollectionViewController, animated: true)
    }
}
