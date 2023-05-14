//
//  File.swift
//  
//
//  Created by Joe Maghzal on 11/13/22.
//

import Foundation

extension Network {
    internal func errorBuilder<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>, error: Error) async throws -> Model {
        await configurations.interceptor.handle(error)
        switch call.policy {
            case .never:
                NetworkData.remove(call.route.id)
                throw error
            case .always:
                let retryCount = call.route.retryCount ?? configurations.retryCount
                let currentCount = NetworkData.value(for: call.route.id)
                guard retryCount > currentCount, configurations.interceptor.shouldRetry(error) else {
                    throw error
                }
                return try await call.get()
            case .custom(let number):
                let currentCount = NetworkData.value(for: call.route.id)
                guard number > currentCount, configurations.interceptor.shouldRetry(error) else {
                    throw error
                }
                return try await call.get()
        }
    }
}
