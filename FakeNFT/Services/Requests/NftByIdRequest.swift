import Foundation

struct NFTRequest: BaseNftRequest {
    var httpBody: String?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
