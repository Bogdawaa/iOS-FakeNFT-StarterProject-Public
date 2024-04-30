import UIKit

protocol NftCollectionViewControllerDepsFactory {
    func nftCollectionViewController() -> UIViewController?
}

final class NftCollectionViewController: StatLoggedUIViewController, SortableView, ErrorView {
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .ypSort, style: .plain, target: self, action: #selector(sort)
        )
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
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
        presenter.selectOrder()
    }
}

extension NftCollectionViewController: NftCollectionPresenterDelegate {
    func didSelectRow(rowData: NftCollection) {
        let nftCollectionViewController = depsFactory.nftCollectionViewController()
        guard let nftCollectionViewController else { return }
//        nftCollectionViewController.delegate = self
//        nftCollectionViewController.initData(category: editTrackerViewModel.category)
        navigationController?.pushViewController(nftCollectionViewController, animated: true)
    }
}
