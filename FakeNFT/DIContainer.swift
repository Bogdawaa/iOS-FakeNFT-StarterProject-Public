import Swinject
import UIKit

final class DIContainer {
    private let container = Container()

    init() {
        registerFoundation()
        registerProfile()
        registerCatalog()
        registerStatistics()
        registerUserCard()
        registerUsersCollectionNft()
        registerWebView()

        container.register(TabBarController.self) { diResolver in
            TabBarController(
                servicesAssembly: diResolver.resolve(ServicesAssembly.self)!,
                catalogViewController: diResolver.resolve(NftCollectionViewController.self)!,
                profileViewController: UINavigationController(
                    rootViewController: diResolver.resolve(ProfileViewController.self)!
                ),
                statisticsController: ViewBuilder.buildStatisticsViewController()
            )
        }
    }

    func tabBarController() -> TabBarController {
        container.resolve(TabBarController.self)!
    }

    func myNftViewController() -> MyNFTViewProtocol {
        container.resolve(MyNFTViewController.self)!
    }
    func favoritesNFTViewController() -> FavoritesNFTViewProtocol {
        container.resolve(FavoritesNFTViewController.self)!
    }
    func editProfileViewController() -> EditProfileViewProtocol {
        container.resolve(EditProfileViewController.self)!
    }

    func userCard() -> UserCardViewController {
        container.resolve(UserCardViewController.self)!
    }

    func userCardPresenter() -> UserCardPresenter {
        container.resolve(UserCardPresenter.self)!
    }

    func usersCollectionPresenter() -> UsersCollectionPresenter {
        container.resolve(UsersCollectionPresenter.self)!
    }

    func statisticsPresenter() -> StatisticsPresenter {
        container.resolve(StatisticsPresenter.self)!
    }

    func statlog() -> StatLog {
        container.resolve(StatLog.self)!
    }

    private func registerCatalog() {
        container.register(NftCollectionPresenter.self) { diResolver in
            NftCollectionPresenterImpl(
                listService: ListService<NftCollection>(
                    networkClient: diResolver.resolve(AsyncNetworkClient.self)!
                ),
                depsFactory: self
            )
        }

        container.register(NftCollectionViewController.self) { diResolver in
            let presenter = diResolver.resolve(NftCollectionPresenter.self)!
            let view = NftCollectionView()
            let controller = NftCollectionViewControllerImpl(
                contentView: view,
                presenter: presenter,
                statlog: diResolver.resolve(StatLog.self)!
            )

            presenter.delegate = controller
            presenter.view = view
            view.delegate = presenter

            return controller
        }

        container.register(NftCollectionDetailPresenter.self) { diResolver in
            let networkClient = diResolver.resolve(AsyncNetworkClient.self)!
            return NftCollectionDetailPresenterImpl(
                nftService: EntityService<Nft>(networkClient: networkClient),
                profileService: EntityService<Profile>(networkClient: networkClient),
                orderService: EntityService<NftOrder>(networkClient: networkClient),
                depsFactory: self
            )
        }
        .inObjectScope(.transient)

        container.register(NftCollectionDetailController.self) { diResolver in
            let presenter = diResolver.resolve(NftCollectionDetailPresenter.self)!
            let view = NftCollectionDetailViewImpl()
            let controller = NftCollectionDetailControllerImpl(
                contentView: view,
                presenter: presenter,
                statlog: diResolver.resolve(StatLog.self)!
            )

            presenter.delegate = controller
            presenter.view = view
            view.delegate = presenter

            return controller
        }
        .inObjectScope(.transient)
    }

    private func registerProfile() {
        container.register(EditProfileViewController.self) { diResolver in
            EditProfileViewController(
                statLog: diResolver.resolve(StatLog.self)!,
                presenter: diResolver.resolve(EditProfilePresenter.self)!
            )
        }

        container.register(EditProfilePresenter.self) { diResolver in
            EditProfilePresenter(
                service: EditProfileServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!
                )
            )
        }
        .initCompleted {resolver, presenter in
            let child = presenter
            child.view = resolver.resolve(EditProfileViewController.self)
        }

