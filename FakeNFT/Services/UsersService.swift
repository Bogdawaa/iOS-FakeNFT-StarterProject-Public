//
//  UsersService.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 26.03.2024.
//

import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

protocol UsersService {
    func loadUsers(with parametr: SortParametr, completion: @escaping UsersCompletion)
}

final class UsersServiceImpl: UsersService {

    private let networkClient: NetworkClient
    private let storage: UsersStorage
    private let usersOnPage: Int = 10
    private var lastLoadedPage: Int?
    private var currentSortParam = SortParametr.byRating

    init(networkClient: NetworkClient, storage: UsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUsers(with parametr: SortParametr, completion: @escaping UsersCompletion) {
//        if let users = storage.getUsers() {
//            completion(.success(users))
//            return
//        }
        if currentSortParam != parametr {
            lastLoadedPage = nil
            currentSortParam = parametr
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        if lastLoadedPage == nil {
            lastLoadedPage = 1
        } else {
            lastLoadedPage = lastLoadedPage! + 1
        }

        var request = UsersRequest()
        request.sortUsers(by: parametr)
        request.fetchNextPage(nextPage: nextPage, usersOnPage: usersOnPage)

        networkClient.send(request: request, type: [User].self) { [weak storage] result in
            switch result {
            case .success(let users):
                storage?.saveUsers(users)
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
