import Foundation

final class EntityService<ItemModel: ApiDto> {
    private let networkClient: AsyncNetworkClient

    init(networkClient: AsyncNetworkClient) {
        self.networkClient = networkClient
    }

    func fetch(pathIds: PathIds) async throws -> ItemModel {
        let request = ItemModel.entityRequest(pathIds: pathIds)
        return try await self.networkClient.fetch(from: request, as: ItemModel.self)
    }

    func patch(_ patch: ApiPatch) async throws {
        let pathIds = patch.object.pathIds()
        var request = ItemModel.entityRequest(pathIds: pathIds)

        request.httpMethod = HttpMethod.put.rawValue
        request.httpBody = patch.asData()
        request.setValue(RequestConstants.putContentType, forHTTPHeaderField: RequestConstants.putContentTypeHeader)

        _ = try await self.networkClient.fetch(from: request)
    }
}

protocol ApiPatch {
    var object: ApiDto { get }
    func asData() -> Data
}
