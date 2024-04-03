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

struct UsersRequest: BaseNftRequest {

    private var parametr = SortParametr.byRating
    private var parametrSortBy: String = ""

    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/users?\(parametrSortBy)")
    }

    init() {
        sortUsers(by: parametr)
    }

    mutating func sortUsers(by parametr: SortParametr) {
        switch parametr {
        case .byName:
            parametrSortBy = "sortBy=name&order=asc"
        case .byRating:
            parametrSortBy = "sortBy=rating&order=desc"
        }
    }
}
