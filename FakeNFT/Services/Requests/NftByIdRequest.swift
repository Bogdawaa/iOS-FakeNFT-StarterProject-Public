import Foundation

struct NFTRequest: BaseNftRequest {
    var httpBody: String?

    var httpMethod: HttpMethod?

    var dto: Encodable?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
