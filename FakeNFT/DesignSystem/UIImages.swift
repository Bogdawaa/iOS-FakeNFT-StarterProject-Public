import UIKit

// swiftlint:disable object_literal
extension UIImage {
    static let ypProfileTab = UIImage(named: "profile") ?? UIImage()
    static let ypCatalogTab = UIImage(named: "catalog") ?? UIImage()
    static let ypBasketTab = UIImage(named: "basket") ?? UIImage()
    static let ypStatisticsTab = UIImage(named: "statistics") ?? UIImage()

    static let ypClose = UIImage(named: "close") ?? UIImage()

    static let ypStar = UIImage(named: "star") ?? UIImage()
    static let ypCartAdd = UIImage(named: "cartAdd") ?? UIImage()
    static let ypCartRemove = UIImage(named: "cartRemove") ?? UIImage()
    static let ypSort = UIImage(named: "sort") ?? UIImage()

    static let ypStarYellow = (UIImage(named: "star") ?? UIImage())
        .withTintColor(.ypYellowUniversal, renderingMode: .alwaysOriginal)
    static let ypStarGray = (UIImage(named: "star") ?? UIImage())
        .withTintColor(.ypLightGray, renderingMode: .alwaysOriginal)

    static let ypLikeRed = (UIImage(named: "like") ?? UIImage())
        .withTintColor(.ypRedUniversal, renderingMode: .alwaysOriginal)
    static let ypLikeWhire = (UIImage(named: "like") ?? UIImage())
        .withTintColor(.ypWhiteUniversal, renderingMode: .alwaysOriginal)
}
// swiftlint:enable object_literal
