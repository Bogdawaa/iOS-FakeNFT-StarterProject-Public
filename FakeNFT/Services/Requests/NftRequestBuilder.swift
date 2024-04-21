import Foundation

 private func urlRequest(
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

extension NftListApiPath {
    func buildRequest(page: Int, sortBy: String?) -> URLRequest {
        var queryItems = [URLQueryItem(name: "page", value: String(page))]

        if let sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }

        return urlRequest(method: .get, path: self.path, queryItems: queryItems)
    }
}

extension NftEntityApiPath {
    func buildGetRequest() -> URLRequest {
        return urlRequest(method: .get, path: self.path, queryItems: nil)
    }
}
