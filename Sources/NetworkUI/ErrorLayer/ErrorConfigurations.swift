//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

public protocol ErrorConfigurations {
    func shouldDisplay(_ error: Error) -> Bool
    func shouldRetry(_ error: Error) -> Bool
    func handle(_ error: Error)
}

public extension ErrorConfigurations {
    func shouldDisplay(_ error: Error) -> Bool {
        return true
    }
    func shouldRetry(_ error: Error) -> Bool {
        return true
    }
    func handle(_ error: Error) {
    }
}

public protocol Errorable: Identifiable, Error, Equatable, Hashable, Codable {
    var networkError: NetworkError {get}
}

public struct NetworkError: Errorable {
    public var networkError: NetworkError {
        return self
    }
    public var id = UUID()
    public var title: String?
    public var body: String?
    public static let cancelled = NetworkError(title: "NetworkUI Cancelled", body: "NetworkUI Cancelled")
    public static func unnaceptable(status: ResponseStatus) -> Self {
        NetworkError(title: "Unnaceptable Status Code", body: status.description)
    }
}
