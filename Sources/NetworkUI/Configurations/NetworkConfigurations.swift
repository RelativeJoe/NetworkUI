//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

public protocol NetworkConfigurations {
    var interceptor: Interceptor {get}
    var timeoutInterval: TimeInterval {get}
    var baseURL: URL? {get}
    var retryCount: Int {get}
    var cachePolicy: URLRequest.CachePolicy {get}
    var decoder: JSONDecoder {get}
    var encoder: JSONEncoder {get}
    func reprocess(url: URL?) -> URL?
}

public extension NetworkConfigurations {
    var timeoutInterval: TimeInterval {
        return 90
    }
    var baseURL: URL? {
        return nil
    }
    var retryCount: Int {
        return 1
    }
    var cachePolicy: URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
    var decoder: JSONDecoder {
        return JSONDecoder()
    }
    var encoder: JSONEncoder {
        return JSONEncoder()
    }
    func reprocess(url: URL?) -> URL? {
        return url
    }
    var interceptor: Interceptor {
        return DefaultInterceptor()
    }
}

public struct DefaultConfigurations: NetworkConfigurations {
}
