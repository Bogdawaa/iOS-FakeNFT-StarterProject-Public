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
                catalogViewController: diResolver.resolve(NftCollectionViewController.self)!
            )
        }
    }

    func tabBarController() -> TabBarController {
        container.resolve(TabBarController.self)!
    }

    private func registerCatalog() {
        container.register(NftCollectionPresenter.self) { diResolver in
            NftCollectionPresenterImpl(
                listService: ListService<NftCollection>(
                    networkClient: diResolver.resolve(AsyncNetworkClient.self)!
                )
            )
        }

        container.register(NftCollectionViewController.self) { diResolver in
            let presenter = diResolver.resolve(NftCollectionPresenter.self)!
            let view = NftCollectionView()
            let controller = NftCollectionViewController(
                contentView: view,
                presenter: presenter,
                depsFactory: self,
                statlog: diResolver.resolve(StatLog.self)!
            )
            
            presenter.delegate = controller
            presenter.view = view
            view.delegate = presenter

            return controller
        }
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
}

extension DIContainer: NftCollectionViewControllerDepsFactory {
    func nftCollectionViewController() -> UIViewController? {
        UIViewController()
    }
}
