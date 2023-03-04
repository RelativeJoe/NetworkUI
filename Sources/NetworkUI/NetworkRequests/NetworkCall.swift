//
//  NetworkCall.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public struct NetworkCall<Model: Decodable, ErrorModel: Error & Decodable> {
//MARK: - Properties
    internal var resultModel: Model.Type?
    internal var errorModel: ErrorModel.Type?
    internal var route: any Route
    internal var validCode: ((ResponseStatus) throws -> Bool)?
    internal var map: ((ResponseStatus) throws -> Model)?
    internal var policy = NetworkRetries.always
    internal var decoder: JSONDecoder?
}

//MARK: - Modifiers
public extension NetworkCall {
    func tryDecode<T: Decodable>(using type: T.Type) -> NetworkCall<T, ErrorModel> {
        return NetworkCall<T, ErrorModel>(resultModel: type, errorModel: errorModel, route: route, validCode: validCode, map: nil, policy: policy, decoder: decoder)
    }
    func tryCatch<T: Error & Decodable>(using type: T.Type) -> NetworkCall<Model, T> {
        return NetworkCall<Model, T>(resultModel: resultModel, errorModel: type, route: route, validCode: validCode, map: map, policy: policy, decoder: decoder)
    }
    func validate(_ transform: @escaping (ResponseStatus) throws -> Bool) rethrows -> Self {
        return NetworkCall(resultModel: resultModel, errorModel: errorModel, route: route, validCode: transform, map: map, policy: policy, decoder: decoder)
    }
    func retryPolicy(_ policy: NetworkRetries) -> Self {
        return NetworkCall(resultModel: resultModel, errorModel: errorModel, route: route, validCode: validCode, map: map, policy: policy, decoder: decoder)
    }
    func map<T: Decodable>(_ transform: @escaping (ResponseStatus) throws -> T) rethrows -> NetworkCall<T, ErrorModel> {
        return NetworkCall<T, ErrorModel>(resultModel: nil, errorModel: errorModel, route: route, validCode: validCode, map: transform, policy: policy, decoder: decoder)
    }
    func with<T: JSONDecoder>(decoder: T) -> Self {
        return NetworkCall(resultModel: resultModel, errorModel: errorModel, route: route, validCode: validCode, map: map, policy: policy, decoder: decoder)
    }
    func get() async throws -> Model {
        return try await Network.request(call: self).value
    }
    func task() async throws -> Task<Model, Error> {
        return try await Network.request(call: self)
    }
}
