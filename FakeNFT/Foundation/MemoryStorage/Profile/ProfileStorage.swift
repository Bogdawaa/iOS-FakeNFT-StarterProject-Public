//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 08.04.2024.
//

import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: Profile)
    func getProfile(with id: String) -> Profile?
}

final class ProfileStorageImpl: ProfileStorage {

    private var storage: [String: Profile] = [:]

    private let syncQueue = DispatchQueue(label: "sync-profile-queue")

    func saveProfile(_ profile: Profile) {
        syncQueue.async { [weak self] in
            self?.storage[profile.id] = profile
        }
    }

    func getProfile(with id: String) -> Profile? {
        syncQueue.sync {
            storage[id]
        }
    }
}
