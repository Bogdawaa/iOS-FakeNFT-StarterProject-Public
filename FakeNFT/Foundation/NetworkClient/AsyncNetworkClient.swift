import Foundation

protocol AsyncNetworkClient {
    func fetch<T: Decodable>(from request: URLRequest, as dtoType: T.Type) async throws -> T
    func fetch(from request: URLRequest) async throws -> Data
}

enum NetworkError: Error {
    case connectingError(error: URLError)
    case codeError(code: Int)
    case parseError
    case authFailed
    case unknownError(error: Error)

    var description: String {
        switch self {
        case let .connectingError(error):
            return "Ошибка соединения: \(error.localizedDescription)"
        case let .codeError(code):
            return "Сервер ответил ошибкой: \(code)"
        case .parseError:
            return "Ошибка разбора данных"
        case let .unknownError(error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        case .authFailed:
            return "Ошибка авторизации"
        }
    }
}

struct AsyncNetworkClientImpl: AsyncNetworkClient {
    func fetch<T: Decodable>(from request: URLRequest, as dtoType: T.Type) async throws -> T {
        print("🕸️ℹ️ raw request= \(request.httpMethod ?? "GET") \(request)")
        let response = try await fetch(from: request)
        print("🕸️ℹ️ raw response=\(String(decoding: response, as: UTF8.self))")

        do {
            return try response.fromJson(to: T.self)
        } catch {
            throw NetworkError.parseError
        }
    }

    func fetch(from request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                if response.statusCode == 401 {
                    throw NetworkError.authFailed
                }

                throw NetworkError.codeError(code: response.statusCode)
            }

            return data
        } catch let error as URLError {
            if error.code == URLError.cancelled {
                throw CancellationError()
            }
            throw NetworkError.connectingError(error: error)
        } catch {
            throw NetworkError.unknownError(error: error)
        }
    }
}
