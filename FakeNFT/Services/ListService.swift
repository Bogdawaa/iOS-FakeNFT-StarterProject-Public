import Foundation

final class ListService<ItemModel: ApiDto> {
    private let networkClient: AsyncNetworkClient
    private var pathIds: PathIds = .empty
    private var sortBy: String?
    private var items: [ItemModel] = []
    private var nextPage = 0
    private var needReload = false

    var itemsCount: Int { items.count }

    init(networkClient: AsyncNetworkClient) {
        self.networkClient = networkClient
    }

    func fetchNextPage(sortBy: String?, pathIds: PathIds = .empty) async throws -> ListServiceResult {
        if self.pathIds != pathIds {
            nextPage = 0
            self.pathIds = pathIds
            needReload = true
        }

        if self.sortBy != sortBy {
            nextPage = 0
            self.sortBy = sortBy
            needReload = true
        }

        let request = ItemModel.listRequest(pathIds: pathIds, page: nextPage, sortBy: sortBy)

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
