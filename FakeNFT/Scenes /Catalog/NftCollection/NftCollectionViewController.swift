import UIKit

protocol NftCollectionViewController: UIViewController {}

final class NftCollectionViewControllerImpl: StatLoggedUIViewController {
    private let contentView: NftCollectionView
    private let presenter: NftCollectionPresenter

    init(
        contentView: NftCollectionView,
        presenter: NftCollectionPresenter,
        statlog: StatLog
    ) {
        self.contentView = contentView
        self.presenter = presenter

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
    func showViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
