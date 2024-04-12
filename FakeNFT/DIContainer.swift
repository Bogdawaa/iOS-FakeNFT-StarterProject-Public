import Swinject

final class DIContainer {
    private var container = Container()

    init() {
        registerFoundation()
        registerCatalog()
        registerStatistics()
        registerUserCard()

        container.register(TabBarController.self) { diResolver in
            TabBarController(
                servicesAssembly: diResolver.resolve(ServicesAssembly.self)!,
                catalogViewController: diResolver.resolve(CatalogViewController.self)!,
                statisticsController: UINavigationController(
                    rootViewController: StatisticsViewController(
                        presenter: diResolver.resolve(StatisticsPresenter.self)!,
                        statlog: diResolver.resolve(StatLog.self)!
                    )
                )
            )
        }
    }

    func tabBarController() -> TabBarController {
        container.resolve(TabBarController.self)!
    }

    func userCard() -> UserCardViewController {
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
    }

    private func registerUserCard() {
        container.register(UserCardPresenter.self) { _ in UserCardPresenter() }
            .inObjectScope(.container)

        container.register(UserCardViewController.self) { diResolver in
            UserCardViewController(
                presenter: diResolver.resolve(UserCardPresenter.self)!,
                statlog: diResolver.resolve(StatLog.self)!
            )
        }
    }
}
