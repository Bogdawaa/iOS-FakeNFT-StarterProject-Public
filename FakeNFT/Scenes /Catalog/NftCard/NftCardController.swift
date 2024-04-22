import UIKit

protocol NftCardControllerDepsFactory {
    func nftDetailsViewController() -> NftDetailViewController?
}

final class NftCardController: StatLoggedUIViewController {
    private let contentView: NftCardView
    private var presenter: NftCardPresenter
    private let depsFactory: NftCardControllerDepsFactory

    init(
        contentView: NftCardView,
        presenter: NftCardPresenter,
        depsFactory: NftCardControllerDepsFactory,
        statlog: StatLog
    ) {
        self.contentView = contentView
        self.presenter = presenter
        self.depsFactory = depsFactory

        super.init(statLog: statlog)

        self.presenter.delegate = self
        self.presenter.view = contentView
        self.contentView.delegate = self.presenter
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }

    func initData(nft: Nft) {
        self.presenter.initData(nft: Nft)
    }

}

extension NftCardController: NftCardPresenterDelegate {
    func didSelectRow(rowData: Nft) {
        let nftDetailsViewController = depsFactory.nftDetailsViewController()
        guard let nftDetailsViewController else { return }
//        nftCollectionViewController.initData(category: editTrackerViewModel.category)
        navigationController?.pushViewController(nftCollectionViewController, animated: true)
    }
}
