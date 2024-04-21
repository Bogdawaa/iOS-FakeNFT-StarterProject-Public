import Foundation

enum NftEntityApiPath {
    case nft(nftId: String)
    case collection(collectionId: String)
    case user(userId: String)
    case profile(profileId: String)
    case order(orderId: String)
    case currency(currencyId: String)
    case orderPayment(orderId: String, currencyId: String)

    private static let basePath = "/api/v1"

    var path: String {
        switch self {
        case .nft(let nftId):
            return "\(Self.basePath)/nft/\(nftId)"
        case .collection(let collectionId):
            return "\(Self.basePath)/collections/\(collectionId)"
        case .user(let userId):
            return "\(Self.basePath)/users/\(userId)"
        case .profile(let profileId):
            return "\(Self.basePath)/profile/\(profileId)"
        case .order(let orderId):
            return "\(Self.basePath)/orders/\(orderId)"
        case let .orderPayment(orderId, currencyId):
            return "\(Self.basePath)/orders/\(orderId)/payment/\(currencyId)"
        case .currency(let currencyId):
            return "\(Self.basePath)/currencies/\(currencyId)"
        }
    }
}

enum NftListApiPath {
    case nftList
    case collectionList
    case userList
    case currencyList

    private static let basePath = "/api/v1"

    var path: String {
        switch self {
        case .nftList:
            return "\(Self.basePath)/nft/"
        case .collectionList:
            return "\(Self.basePath)/collections"
        case .userList:
            return "\(Self.basePath)/users"
        case .currencyList:
            return "\(Self.basePath)/currencies"
        }
    }
}
