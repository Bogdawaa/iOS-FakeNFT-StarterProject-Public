import UIKit

protocol NftCollectionDetailController: UIViewController {
    func initData(nftCollection: NftCollection)
}

final class NftCollectionDetailControllerImpl: StatLoggedUIViewController {
    private let contentView: NftCollectionDetailView
    private let presenter: NftCollectionDetailPresenter

    init(
        contentView: NftCollectionDetailView,
        presenter: NftCollectionDetailPresenter,
        statlog: StatLog
    ) {
        self.contentView = contentView
        self.presenter = presenter

        super.init(statLog: statlog)

        navigationItem.title = ""
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter.viewDidDisappear()
        super.viewDidDisappear(animated)
    }
}

extension NftCollectionDetailControllerImpl: NftCollectionDetailController, ErrorView {
    func initData(nftCollection: NftCollection) {
        self.presenter.initData(nftCollection: nftCollection)
    }
}

extension NftCollectionDetailControllerImpl: NftCollectionDetailPresenterDelegate {
    func showViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
