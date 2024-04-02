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

    private var lastLoadedPage: Int?

    private var parametr = SortParametr.byRating
    private var parametrSortBy: String = ""
    private var parametrUsersOnPage: String = ""

    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/users?\(parametrSortBy)\(parametrUsersOnPage)")
    }

    init() {
        sortUsers(by: parametr)
    }

    mutating func fetchNextPage(nextPage: Int, usersOnPage: Int) {
        parametrUsersOnPage = "&page=\(nextPage)&size=\(usersOnPage)"
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
