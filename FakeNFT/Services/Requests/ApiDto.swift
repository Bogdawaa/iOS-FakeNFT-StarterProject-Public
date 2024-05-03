import Foundation

protocol ApiDto: Codable {
    static func listPath(ids: PathIds) -> String
    static func entityPath(ids: PathIds) -> String
    static func listRequest(pathIds: PathIds, page: Int, sortBy: String?) -> URLRequest
    static func entityRequest(pathIds: PathIds) -> URLRequest
}

extension ApiDto {
    static func listRequest(pathIds: PathIds, page: Int, sortBy: String?) -> URLRequest {
        var queryItems = [URLQueryItem(name: "page", value: String(page))]

        if let sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }

        let path = "\(RequestConstants.baseApiPath)/\(listPath(ids: pathIds))"

        return urlRequest(method: .get, path: path, queryItems: queryItems)
    }

    static func entityRequest(pathIds: PathIds) -> URLRequest {
        let path = "\(RequestConstants.baseApiPath)/\(entityPath(ids: pathIds))"
        return urlRequest(method: .get, path: path, queryItems: nil)
    }

    private static func urlRequest(
        method: HttpMethod,
        path: String,
        queryItems: [URLQueryItem]?
    ) -> URLRequest {
        var components = URLComponents(string: RequestConstants.baseURL)!
        components.path = path
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.setValue(RequestConstants.nftToken, forHTTPHeaderField: RequestConstants.nftHeader)
        request.timeoutInterval = RequestConstants.timeoutInterval
        request.httpMethod = method.rawValue
        return request
    }
}
