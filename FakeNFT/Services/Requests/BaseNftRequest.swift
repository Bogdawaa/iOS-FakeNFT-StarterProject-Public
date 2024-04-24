//
//  BaseNftRequest.swift
//  FakeNFT
//
//  Created by admin on 20.04.2024.
//

import Foundation

protocol BaseNftRequest: NetworkRequest {}

extension BaseNftRequest {
    var secretInjector: (_ request: URLRequest) -> URLRequest {
        return { request in
            var request = request
            request.setValue(RequestConstants.nftToken, forHTTPHeaderField: RequestConstants.nftHeader)
            return request
        }
    }
}
