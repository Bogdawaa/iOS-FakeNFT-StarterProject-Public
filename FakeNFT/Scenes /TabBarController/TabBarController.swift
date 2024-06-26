import UIKit

final class TabBarController: UITabBarController {
    private let catalogViewController: NftCollectionViewController
    private let servicesAssembly: ServicesAssembly
    private let profileViewController: UINavigationController
    private let statisticsController: StatisticsViewController

    init(
        servicesAssembly: ServicesAssembly,
        catalogViewController: NftCollectionViewController,
        profileViewController: UINavigationController,
        statisticsController: StatisticsViewController
    ) {
        self.servicesAssembly = servicesAssembly
        self.catalogViewController = catalogViewController
        self.profileViewController = profileViewController
        self.statisticsController = statisticsController

        super.init(nibName: nil, bundle: nil)

        viewControllers = [
            self.profileViewController,
            UINavigationController(rootViewController: self.catalogViewController),
            UIViewController(),
            UINavigationController(rootViewController: statisticsController)
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
        setTabBarItemColors(tabBarAppearance.stackedLayoutAppearance)
        setTabBarItemColors(tabBarAppearance.inlineLayoutAppearance)
        setTabBarItemColors(tabBarAppearance.compactInlineLayoutAppearance)

        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .ypBlack
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ypBlack]
    }
}
