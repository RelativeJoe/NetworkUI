//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

public protocol NetworkConfigurations {
    var errorLayer: ErrorConfigurations {get}
    var timeoutInterval: TimeInterval {get}
    var baseURL: URL? {get}
    var retryCount: Int {get}
    func reprocess(url: URL?) -> URL?
}

public extension NetworkConfigurations {
    var timeoutInterval: TimeInterval {
        90
    }
    var baseURL: URL? {
        nil
    }
    var retryCount: Int {
        1
    }
    func reprocess(url: URL?) -> URL? {
        return url
    }
}
