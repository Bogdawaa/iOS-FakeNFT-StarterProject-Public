//
//  ServiceMock.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 16.04.2024.
//

import Foundation
@testable import FakeNFT

enum ServiceMockError: Error {
    case loadError(String)
}

class ServiceMock: UsersService {
    
    var loadUsersCalled = false
    var loadUsersFailed = false
    var user1 = User(
        id: "mockId1",
        name: "mockName1",
        avatar: "mockAvatar1",
        rating: "mockRating1",
        website: "mockWebsite1",
        nfts: [],
        description: "mockDescription1"
    )
    var user2 = User(
        id: "mockId2",
        name: "mockName2",
        avatar: "mockAvatar2",
        rating: "mockRating2",
        website: "mockWebsite2",
        nfts: [],
        description: "mockDescription2"
    )
    
    func loadUsers(with parametr: FakeNFT.SortParametr, completion: @escaping FakeNFT.UsersCompletion) {
        loadUsersCalled = true
        if loadUsersFailed {
            completion(.failure(ServiceMockError.loadError("load error")))
        } else {
            let users: [User] = [user1, user2]
            completion(.success(users))
        }
    }
}
