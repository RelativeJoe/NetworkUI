//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

protocol NetworkConfigurations {
    var errorLayer: any ErrorConfigurations {get}
    var timeoutInterval: TimeInterval {get}
    var baseURL: URL? {get}
    var retryCount: Int {get}
}

extension NetworkConfigurations {
    var timeoutInterval: TimeInterval {
        90
    }
    var baseURL: URL? {
        nil
    }
    var retryCount: Int {
        1
    }
}
