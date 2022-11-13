//
//  File.swift
//  
//
//  Created by Joe Maghzal on 11/13/22.
//

import Foundation
import Combine

extension Network {
    @MainActor static func requestPublisher<T: EndPoint, Model: Codable>(endPoint: T, model: Model.Type, errorHandler: Bool = true, withLoader: Bool = true) -> AnyPublisher<BaseResponse<Model>, NetworkError> {
        let request = try! requestBuilder(endPoint: endPoint)
        if withLoader {
            NetworkData.shared.isLoading = true
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                do {
                    return try resultBuilder(result.data, model: model, withLoader: withLoader)
                }catch {
                    throw errorBuilderPublisher(endPoint: endPoint, error: error, model: model, withLoader: withLoader, errorHandler: errorHandler)
                }
            }.mapError { error in
                return error as? NetworkError ?? NetworkError(title: "Error", body: "Unknown Error")
            }.eraseToAnyPublisher()
    }
    @MainActor private static func errorBuilderPublisher<T: EndPoint, Model: Codable>(endPoint: T, error: Error, model: Model.Type, withLoader: Bool, errorHandler: Bool) -> NetworkError {
        if withLoader {
            NetworkData.shared.isLoading = false
        }
        guard let networkError = error as? NetworkError else {
            return NetworkError(title: "Error", body: "Unknown Error")
        }
        let retryCount = endPoint.retryCount ?? configurations.retryCount
        let currentCount = NetworkData.shared.retries[endPoint.id.description] ?? 0
        if (configurations.errorLayer.shouldRetry(networkError) != nil) && retryCount > currentCount {
            NetworkData.shared.retries[endPoint.id.description]! += 1
//            return await request(endPoint: endPoint, model: model, errorHandler: errorHandler, withLoader: withLoader)
        }else {
            NetworkData.shared.retries.removeValue(forKey: endPoint.id.description)
        }
        if errorHandler && configurations.errorLayer.shouldDisplay(networkError) {
            NetworkData.shared.error = networkError
        }
        return networkError
    }
}
