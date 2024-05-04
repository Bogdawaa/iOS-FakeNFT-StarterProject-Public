import UIKit

protocol NftCollectionDetailPresenter: NftCollectionDetailViewDelegate {
    var delegate: NftCollectionDetailPresenterDelegate? { get set }
    var view: NftCollectionDetailView? { get set }
    func viewDidDisappear()
    func initData(nftCollection: NftCollection)
}

protocol NftCollectionDetailPresenterDelegate: AnyObject, ErrorView, UIViewController {
    func showViewController(viewController: UIViewController)
}

protocol NftCollectionDetailDepsFactory {
    func nftDetailViewController() -> UIViewController?
    func webViewViewController(url: URL) -> WebViewViewController?
}

final class NftCollectionDetailPresenterImpl: NftCollectionDetailPresenter {
    weak var delegate: NftCollectionDetailPresenterDelegate?
    weak var view: NftCollectionDetailView?

    private let depsFactory: NftCollectionDetailDepsFactory
    private let nftService: EntityService<Nft>
    private let profileService: EntityService<Profile>
    private let orderService: EntityService<NftOrder>

    private var profile: Profile?
    private var nftOrder: NftOrder?
    private var nftCollection: NftCollection?
    private var nfts: [String: Nft] = [:]
    private var loadTask: Task<(), Never>?

    private var state = NftCollectionDetailViewState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(
        nftService: EntityService<Nft>,
        profileService: EntityService<Profile>,
        orderService: EntityService<NftOrder>,
        depsFactory: NftCollectionDetailDepsFactory
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
        self.depsFactory = depsFactory
    }

    internal func viewDidDisappear() {
        if let loadTask, !loadTask.isCancelled {
            loadTask.cancel()
        }
    }

    func initData(nftCollection: NftCollection) {
        self.nftCollection = nftCollection
        state = .loading
    }

    private func stateDidChanged() {
        guard let view else {
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
        case let .failed(error, action):
            view.hideLoading()
            showError(error: error, action: action)
        }
    }

    private func showError(error: NetworkError, action: NftCollectionDetailViewAction) {
        guard let delegate else {
            assertionFailure()
            return
        }
        delegate.showError(
            ErrorModel(
                message: error.description,
                action: { [weak self] in
                    switch action {
                    case .loading:
                        self?.state = .loading
                    case let .toggleLike(indexPath):
                        self?.state = .toggleLike(indexPath: indexPath)
                    case let .toggleCart(indexPath):
                        self?.state = .toggleCart(indexPath: indexPath)
                    }
                }
            )
        )
    }

    private func loadData() {
        loadTask = Task { [weak self] in
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
                if (error as? CancellationError) != nil { return }
                let error = error as? NetworkError ?? NetworkError.unknownError(error: error)
                await MainActor.run { [weak self] in
                    self?.state = .failed(error: error, action: .loading)
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
        guard let profile, let nftId = nft(at: indexPath)?.id else { return }
        var likes = profile.likes

        if likes.contains(nftId) {
            likes = likes.filter { $0 != nftId }
        } else {
            likes.append(nftId)
        }
        let patch = ProfilePatch(profile: profile, likes: likes)

        let profileService = profileService
        Task {
            do {
                try await profileService.patch(patch)
                let profile = try await profileService.fetch(pathIds: profile.pathIds())
                await MainActor.run { [weak self] in
                    self?.state = .likeToggled(indexPath: indexPath, profile: profile)
                }
            } catch {
                let error = error as? NetworkError ?? NetworkError.unknownError(error: error)
                await MainActor.run { [weak self] in
                    self?.state = .failed(error: error, action: .toggleLike(indexPath: indexPath))
                }
            }
        }
    }

    private func patchNftOrder(at indexPath: IndexPath) {
        guard let nftOrder, let nftId = nft(at: indexPath)?.id else { return }
        var nfts = nftOrder.nfts

        if nfts.contains(nftId) {
            nfts = nfts.filter { $0 != nftId }
        } else {
            nfts.append(nftId)
        }
        let patch = NftOrderPatch(order: nftOrder, nfts: nfts)

        let service = orderService
        Task {
            do {
                try await service.patch(patch)
                let nftOrder = try await service.fetch(pathIds: nftOrder.pathIds())
                await MainActor.run { [weak self] in
                    self?.state = .cartToggled(indexPath: indexPath, nftOrder: nftOrder)
                }
            } catch {
                let error = error as? NetworkError ?? NetworkError.unknownError(error: error)
                await MainActor.run { [weak self] in
                    self?.state = .failed(error: error, action: .toggleCart(indexPath: indexPath))
                }
            }
        }
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
        let nftDetailViewController = depsFactory.nftDetailViewController()
        guard let nftDetailViewController, let delegate else { return }
        delegate.showViewController(viewController: nftDetailViewController)
    }

    func lileToggled(at indexPath: IndexPath) {
        switch state {
        case .initial, .data, .likeToggled, .cartToggled, .failed:
            state = .toggleLike(indexPath: indexPath)
        case .loading, .toggleLike, .toggleCart:
            break
        }
    }

    func cartToggled(at indexPath: IndexPath) {
        switch state {
        case .initial, .data, .likeToggled, .cartToggled, .failed:
            state = .toggleCart(indexPath: indexPath)
        case .loading, .toggleLike, .toggleCart:
            break
        }
    }

    func authorLinkTap() {
        // Не понятно, где брать url, сделал заглушку
        let linkUrl = URL(string: "https://ya.ru")!
        let webViewViewController = depsFactory.webViewViewController(url: linkUrl)
        guard let webViewViewController, let delegate else { return }
        delegate.showViewController(viewController: webViewViewController)
    }
}
