import Foundation

struct Nft: Codable {
    let id: String
    let name: String
    let author: String
    let description: String
    let images: [String]
    let price: Double
    let rating: Int
    let createdAt: String

    var imagesURL: [URL] {
        images.compactMap { URL(string: $0) }
    }
}

typealias NftList = [Nft]

extension Nft: ApiDto {
    static func listPath(ids: PathIds) -> String {
        switch ids {
        case .empty:
            return "nft"
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
}
