//
//  NetworkCall.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

///NetworkUI: The handlers of a request
public struct NetworkCall<Model: Decodable, ErrorModel: Error & Decodable> {
//MARK: - Properties
    internal var resultModel: Model.Type?
    internal var errorModel: ErrorModel.Type?
    internal var route: any Route
    internal var validCode: ((ResponseStatus) throws -> Bool)?
    internal var map: ((ResponseStatus) throws -> Model)?
    internal var policy = NetworkRetries.always
    internal var decoder: JSONDecoder?
    internal var interface: NetworkRequestable
//MARK: - Functions
    internal func maxRetryCount(configurationCount: Int) async -> Int {
        switch policy {
            case .never:
                return 0
            case .always:
                return route.retryCount ?? configurationCount
            case .custom(let count):
                return count
        }
    }
}

//MARK: - Modifiers
public extension NetworkCall {
///NetworkUI: Decode the returned request data using a `Decodable` type
    func tryDecode<T: Decodable>(using type: T.Type) -> NetworkCall<T, ErrorModel> {
        return NetworkCall<T, ErrorModel>(resultModel: type, errorModel: errorModel, route: route, validCode: validCode, map: nil, policy: policy, decoder: decoder, interface: interface)
    }
///NetworkUI: Decode the returned request data or error using a `Decodable` type
    func tryCatch<T: Error & Decodable>(using type: T.Type) -> NetworkCall<Model, T> {
        return NetworkCall<Model, T>(resultModel: resultModel, errorModel: type, route: route, validCode: validCode, map: map, policy: policy, decoder: decoder, interface: interface)
    }
///NetworkUI: Validate the `ResponseStatus`of the request
    func validate(_ transform: @escaping (ResponseStatus) throws -> Bool) rethrows -> Self {
        return NetworkCall(resultModel: resultModel, errorModel: errorModel, route: route, validCode: transform, map: map, policy: policy, decoder: decoder, interface: interface)
    }
///NetworkUI: Configure the retry policy of the request
    func retryPolicy(_ policy: NetworkRetries) -> Self {
        return NetworkCall(resultModel: resultModel, errorModel: errorModel, route: route, validCode: validCode, map: map, policy: policy, decoder: decoder, interface: interface)
    }
///NetworkUI: Map the `ResponseStatus`of the request
    func map<T: Decodable>(_ transform: @escaping (ResponseStatus) throws -> T) rethrows -> NetworkCall<T, ErrorModel> {
        return NetworkCall<T, ErrorModel>(resultModel: nil, errorModel: errorModel, route: route, validCode: validCode, map: transform, policy: policy, decoder: decoder, interface: interface)
    }
///NetworkUI: Use a custom `JSONDecoder` to handle the decoding of the data
    func with<T: JSONDecoder>(decoder: T) -> Self {
        return NetworkCall(resultModel: resultModel, errorModel: errorModel, route: route, validCode: validCode, map: map, policy: policy, decoder: decoder, interface: interface)
    }
///NetworkUI: Start the request & return the `Model`
    func get() async throws -> Model {
        return try await interface.retryingRequest(call: self).value
    }
///NetworkUI: Start the request and return its `Task`
    func task() async throws -> Task<Model, Error> {
        return try await interface.retryingRequest(call: self)
    }
}
