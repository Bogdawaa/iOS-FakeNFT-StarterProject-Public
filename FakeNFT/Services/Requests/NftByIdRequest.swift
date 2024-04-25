import Foundation

struct NFTRequest: /*BaseNftRequest*/ NetworkRequest {
    var httpBody: String?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
