//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

public protocol ErrorConfigurations {
    func shouldDisplay(_ error: Error) -> Bool
    func shouldRetry(_ error: Error) -> Int?
    func handle(_ error: Error)
}

public extension ErrorConfigurations {
    func shouldDisplay(_ error: Error) -> Bool {
        return true
    }
    func shouldRetry(_ error: Error) -> Int? {
        return nil
    }
    func handle(_ error: Error) {
    }
}

public struct NetworkError: Error, Identifiable, Equatable, Hashable, Codable {
    public var id = UUID()
    public var title: String?
    public var body: String?
}
