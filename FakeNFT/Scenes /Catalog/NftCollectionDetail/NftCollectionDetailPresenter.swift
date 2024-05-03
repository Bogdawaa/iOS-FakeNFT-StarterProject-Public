import UIKit

protocol NftCollectionDetailPresenter: NftCollectionDetailViewDelegate {
    var delegate: NftCollectionDetailPresenterDelegate? { get set }
    var view: NftCollectionDetailView? { get set }
    func initData(nftCollection: NftCollection)
}

protocol NftCollectionDetailPresenterDelegate: AnyObject, ErrorView {
    func didSelectRow(rowData: Nft)
}

enum NftCollectionDetailViewState {
    case initial
    case loading
    case data(profile: Profile, nftOrder: NftOrder, nfts: [String: Nft])
    case toggleLike(indexPath: IndexPath)
    case likeToggled(indexPath: IndexPath, profile: Profile)
    case toggleCart(indexPath: IndexPath)
    case cartToggled(indexPath: IndexPath, nftOrder: NftOrder)
    case failed(NetworkError)
}

final class NftCollectionDetailPresenterImpl: NftCollectionDetailPresenter {
    weak var delegate: NftCollectionDetailPresenterDelegate?
    weak var view: NftCollectionDetailView?

    private var nftService: EntityService<Nft>
    private var profileService: EntityService<Profile>
    private var orderService: EntityService<NftOrder>

    private var profile: Profile?
    private var nftOrder: NftOrder?
    private var nftCollection: NftCollection?
    private var nfts: [String: Nft] = [:]

    private var state = NftCollectionDetailViewState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(
        nftService: EntityService<Nft>,
        profileService: EntityService<Profile>,
        orderService: EntityService<NftOrder>
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }

    func initData(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
        state = .loading
    }

    private func stateDidChanged() {
        guard let view, let delegate else {
            assertionFailure()
            return
        }

        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view.showLoading()
            loadData()

        case let .data(profile, nftOrder, nfts):
            guard let nftCollection else {
                assertionFailure()
                return
            }
            self.profile = profile
            self.nftOrder = nftOrder
            self.nfts = nfts
            view.initData(nftCollection: nftCollection)
            view.hideLoading()

        case .toggleLike(indexPath: let indexPath):
            view.showLoading()
            patchProfile(at: indexPath)

        case let .likeToggled(indexPath, profile):
            self.profile = profile
            view.reloadItem(at: indexPath)
            view.hideLoading()

        case .toggleCart(indexPath: let indexPath):
            view.showLoading()
            patchNftOrder(at: indexPath)

        case let .cartToggled(indexPath, nftOrder):
            self.nftOrder = nftOrder
            view.reloadItem(at: indexPath)
            view.hideLoading()
        case .failed(let error):
            view.hideLoading()
            delegate.showError(
                ErrorModel(
                    message: error.description,
                    action: { [weak self] in
                        self?.state = .loading
                    }
                )
            )
        }
    }

    private func loadData() {
        Task { [weak self] in
            guard let self else { return }

            async let profile = self.loadProfile()
            async let nftOrder = self.loadNftOrder()
            async let nfts = self.loadNfts()

            do {
                let profile = try await profile
                let nftOrder = try await nftOrder
                let nfts = try await nfts

                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.state = .data(profile: profile, nftOrder: nftOrder, nfts: nfts)
                }
            } catch {
                let error = error as? NetworkError ?? NetworkError.unknownError(error: error)
                await MainActor.run { [weak self] in
                    self?.state = .failed(error)
                }
            }
        }
    }

    private func loadProfile() async throws -> Profile {
        try await profileService.fetch(pathIds: .one(first: RequestConstants.defaultProfileId))
    }

    private func loadNftOrder() async throws -> NftOrder {
        try await orderService.fetch(pathIds: .one(first: RequestConstants.defaultOrderId))
    }

    private func loadNfts() async throws -> [String: Nft] {
        guard let nftCollection else { return [:] }
        let nftService = self.nftService

        var result = [String: Nft]()
        try await withThrowingTaskGroup(of: (Nft).self) { group in
            Set(nftCollection.nfts).forEach { nftId in
                group.addTask {
                    return try await nftService.fetch(pathIds: .one(first: nftId))
                }
            }

            for try await nft in group {
                result[nft.id] = nft
            }
        }
        return result
    }

    private func patchProfile(at indexPath: IndexPath) {

    }

    private func patchNftOrder(at indexPath: IndexPath) {

    }

    private func nft(at indexPath: IndexPath) -> Nft? {
        let nftId = nftCollection?.nfts[indexPath.row]
        guard let nftId else { return nil }
        return nfts[nftId]
    }
}

extension NftCollectionDetailPresenterImpl: NftCollectionDetailViewDelegate {
    var numberOfRows: Int {
        nftCollection?.nfts.count ?? 0
    }

    func rowData(at indexPath: IndexPath) -> NftModel? {
        guard let nft = nft(at: indexPath), let profile, let nftOrder else { return nil }
        return NftModel(
            nft: nft,
            isLiked: profile.likes.contains { $0 == nft.id },
            isInCart: nftOrder.nfts.contains { $0 == nft.id }
        )
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let nft = nft(at: indexPath) else { return }
        delegate?.didSelectRow(rowData: nft)
    }

    func lileToggled(at indexPath: IndexPath) {
        state = .toggleLike(indexPath: indexPath)
    }

    func cartToggled(at indexPath: IndexPath) {
        state = .toggleCart(indexPath: indexPath)
    }
}

struct NftModel {
    let nft: Nft
    let isLiked: Bool
    let isInCart: Bool
}
