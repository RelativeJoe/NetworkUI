//
//  File.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

extension Network {
    internal func request<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>) async throws -> Model {
        try Task.checkCancellation()
        await configurations.interceptor.callDidStart(call)
        let request = try requestBuilder(route: call.route)
        let networkResult = try await URLSession.shared.data(for: request)
        await configurations.interceptor.responseDownloaded(networkResult, for: call)
        try Task.checkCancellation()
        return try await resultBuilder(call: call, request: request, data: networkResult)
    }
    internal func retryingRequest<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>) async throws -> Task<Model, Error> {
        Task(priority: .background) {
            let maxRetryCount = await call.maxRetryCount()
            if maxRetryCount > 0 {
                for _ in 0..<maxRetryCount {
                    do {
                        return try await request(call: call)
                    }catch {
                        print(error)
                        continue
                    }
                }
            }
            do {
                return try await request(call: call)
            }catch {
                print(error)
                await configurations.interceptor.callDidEnd(call)
                await configurations.interceptor.handle(error)
                throw error
            }
        }
    }
    public func request<T: Route>(for route: T) -> NetworkCall<EmptyData, EmptyData> {
        return NetworkCall(route: route, interface: self)
    }
}
