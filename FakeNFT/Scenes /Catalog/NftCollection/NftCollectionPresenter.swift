import UIKit

protocol NftCollectionPresenter: NftCollectionViewDelegate {
    var delegate: NftCollectionPresenterDelegate? { get set }
    var view: NftCollectionView? { get set }
    func viewDidLoad()
    func selectOrder()
}

protocol NftCollectionPresenterDelegate: AnyObject, SortableView, ErrorView {
    func didSelectRow(rowData: NftCollection)
}

enum NftViewState {
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
    private var order: NftCollectionOrder = .name
    private var loadingTask: Task<(), Never>?

    private var state = NftViewState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(listService: ListService<NftCollection>) {
        self.listService = listService
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
        if loadingTask != nil {
            loadingTask?.cancel()
            loadingTask = nil
        }

        loadingTask = Task { [weak self] in
            guard let self else { return }

            do {
                let result = try await self.listService.fetchNextPage(sortBy: order.rawValue)
                await MainActor.run { [weak self] in
                    self?.state = .data(result: result)
                }
            } catch {
                let error = error as? NetworkError ?? NetworkError.unknownError(error: error)

                await MainActor.run { [weak self] in
                    self?.state = .failed(error)
                }
            }
            self.loadingTask = nil
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
        guard let rowData = rowData(at: indexPath) else { return }
        delegate?.didSelectRow(rowData: rowData)
    }
}
