//
//  File.swift
//  
//
//  Created by Joe Maghzal on 28/03/2023.
//

import Foundation


public protocol Interceptor {
    func handle(_ error: Error) async
    func callDidStart<Model: Decodable, ErrorModel: Decodable>(_ call: NetworkCall<Model, ErrorModel>) async
    func responseDownloaded<Model: Decodable, ErrorModel: Decodable>(_ response: (Data, URLResponse), for call: NetworkCall<Model, ErrorModel>) async
    func callDidEnd<Model: Decodable, ErrorModel: Decodable>(_ call: NetworkCall<Model, ErrorModel>) async
    func retry<Model: Decodable, ErrorModel: Decodable>(_ call: NetworkCall<Model, ErrorModel>, dueTo error: Error) async -> Bool
}

public struct DefaultInterceptor: Interceptor {
    public func retry<Model, ErrorModel>(_ call: NetworkCall<Model, ErrorModel>, dueTo error: Error) async -> Bool where Model : Decodable, ErrorModel : Decodable, ErrorModel : Error {
        return true
    }
    public func handle(_ error: Error) async {
    }
    public func callDidStart<Model: Decodable, ErrorModel: Decodable>(_ call: NetworkCall<Model, ErrorModel>) async {
    }
    public func responseDownloaded<Model: Decodable, ErrorModel: Decodable>(_ response: (Data, URLResponse), for call: NetworkCall<Model, ErrorModel>) async {
    }
    public func callDidEnd<Model: Decodable, ErrorModel: Decodable>(_ call: NetworkCall<Model, ErrorModel>) async {
    }
}
