//
//  File.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public extension Network {
    func request<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>, requestCount: Int) async throws -> Model {
        try Task.checkCancellation()
        let request = try requestBuilder(route: call.route)
        await configurations.interceptor.didStart(call: call, with: request)
        RequestLogger.start(request: request, count: requestCount)
        let networkResult = try await session.data(for: request)
        try Task.checkCancellation()
        await configurations.interceptor.didEnd(call: call, with: networkResult)
        return try await resultBuilder(call: call, request: request, response: networkResult)
    }
    func retryingRequest<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>) async throws -> Model {
        let maxRetryCount = await call.maxRetryCount(configurationCount: configurations.retryCount)
        if maxRetryCount > 0 {
            for count in 0..<maxRetryCount {
                do {
                    return try await request(call: call, requestCount: count)
                }catch {
                    if await configurations.interceptor.shouldRetry(call: call, with: error, count: count) {
                        continue
                    }else {
                        throw error
                    }
                }
            }
        }
        do {
            return try await request(call: call, requestCount: maxRetryCount)
        }catch {
            await configurations.interceptor.handle(call: call, with: error)
            throw error
        }
    }
///NetworkUI: Build a request using a `Route`
    func request<T: Route>(for route: T) -> NetworkCall<EmptyData, EmptyData> {
        return NetworkCall(route: route, interface: self)
    }
}
