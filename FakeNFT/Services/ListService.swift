import Foundation

final class ListService<ItemModel: ApiDto> {
    private let networkClient: AsyncNetworkClient
    private var pathIds: PathIds = .empty
    private var sortBy: String?
    private var items: [ItemModel] = []
    private var nextPage = 0
    private var needReload = false
    private var loadingTask: Task<[ItemModel], Error>?

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

        if let loadingTask, !loadingTask.isCancelled {
            throw CancellationError()
        }

        let request = ItemModel.listRequest(pathIds: pathIds, page: nextPage, sortBy: sortBy)
        loadingTask = Task {
            return try await self.networkClient.fetch(from: request, as: [ItemModel].self)
        }
        let newItems = try await loadingTask!.value
        loadingTask = nil
        return addNew(items: newItems)
    }

    private func reset() {
        nextPage = 0
        items = []
        needReload = true
        loadingTask?.cancel()
        loadingTask = nil
    }

    private func addNew(items newItems: [ItemModel]) -> ListServiceResult {
        let oldCount = itemsCount
        items.append(contentsOf: newItems)
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
