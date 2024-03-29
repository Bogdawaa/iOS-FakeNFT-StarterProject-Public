//
//  UsersStorage.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 26.03.2024.
//

import Foundation

protocol UsersStorage: AnyObject {
    func saveUsers(_ users: [User])
    func getUsers() -> [User]?
}

// Пример простого класса, который сохраняет данные из сети
final class UsersStorageImpl: UsersStorage {
    private var storage: [User] = []

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveUsers(_ users: [User]) {
        syncQueue.async { [weak self] in
            self?.storage = users
        }
    }

    func getUsers() -> [User]? {
        syncQueue.sync {
            storage
        }
    }
}
