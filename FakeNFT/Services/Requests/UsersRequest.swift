//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 26.03.2024.
//

import Foundation

enum SortParametr {
    case byName, byRating
}

struct UsersRequest: NetworkRequest {

    private var parametr = SortParametr.byName
    private var parametrURL: String = ""

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users\(parametrURL)")
    }

    init() {
        sortUsers(by: parametr)
    }

    mutating func sortUsers(by parametr: SortParametr) {
        switch parametr {
        case .byName:
            parametrURL = "?sortBy=name&order=asc"
        case .byRating:
            parametrURL = "?sortBy=rating&order=desc"
        }
    }
}
