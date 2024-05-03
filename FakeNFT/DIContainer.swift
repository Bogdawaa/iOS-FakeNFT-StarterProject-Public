import Swinject
import UIKit

final class DIContainer {
    private let container = Container()

    init() {
        registerFoundation()
        registerCatalog()
        registerWebView()

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
            let view = NftCollectionDetailView()
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
