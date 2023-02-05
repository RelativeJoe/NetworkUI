//
//  File.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

extension Network {
    nonisolated internal static func request<T: EndPoint, Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel, T>) async throws -> Model {
        do {
            NetworkData.shared.add(call.endPoint.id.description)
            let request = try requestBuilder(endPoint: call.endPoint)
            if call.handler.withLoading {
                await NetworkData.shared.set(loading: true)
            }
            let networkResult = try await URLSession.shared.data(for: request)
            guard !Task.isCancelled else {
                throw NetworkError.cancelled
            }
            let status = ResponseStatus(statusCode: (networkResult.1 as? HTTPURLResponse)?.statusCode ?? 0)
            if let validity = call.validCode, !(try validity(status)) {
                throw NetworkError.unnaceptable(status: status)
            }
            if let map = call.map {
                return try map(status)
            }
            return try await resultBuilder(call: call, request: request, data: networkResult.0)
        }catch {
            return try await errorBuilder(call: call, error: error)
        }
    }
    nonisolated public static func request<T: EndPoint>(for endPoint: T) async throws -> NetworkCall<EmptyData, EmptyData, T> {
        return NetworkCall(endPoint: endPoint)
    }
}
