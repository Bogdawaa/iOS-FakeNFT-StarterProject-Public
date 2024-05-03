import UIKit

protocol NftCollectionPresenter: NftCollectionViewDelegate {
    var delegate: NftCollectionPresenterDelegate? { get set }
    var view: NftCollectionView? { get set }
    func viewDidLoad()
    func selectOrder()
}

protocol NftCollectionPresenterDelegate: AnyObject, SortableView, ErrorView {
    func showViewController(viewController: UIViewController)
}

protocol NftCollectionViewDepsFactory {
    func nftCollectionDetailController() -> NftCollectionDetailController?
}

enum NftCollectioViewState {
    case initial,
         loading,
         failed(NetworkError),
         data(result: ListServiceResult),
         selectOrder,
         orderSelected(order: NftCollectionOrder)
}

final class NftCollectionPresenterImpl: NftCollectionPresenter {
    weak var delegate: NftCollectionPresenterDelegate?
    weak var view: NftCollectionView?

    private var listService: ListService<NftCollection>
    private let depsFactory: NftCollectionViewDepsFactory

    private var order: NftCollectionOrder = .name

    private var state = NftCollectioViewState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(
        listService: ListService<NftCollection>,
        depsFactory: NftCollectionViewDepsFactory
    ) {
        self.listService = listService
        self.depsFactory = depsFactory
    }

    func viewDidLoad() {
        state = .loading
    }

    func selectOrder() {
        state = .selectOrder
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadCollections()
        case .data(let result):
            switch result {
            case .reload:
                view?.reload()
            case .update(newIndexes: let newIndexes):
                view?.update(newIndexes: newIndexes)
            }
            view?.hideLoading()
        case .selectOrder:
            guard let delegate else { return }
            let sortOptions = [
                SortOption(title: "Catalog.SortByName"~, handler: { [weak self] in
                    self?.state = .orderSelected(order: .name)
                }),
                SortOption(title: "Catalog.SortByCount"~, handler: { [weak self] in
                    self?.state = .orderSelected(order: .nfts)
                })
            ]
            delegate.selectOrder(sortOptions: sortOptions)
        case .orderSelected(let order):
            self.order = order
            self.state = .loading
        case .failed(let error):
            view?.hideLoading()
            delegate?.showError(
                ErrorModel(
                    message: error.description,
                    action: { [weak self] in
                        self?.state = .loading
                    }
                )
            )
        }
    }

    private func loadCollections() {
        Task { [weak self] in
            guard let self else { return }

            do {
                let result = try await self.listService.fetchNextPage(sortBy: order.rawValue)
                await MainActor.run { [weak self] in
                    self?.state = .data(result: result)
                }
            } catch {
                if (error as? CancellationError) != nil { return }
                let error = error as? NetworkError ?? NetworkError.unknownError(error: error)

                await MainActor.run { [weak self] in
                    self?.state = .failed(error)
                }
            }
        }
    }
}

extension NftCollectionPresenterImpl: NftCollectionViewDelegate {
    var numberOfRows: Int {
        listService.itemsCount
    }

    func rowData(at indexPath: IndexPath) -> NftCollection? {
        listService.item(at: indexPath.row)
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let rowData = rowData(at: indexPath), let delegate else { return }

        let nftCollectionDetailController = depsFactory.nftCollectionDetailController()
        guard let nftCollectionDetailController else { return }
        nftCollectionDetailController.initData(nftCollection: rowData)
        nftCollectionDetailController.hidesBottomBarWhenPushed = true

        delegate.showViewController(viewController: nftCollectionDetailController)
    }

    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == numberOfRows - 1 {
            state = .loading
        }
    }
}
