import Swinject
import UIKit

final class DIContainer {
    private var container = Container()

    init() {
        registerFoundation()
        registerProfile()
        registerCatalog()
        registerStatistics()
        registerUserCard()

        container.register(TabBarController.self) { diResolver in
            TabBarController(
                servicesAssembly: diResolver.resolve(ServicesAssembly.self)!,
                catalogViewController: diResolver.resolve(CatalogViewController.self)!,
                profileViewController: UINavigationController(
                    rootViewController: diResolver.resolve(ProfileViewController.self)!
                ),
                statisticsController: diResolver.resolve(StatisticsViewController.self)!
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

    func userCardController() -> UserCardViewController {
        container.resolve(UserCardViewController.self)!
    }

    private func registerCatalog() {
        container.register(CatalogViewController.self) { diResolver in
            TestCatalogViewController(
                servicesAssembly: diResolver.resolve(ServicesAssembly.self)!,
                statLog: diResolver.resolve(StatLog.self)!
            )
        }
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

        container.register(StatisticsViewController.self) { diResolver in
            StatisticsViewController(
                presenter: diResolver.resolve(StatisticsPresenter.self)!,
                statlog: diResolver.resolve(StatLog.self)!
            )
        }
        .inObjectScope(.container)
    }

    private func registerUserCard() {
        container.register(UserCardPresenter.self) { _ in
            UserCardPresenter()
        }
        .inObjectScope(.container)

        container.register(UserCardViewController.self) { diResolver in
            UserCardViewController(
                presenter: diResolver.resolve(UserCardPresenter.self)!,
                statlog: diResolver.resolve(StatLog.self)!
            )
        }
        .inObjectScope(.container)
    }
}
