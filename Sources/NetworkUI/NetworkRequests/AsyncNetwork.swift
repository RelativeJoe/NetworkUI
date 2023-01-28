//
//  File.swift
//  
//
//  Created by Joe Maghzal on 11/13/22.
//

import Foundation

extension Network {
    @MainActor internal static func errorBuilder<T: EndPoint, Model: Codable>(endPoint: T, error: Error, model: Model.Type, withLoader: Bool, handled: Bool) async throws -> Model {
        let retryCount = endPoint.retryCount ?? configurations.retryCount
        let currentCount = NetworkData.shared.retries[endPoint.id.description] ?? 0
        if (configurations.errorLayer.shouldRetry(error) != nil) && retryCount > currentCount {
            NetworkData.shared.retries[endPoint.id.description] = (NetworkData.shared.retries[endPoint.id.description] ?? 0) + 1
            return try await request(for: endPoint, model: Model.self, handled: handled, withLoader: withLoader)
        }
        NetworkData.shared.retries.removeValue(forKey: endPoint.id.description)
        if handled && configurations.errorLayer.shouldDisplay(error) {
            if let networkError = error as? NetworkError {
                NetworkData.shared.error = networkError
            }else {
                NetworkData.shared.error = NetworkError(title: "Something went wrong!", body: error.localizedDescription)
            }
        }
        if withLoader {
            NetworkData.shared.isLoading = false
        }
        throw error
    }
    @MainActor public static func request<T: EndPoint, Model: Codable>(for endPoint: T, model: Model.Type, handled: Bool = true, withLoader: Bool = true) async throws -> Model {
        do {
            NetworkData.shared.retries[endPoint.id.description] = (NetworkData.shared.retries[endPoint.id.description] ?? -1) + 1
            let request = try requestBuilder(endPoint: endPoint)
            if withLoader {
                NetworkData.shared.isLoading = true
            }
            let networkResult = try await URLSession.shared.data(for: request)
            return try resultBuilder(networkResult.0, model: Model.self, withLoader: withLoader, request: request)
        }catch {
            return try await errorBuilder(endPoint: endPoint, error: error, model: Model.self, withLoader: withLoader, handled: handled)
        }
    }
}
