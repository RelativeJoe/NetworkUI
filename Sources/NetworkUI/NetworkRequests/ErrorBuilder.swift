//
//  File.swift
//  
//
//  Created by Joe Maghzal on 11/13/22.
//

import Foundation

extension Network {
    internal static func errorBuilder<T: EndPoint, Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel, T>, error: Error) async throws -> Model {
        if call.handler.withLoading {
            await NetworkData.shared.set(loading: false)
        }
        switch call.policy {
            case .never:
                guard call.handler.withError, configurations.errorLayer.shouldDisplay(error) else {
                    throw error
                }
                if let networkError = error as? (any Errorable) {
                    NetworkData.shared.set(error: networkError.networkError)
                }else {
                    NetworkData.shared.set(error: NetworkError(title: "Something went wrong!", body: error.localizedDescription))
                }
                throw error
            case .always:
                let retryCount = call.endPoint.retryCount ?? configurations.retryCount
                let currentCount = NetworkData.shared.retries[call.endPoint.id.description] ?? 0
                guard retryCount > currentCount, configurations.errorLayer.shouldRetry(error) else {
                    throw error
                }
                return try await call.get()
            case .custom(let number):
                let currentCount = NetworkData.shared.retries[call.endPoint.id.description] ?? 0
                guard number > currentCount, configurations.errorLayer.shouldRetry(error) else {
                    throw error
                }
                return try await call.get()
        }
    }
}
