import Foundation

struct NFTRequest: NetworkRequest {
    var httpBody: String?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
