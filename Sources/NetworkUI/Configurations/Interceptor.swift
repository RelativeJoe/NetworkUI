//
//  File.swift
//  
//
//  Created by Joe Maghzal on 28/03/2023.
//

import Foundation

public protocol Interceptor {
    func didStart<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with request: URLRequest) async
    func didEnd<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with response: (Data, URLResponse)) async
    func handle<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with error: Error) async
    func shouldRetry<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with error: Error, count: Int) async -> Bool
}

public struct DefaultInterceptor: Interceptor {
    public func didStart<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with request: URLRequest) async {
    }
    public func didEnd<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with response: (Data, URLResponse)) async {
    }
    public func handle<Model: Decodable, ErrorModel: Decodable>(call: NetworkCall<Model, ErrorModel>, with error: Error) async {
    }
    public func shouldRetry<Model, ErrorModel>(call: NetworkCall<Model, ErrorModel>, with error: Error, count: Int) async -> Bool {
        return true
    }
}
