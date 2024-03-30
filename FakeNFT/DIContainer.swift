import Swinject
import UIKit

final class DIContainer {
    private let container = Container()

    init() {
        registerFoundation()
        registerCatalog()

        container.register(TabBarController.self) { diResolver in
            TabBarController(
                servicesAssembly: diResolver.resolve(ServicesAssembly.self)!,
                catalogViewController: diResolver.resolve(CatalogViewController.self)!
            )
        }
    }

    func tabBarController() -> TabBarController {
        container.resolve(TabBarController.self)!
    }

    private func registerCatalog() {
        container.register(CatalogPresenter.self) { _ in
            CatalogPresenterImpl(
            )
        }

        container.register(CatalogViewController.self) { diResolver in
            CatalogViewController(
                contentView: CatalogView(),
                presenter: diResolver.resolve(CatalogPresenter.self)!,
                depsFactory: self,
                statlog: diResolver.resolve(StatLog.self)!
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
}

extension DIContainer: CatalogViewControllerDepsFactory {
    func nftCollectionViewController() -> UIViewController? {
        UIViewController()
    }
}
