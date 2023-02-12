//
//  NetworkCall.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public struct NetworkCall<Model: Decodable, ErrorModel: Error & Decodable, Route: EndPoint> {
//MARK: - Properties
    internal var handler = NetworkHandler.all
    internal var resultModel: Model.Type?
    internal var errorModel: ErrorModel.Type?
    internal var endPoint: Route
    internal var validCode: ((ResponseStatus) throws -> Bool)?
    internal var map: ((ResponseStatus) throws -> Model)?
    internal var policy = NetworkRetries.always
}

//MARK: - Modifiers
public extension NetworkCall {
    func tryDecode<T: Decodable>(using type: T.Type) -> NetworkCall<T, ErrorModel, Route> {
        return NetworkCall<T, ErrorModel, Route>(handler: handler, resultModel: type, errorModel: errorModel, endPoint: endPoint, validCode: validCode, map: nil, policy: policy)
    }
    func tryCatch<T: Error & Decodable>(using type: T.Type) -> NetworkCall<Model, T, Route> {
        return NetworkCall<Model, T, Route>(handler: handler, resultModel: resultModel, errorModel: type, endPoint: endPoint, validCode: validCode, map: map, policy: policy)
    }
    func handling(_ handler: NetworkHandler) -> Self {
        return NetworkCall(handler: handler, resultModel: resultModel, errorModel: errorModel, endPoint: endPoint, validCode: validCode, map: map, policy: policy)
    }
    func validate(_ transform: @escaping (ResponseStatus) throws -> Bool) rethrows -> Self {
        return NetworkCall(handler: handler, resultModel: resultModel, errorModel: errorModel, endPoint: endPoint, validCode: transform, map: map, policy: policy)
    }
    func retryPolicy(_ policy: NetworkRetries) -> Self {
        return NetworkCall(handler: handler, resultModel: resultModel, errorModel: errorModel, endPoint: endPoint, validCode: validCode, map: map, policy: policy)
    }
    func map<T: Decodable>(_ transform: @escaping (ResponseStatus) throws -> T) rethrows -> NetworkCall<T, ErrorModel, Route> {
        return NetworkCall<T, ErrorModel, Route>(handler: handler, resultModel: nil, errorModel: errorModel, endPoint: endPoint, validCode: validCode, map: transform, policy: policy)
    }
    func get() async throws -> Model {
        return try await Network.request(call: self).value
    }
    func task() async throws -> Task<Model, Error> {
        return try await Network.request(call: self)
    }
}
