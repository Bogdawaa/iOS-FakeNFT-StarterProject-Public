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

    var endpoint: URL? {
        // TODO: доделать загрузку данных по страницам
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        //        if lastLoadedPage == nil {
//            lastLoadedPage = 1
//        }
        let parametrUsersOnPage: String = "&page=\(nextPage)&size=\(15)"
        return URL(string: "\(RequestConstants.baseURL)/api/v1/users\(parametrSortBy)\(parametrUsersOnPage)")
    }

    init() {
        sortUsers(by: parametr)
    }

    mutating func sortUsers(by parametr: SortParametr) {
        switch parametr {
        case .byName:
            parametrSortBy = "?sortBy=name&order=asc"
        case .byRating:
            parametrSortBy = "?sortBy=rating&order=desc"
        }
    }
}
