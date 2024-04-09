import Swinject

final class DIContainer {
    private var container = Container()

    init() {
        registerFoundation()
        registerProfile()
        registerCatalog()

        container.register(TabBarController.self) { diResolver in
            TabBarController(
                servicesAssembly: diResolver.resolve(ServicesAssembly.self)!,
                catalogViewController: diResolver.resolve(CatalogViewController.self)!,
                profileViewController: diResolver.resolve(ProfileViewController.self)!
            )
        }
    }

    func tabBarController() -> TabBarController {
        container.resolve(TabBarController.self)!
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
        container.register(ProfileViewPresenter.self) { diResolver in
            ProfileViewPresenter(
                service: ProfileServiceImpl(
                networkClient: diResolver.resolve(NetworkClient.self)!,
                storage: ProfileStorageImpl()
            )
            )
        }
        .inObjectScope(.container)

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
}
