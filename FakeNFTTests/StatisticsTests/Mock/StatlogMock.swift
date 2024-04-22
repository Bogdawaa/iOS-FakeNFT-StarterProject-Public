//
//  StatlogMock.swift
//  FakeNFTTests
//
//  Created by Bogdan Fartdinov on 17.04.2024.
//

import Foundation
@testable import FakeNFT

class StatlogMock: StatLog {
    var reportCalled = false
    
    func report<T>(from screen: T.Type, event: FakeNFT.LogEvent) {
        reportCalled = true
    }
}
