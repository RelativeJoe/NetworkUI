//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

internal class NetworkData {
//MARK: - Properties
    private static let shared = NetworkData()
    internal var retries: [String: Int] = [:]
//MARK: - Initializer
    private init() {
    }
//MARK: - Functions
    static internal func add(_ id: CustomStringConvertible) {
        if let oldRetries = shared.retries[id.description] {
            shared.retries[id.description] = oldRetries + 1
        }else {
            shared.retries[id.description] = 0
        }
    }
    static internal func remove(_ id: CustomStringConvertible) {
        shared.retries.removeValue(forKey: id.description)
    }
    static internal func value(for id: CustomStringConvertible) -> Int {
        return shared.retries[id.description] ?? 0
    }
}
