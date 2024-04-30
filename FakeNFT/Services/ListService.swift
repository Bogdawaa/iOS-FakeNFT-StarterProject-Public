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
            self.pathIds = pathIds
            reset()
        }
        if self.sortBy != sortBy {
            self.sortBy = sortBy
            reset()
        }

        let request = ItemModel.listRequest(pathIds: pathIds, page: nextPage, sortBy: sortBy)

        let newItems = try await self.networkClient.fetch(from: request, as: [ItemModel].self)
        return addPageData(data: newItems)
    }

    private func reset() {
        nextPage = 0
        items = []
        needReload = true
    }

    private func addPageData(data: [ItemModel]) -> ListServiceResult {
        let oldCount = itemsCount
        items.append(contentsOf: data)
        let newCount = itemsCount

        if oldCount != newCount {
            nextPage += 1
        }

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
