import UIKit

protocol CatalogViewControllerDepsFactory {
    func nftCollectionViewController() -> UIViewController?

}

final class CatalogViewController: StatLoggedUIViewController {
    private let contentView: CatalogView
    private var presenter: CatalogPresenter
    private let depsFactory: CatalogViewControllerDepsFactory

    init(
        contentView: CatalogView,
        presenter: CatalogPresenter,
        depsFactory: CatalogViewControllerDepsFactory,
        statlog: StatLog
    ) {
        self.contentView = contentView
        self.presenter = presenter
        self.depsFactory = depsFactory

        super.init(statLog: statlog)

        self.presenter.delegate = self
        self.contentView.delegate = self.presenter
    }

    override func loadView() {
        view = contentView
    }
}

extension CatalogViewController: CatalogPresenterDelegate {
    func didSelectRow(rowData: CatalogRowData) {
        let nftCollectionViewController = depsFactory.nftCollectionViewController()
        guard let nftCollectionViewController else { return }
//        nftCollectionViewController.delegate = self
//        nftCollectionViewController.initData(category: editTrackerViewModel.category)
        navigationController?.pushViewController(nftCollectionViewController, animated: true)
    }
}
