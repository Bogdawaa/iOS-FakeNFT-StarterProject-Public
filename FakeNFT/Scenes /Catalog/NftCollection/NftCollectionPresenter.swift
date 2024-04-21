import UIKit

protocol NftCollectionPresenter: NftCollectionViewDelegate {
    var delegate: NftCollectionPresenterDelegate? { get set }
    var view: NftCollectionView? { get set }
    func viewDidLoad()
}

protocol NftCollectionPresenterDelegate: AnyObject {
    func didSelectRow(rowData: NftCollection)
}

enum NftViewState {
    case initial, loading, failed(Error), data(result: ListServiceResult)
}

final class NftCollectionPresenterImpl: NftCollectionPresenter {
    weak var delegate: NftCollectionPresenterDelegate?
    weak var view: NftCollectionView?

    private var listService: ListService<NftCollection>

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
        case .failed(let error):
            print(error.localizedDescription)
//            let errorModel = makeErrorModel(error)
            view?.hideLoading()
//            view?.showError(errorModel)
        }
    }

    private func loadCollections() {
        Task {
            do {
                let result = try await listService.fetchNextPage(sortBy: nil)
                await MainActor.run {
                    self.state = .data(result: result)
                }
            } catch {
                await MainActor.run {
                    self.state = .failed(error)
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
        guard let rowData = rowData(at: indexPath) else { return }
        delegate?.didSelectRow(rowData: rowData)
    }
}
