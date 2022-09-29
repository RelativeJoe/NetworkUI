//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

enum Authorisation {
    case bearer(token: String)
}
enum ContentType: String {
    case applicationJson = "application/json"
}
struct Header {
    var name: String
    var value: String
    static func authorization(_ method: Authorisation) -> Header {
        switch method {
            case .bearer(let token):
                return Header(name: "Authorization", value: "Bearer \(token)")
        }
    }
    static func content(type: ContentType) -> Header {
        return Header(name: "Content-Type", value: type.rawValue)
    }
    static func language(_ language: String) -> Header {
        return Header(name: "Accepts-Language", value: language)
    }
}
