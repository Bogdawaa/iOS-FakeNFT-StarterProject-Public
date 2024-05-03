import Foundation

struct NftOrder: Codable {
    let id: String
    let nfts: [String]
}

extension NftOrder: ApiDto {
    static func listPath(ids: PathIds) -> String {
        switch ids {
        case .empty:
            return "orders"
        default:
            assertionFailure()
            return ""
        }
    }

    static func entityPath(ids: PathIds) -> String {
        switch ids {
        case let .one(first):
            return "\(listPath(ids: .empty))/\(first)"
        default:
            assertionFailure()
            return ""
        }
    }

    func pathIds() -> PathIds {
        .one(first: id)
    }
}

struct NftOrderPatch: ApiPatch {
    let object: any ApiDto

    let id: String
    let nfts: [String]

    init(order: NftOrder, nfts: [String]) {
        self.object = order
        self.id = order.id
        self.nfts = nfts
    }

    func asData() -> Data {
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        if nfts.isEmpty {
            queryItems.append(URLQueryItem(name: "nfts", value: "null"))
        } else {
            nfts.forEach { nft in
                queryItems.append(URLQueryItem(name: "nfts", value: nft))
            }
        }
        queryItems.append(URLQueryItem(name: "id", value: id))
        components.queryItems = queryItems
        return components.query?.data(using: .utf8) ?? Data()
    }
}
