//
//  SortModel.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import Foundation

struct SortModel {
    let completionPrice: (() -> Void)?
    let completionRating: (() -> Void)?
    let completionName: (() -> Void)?
}
