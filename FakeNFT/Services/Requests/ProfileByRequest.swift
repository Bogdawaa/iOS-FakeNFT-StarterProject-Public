//
//  ProfileByRequest.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 08.04.2024.
//

import Foundation

struct ProfileByRequest: BaseNftRequest {
    var httpMethod: HttpMethod

    var dto: Encodable?
    var httpBody: String?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}
