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

public protocol Errorable {
    var title: String? {get}
    var body: String? {get}
}

public struct NetworkError: Error, Identifiable, Equatable, Hashable, Codable, Errorable {
    public var id = UUID()
    public var title: String?
    public var body: String?
    public static let cancelled = NetworkError(title: "NetworkUI Cancelled", body: "NetworkUI Cancelled")
    public static func unnaceptable(status: ResponseStatus) -> Self {
        NetworkError(title: "Unnaceptable Status Code", body: status.description)
    }
}
