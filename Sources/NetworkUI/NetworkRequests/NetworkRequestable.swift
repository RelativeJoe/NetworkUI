//
//  NetworkRequestable.swift
//  
//
//  Created by Joe Maghzal on 08/09/2023.
//

import Foundation

public protocol NetworkRequestable: Actor {
    var session: URLSession {get set}
    var configurations: NetworkConfigurations {get set}
    func request<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>, requestCount: Int) async throws -> Model
    func retryingRequest<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>) async throws -> Model
    func request<T: Route>(for route: T) -> NetworkCall<EmptyData, EmptyData>
}
