import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var parametrs: [String: String]? { get }
//    var secretInjector: (_ request: URLRequest) -> URLRequest { get } TODO:
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var authToken: String? { RequestConstants.authToken }
    var application: String? { RequestConstants.application }
    var parametrs: [String: String]? { nil }
}
