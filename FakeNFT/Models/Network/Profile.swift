import Foundation

struct Profile: Codable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let rating: Int
    let createdAt: String
}

extension Profile: ApiDto {
    func pathIds() -> PathIds {
        .one(first: id)
    }

    static func listPath(ids: PathIds) -> String {
        switch ids {
        case .empty:
            return "profile"
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

struct ProfilePatch: ApiPatch {
    let object: any ApiDto

    let id: String
    let likes: [String]

    init(profile: Profile, likes: [String]) {
        self.object = profile
        self.id = profile.id
        self.likes = likes
    }

    func asData() -> Data {
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        if likes.isEmpty {
            queryItems.append(URLQueryItem(name: "likes", value: "null"))
        } else {
            likes.forEach { nft in
                queryItems.append(URLQueryItem(name: "likes", value: nft))
            }
        }
        queryItems.append(URLQueryItem(name: "id", value: id))
        components.queryItems = queryItems
        return components.query?.data(using: .utf8) ?? Data()
    }
}
