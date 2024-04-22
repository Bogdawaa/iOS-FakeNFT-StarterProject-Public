import UIKit

protocol NftCollectionDetailPresenter: NftCollectionDetailViewDelegate {
    var delegate: NftCollectionDetailPresenterDelegate? { get set }
    var view: NftCollectionDetailView? { get set }
    func initData(nftCollection: NftCollection)
}

protocol NftCollectionDetailPresenterDelegate: AnyObject {
    func didSelectRow(rowData: Nft)
}

enum NftCollectionDetailViewState {
    case initial, data(nftCollection: NftCollection)
}

final class NftCollectionDetailPresenterImpl: NftCollectionDetailPresenter {
    weak var delegate: NftCollectionDetailPresenterDelegate?
    weak var view: NftCollectionDetailView?

    private var entityService: EntityService<Nft>
    private var nftCollection: NftCollection?
    private var loadedNft: [Int: Nft] = [:]
    private var nftInLoad = Set<String>()

    private var state = NftCollectionDetailViewState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(entityService: EntityService<Nft>) {
        self.entityService = entityService
    }

    func initData(nftCollection: NftCollection) {
        state = .data(nftCollection: nftCollection)
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .data(let nftCollection):
            self.nftCollection = nftCollection
            self.view?.initData(nftCollection: nftCollection)
        }
    }

    private func loadNft(at index: Int) {
        guard
            let nftId = nftCollection?.nfts[index],
            !nftInLoad.contains(nftId),
            loadedNft[index] == nil
        else { return }

        nftInLoad.insert(nftId)

        Task {
            do {
                let result = try await entityService.fetch(nftApiPath: .nft(nftId: nftId))
                loadedNft[index] = result

                await MainActor.run {
                    view?.reloadItem(at: IndexPath(row: index, section: 0))
                    nftInLoad.remove(nftId)
                }
            } catch {
                print("item load error \(nftId)")
                nftInLoad.remove(nftId)
            }
        }
    }
}

extension NftCollectionDetailPresenterImpl: NftCollectionDetailViewDelegate {
    var numberOfRows: Int {
        nftCollection?.nfts.count ?? 0
    }

    func rowData(at indexPath: IndexPath) -> Nft? {
        loadedNft[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let rowData = rowData(at: indexPath) else { return }
        delegate?.didSelectRow(rowData: rowData)
    }

    func itemWillDisplay(at indexPath: IndexPath) {
        loadNft(at: indexPath.row)
    }
}
