//
//  CurrencyModel.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

typealias CurrencyModel = [CurrencyModelElement]

struct CurrencyModelElement: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}
