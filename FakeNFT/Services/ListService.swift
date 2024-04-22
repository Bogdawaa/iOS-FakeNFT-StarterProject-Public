import Foundation

final class ListService<ItemModel: Decodable> {
    private let networkClient: AsyncNetworkClient
    private let nftApiPath: NftListApiPath
    private var sortBy: String?
    private var items: [ItemModel] = []
    private var nextPage = 0
    private var needReload = false

    var itemsCount: Int { items.count }

    init(networkClient: AsyncNetworkClient, nftApiPath: NftListApiPath) {
        self.networkClient = networkClient
        self.nftApiPath = nftApiPath
    }

    func fetchNextPage(sortBy: String?) async throws -> ListServiceResult {
        if self.sortBy != sortBy {
            nextPage = 0
            self.sortBy = sortBy
            needReload = true
        }

        let request = nftApiPath.buildRequest(page: nextPage, sortBy: sortBy)
        let newItems = try await self.networkClient.fetch(from: request, as: [ItemModel].self)
        return addPageData(data: newItems)
    }

    private func addPageData(data: [ItemModel]) -> ListServiceResult {
        let oldCount = itemsCount
        items.append(contentsOf: data)
        nextPage += 1
        let newCount = itemsCount

        if needReload {
            needReload = false
            return .reload
        } else {
            return .update(newIndexes: oldCount..<newCount)
        }
    }

    func item(at index: Int) -> ItemModel {
        items[index]
    }
}

enum ListServiceResult {
    case reload
    case update(newIndexes: Range<Int>)
}

final class EntityService<ItemModel: Decodable> {
    private let networkClient: AsyncNetworkClient

    init(networkClient: AsyncNetworkClient) {
        self.networkClient = networkClient
    }

    func fetch(nftApiPath: NftEntityApiPath) async throws -> ItemModel {
        let request = nftApiPath.buildGetRequest()
        let item = try await self.networkClient.fetch(from: request, as: ItemModel.self)
        return item
    }
}
