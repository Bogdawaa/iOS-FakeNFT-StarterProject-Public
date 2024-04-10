import UIKit

final class TabBarController: UITabBarController {
    private let catalogViewController: CatalogViewController
    private let servicesAssembly: ServicesAssembly
    private let statisticsController: UINavigationController

    init(
        servicesAssembly: ServicesAssembly,
        catalogViewController: CatalogViewController,
        statisticsController: UINavigationController
    ) {
        self.servicesAssembly = servicesAssembly
        self.catalogViewController = catalogViewController
        self.statisticsController = statisticsController

        super.init(nibName: nil, bundle: nil)

        viewControllers = [
            UIViewController(),
            self.catalogViewController,
            UIViewController(),
            self.statisticsController
        ]

        let items = [
            UITabBarItem(
                title: "Tab.profile"~,
                image: UIImage.ypProfileTab,
                selectedImage: nil
            ),
            UITabBarItem(
                title: "Tab.catalog"~,
                image: UIImage.ypCatalogTab,
                selectedImage: nil
            ),
            UITabBarItem(
                title: "Tab.basket"~,
                image: UIImage.ypBasketTab,
                selectedImage: nil
            ),
            UITabBarItem(
                title: "Tab.statistics"~,
                image: UIImage.ypStatisticsTab,
                selectedImage: nil
            )
        ]

        viewControllers?.enumerated().forEach { element in
            element.element.tabBarItem = items[element.offset]
        }

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .ypWhite
        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
