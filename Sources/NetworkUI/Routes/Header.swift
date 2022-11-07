//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

public enum Authorisation {
    case bearer(token: String)
}

public enum ContentType: String {
    case applicationJson = "application/json"
}

public struct Header {
    public var name: String
    public var value: String
    public static func authorization(_ method: Authorisation) -> Header {
        switch method {
            case .bearer(let token):
                return Header(name: "Authorization", value: "Bearer \(token)")
        }
    }
    public static func content(type: ContentType) -> Header {
        return Header(name: "Content-Type", value: type.rawValue)
    }
    public static func language(_ language: String) -> Header {
        return Header(name: "Accepts-Language", value: language)
    }
}
