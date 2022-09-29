//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

protocol EndPoint {
    var baseURL: URL? {get}
    var route: String {get}
    var method: RequestMethod {get}
    var body: JSON? {get}
    var headers: [Header] {get}
    var retryCount: Int? {get}
    var id: CustomStringConvertible {get}
}

extension EndPoint {
    var baseURL: URL? {
        return nil
    }
    var headers: [Header] {
        return []
    }
    var retryCount: Int? {
        return nil
    }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