        container.register(MyNFTPresenter.self) { diResolver in
            MyNFTPresenter(
                service: NftServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!,
                    storage: NftStorageImpl()
                )
            )
        }
        .initCompleted {resolver, presenter in
            let child = presenter
            child.view = resolver.resolve(MyNFTViewController.self)
        }

        container.register(MyNFTViewController.self) { diResolver in
            MyNFTViewController(
                statLog: diResolver.resolve(StatLog.self)!,
                presenter: diResolver.resolve(MyNFTPresenter.self)!
            )
        }

        container.register(FavoritesNFTPresenter.self) { diResolver in
            FavoritesNFTPresenter(
                service: NftServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!,
                    storage: NftStorageImpl()
                )
            )
        }
        .initCompleted {resolver, presenter in
            let child = presenter
            child.view = resolver.resolve(FavoritesNFTViewController.self)
        }

        container.register(FavoritesNFTViewController.self) { diResolver in
            FavoritesNFTViewController(
                statLog: diResolver.resolve(StatLog.self)!,
                presenter: diResolver.resolve(FavoritesNFTPresenter.self)!
            )
        }

        container.register(ProfileViewPresenter.self) { diResolver in
            ProfileViewPresenter(
                service: ProfileServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!,
                    storage: ProfileStorageImpl()
                )
            )
        }

        container.register(ProfileViewController.self) { diResolver in
            ProfileViewController(
                presenter: diResolver.resolve(ProfileViewPresenter.self)!,
                statlog: diResolver.resolve(StatLog.self)!
            )
        }
        .inObjectScope(.container)
    }

    private func registerFoundation() {
        container.register(NetworkClient.self) { _ in
            DefaultNetworkClient()
        }
        .inObjectScope(.container)

        container.register(AsyncNetworkClient.self) { _ in
            AsyncNetworkClientImpl()
        }
        .inObjectScope(.container)

        container.register(NftStorage.self) { _ in
            NftStorageImpl()
        }
        .inObjectScope(.container)

        container.register(ServicesAssembly.self) { diResolver in
            ServicesAssembly(
                networkClient: diResolver.resolve(NetworkClient.self)!,
                nftStorage: diResolver.resolve(NftStorage.self)!
            )
        }
        .inObjectScope(.container)

        container.register(StatLog.self) { _ in
            StatLogImpl()
        }
        .inObjectScope(.container)
    }

    private func registerStatistics() {
        container.register(StatisticsPresenter.self) { diResolver in
            StatisticsPresenter(
                service: UsersServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!,
                    storage: UsersStorageImpl()
                )
            )
        }
        .inObjectScope(.container)
    }

    private func registerUserCard() {
        container.register(UserCardPresenter.self) { _ in UserCardPresenter() }
            .inObjectScope(.container)
    }

    private func registerUsersCollectionNft() {
        container.register(UsersCollectionPresenter.self) { diResolver in
            UsersCollectionPresenter(
                service: NftServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!,
                    storage: NftStorageImpl()
                ),
                serviceCart: CartServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!
                ),
                serviceProfile: ProfileServiceImpl(
                    networkClient: diResolver.resolve(NetworkClient.self)!,
                    storage: ProfileStorageImpl()
                )
            )
        }
        .inObjectScope(.container)
    }

    private func registerWebView() {
        container.register(WebViewViewController.self) { _, url in
            let presenter = WebViewViewPresenterImpl(url: url)
            let view = WebViewViewImpl()

            view.delegate = presenter
            presenter.view = view

            return WebViewViewController(presenter: presenter, contentView: view)
        }
        .inObjectScope(.transient)
    }
}

extension DIContainer: NftCollectionViewDepsFactory {
    func nftCollectionDetailController() -> NftCollectionDetailController? {
        container.resolve(NftCollectionDetailController.self)
    }
}

extension DIContainer: NftCollectionDetailDepsFactory {
    func nftDetailViewController() -> UIViewController? {
        UIViewController()
    }

    func webViewViewController(url: URL) -> WebViewViewController? {
        container.resolve(WebViewViewController.self, argument: url)
    }
}
