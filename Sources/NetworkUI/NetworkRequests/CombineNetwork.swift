//
//  File.swift
//  
//
//  Created by Joe Maghzal on 11/13/22.
//

import Foundation
import Combine

extension Network {
    public static func requestPublisher<T: EndPoint, Model: Codable>(endPoint: T, model: Model.Type, withLoader: Bool = true, handled: Bool = true) -> AnyPublisher<Model, Error> {
        let request = try! requestBuilder(endPoint: endPoint)
        if withLoader {
            NetworkData.shared.isLoading = true
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                do {
                    return try resultBuilder(result.data, model: Model.self, withLoader: withLoader, request: request)
                }catch {
                    throw errorBuilderPublisher(endPoint: endPoint, error: error, model: model, withLoader: withLoader, handled: handled)
                }
            }.mapError { error in
                return error
            }.eraseToAnyPublisher()
    }
    private static func errorBuilderPublisher<T: EndPoint, Model: Codable>(endPoint: T, error: Error, model: Model.Type, withLoader: Bool, handled: Bool) -> Error {
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
        return error
    }
}
