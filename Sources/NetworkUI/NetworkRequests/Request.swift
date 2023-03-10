//
//  File.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

extension Network {
    nonisolated internal static func request<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>) async throws -> Task<Model, Error> {
        Task.detached { () -> Model in
            do {
                NetworkData.add(call.route.id)
                let request = try requestBuilder(route: call.route)
                let networkResult = try await URLSession.shared.data(for: request)
                guard !Task.isCancelled else {
                    throw NetworkError.cancelled
                }
                return try await resultBuilder(call: call, request: request, data: networkResult)
            }catch {
                return try await errorBuilder(call: call, error: error)
            }
        }
    }
    nonisolated public static func request<T: Route>(for route: T) async throws -> NetworkCall<EmptyData, EmptyData> {
        return NetworkCall(route: route)
    }
}
