//
//  File.swift
//  
//
//  Created by Joe Maghzal on 11/13/22.
//

import Foundation

internal extension Network {
    @available(iOS 15.0, macOS 12.0, *)
    @MainActor static func errorBuilder<T: EndPoint, Model: Codable>(endPoint: T, error: Error, model: Model.Type, withLoader: Bool, errorHandler: Bool) async -> BaseResponse<Model> {
        if withLoader {
            NetworkData.shared.isLoading = false
        }
        guard let networkError = error as? NetworkError else {
            return BaseResponse.error(nil)
        }
        let retryCount = endPoint.retryCount ?? configurations.retryCount
        let currentCount = NetworkData.shared.retries[endPoint.id.description] ?? 0
        if (configurations.errorLayer.shouldRetry(networkError) != nil) && retryCount > currentCount {
            NetworkData.shared.retries[endPoint.id.description]! += 1
            return await request(endPoint: endPoint, model: model, errorHandler: errorHandler, withLoader: withLoader)
        }else {
            NetworkData.shared.retries.removeValue(forKey: endPoint.id.description)
        }
        if errorHandler && configurations.errorLayer.shouldDisplay(networkError) {
            NetworkData.shared.error = networkError
        }
        return BaseResponse.error(networkError)
    }
    @available(iOS 15.0, macOS 12.0, *)
    @MainActor static func request<T: EndPoint, Model: Codable>(endPoint: T, model: Model.Type, errorHandler: Bool = true, withLoader: Bool = true) async -> BaseResponse<Model> {
        do {
            NetworkData.shared.retries[endPoint.id.description] = 1
            let request = try requestBuilder(endPoint: endPoint)
            if withLoader {
                NetworkData.shared.isLoading = true
            }
            let networkResult = try await URLSession.shared.data(for: request)
            return try resultBuilder(networkResult.0, model: model, withLoader: withLoader)
        }catch {
            return await errorBuilder(endPoint: endPoint, error: error, model: model, withLoader: withLoader, errorHandler: errorHandler)
        }
    }
}
