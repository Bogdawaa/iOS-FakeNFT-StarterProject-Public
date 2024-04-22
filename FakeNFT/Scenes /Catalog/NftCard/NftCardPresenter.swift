import UIKit

protocol NftCardPresenter: NftCardViewDelegate {
    var delegate: NftCardPresenterDelegate? { get set }
    var view: NftCardView? { get set }
    func viewDidLoad()
    func initData(nft: Nft)
}

enum NftCardViewState {
    case initial, loading, failed(Error), data(result: ListServiceResult)
}

final class NftCollectionDetailPresenterImpl: NftCollectionDetailPresenter {
    weak var delegate: NftCardPresenterDelegate?
    weak var view: NftCardView?

    private var listService: ListService<Currency>
    private var nft: Nft?

    private var state = NftCardViewState.initial {
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

    func initData(nft: Nft) {
        self.nft = nft
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

extension NftCardPresenterImpl: NftCardViewDelegate {
    var numberOfRows: Int {
        listService.itemsCount
    }

    func rowData(at indexPath: IndexPath) -> Curency? {
        listService.item(at: indexPath.row)
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let rowData = rowData(at: indexPath) else { return }
        print(rowData)
    }
}
