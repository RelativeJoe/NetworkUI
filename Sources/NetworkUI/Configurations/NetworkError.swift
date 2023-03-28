//
//  File.swift
//  
//
//  Created by Joe Maghzal on 04/03/2023.
//

import Foundation

public protocol Errorable: Identifiable, Error, Equatable, Hashable, Codable {
    var networkError: NetworkError {get}
}

public struct NetworkError: Errorable {
    //MARK: - Properties
    public var id = UUID()
    public var title: String?
    public var body: String?
    //MARK: - Initializer
    public init(title: String? = nil, body: String? = nil) {
        self.title = title
        self.body = body
    }
    //MARK: - Mappings
    public static let cancelled = NetworkError(title: "NetworkUI Cancelled", body: "NetworkUI Cancelled")
    public static func unnaceptable(status: ResponseStatus) -> Self {
        NetworkError(title: "Unnaceptable Status Code", body: status.description)
    }
    public var networkError: NetworkError {
        return self
    }
}
