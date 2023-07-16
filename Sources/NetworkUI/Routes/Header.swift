//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

///NetworkUI: The headers of a request
public struct Header {
//MARK: - Properties
    internal var name: String
    internal var value: String
}

//MARK: - Modifiers
public extension Header {
///NetworkUI: Creates an authorization header
    static func authorization(_ method: Authorisation) -> Header {
        switch method {
            case .bearer(let token):
                return Header(name: "Authorization", value: "Bearer \(token)")
        }
    }
///NetworkUI: Creates a content type header
    static func content(type: ContentType) -> Header {
        return Header(name: "Content-Type", value: type.rawValue)
    }
///NetworkUI: Creates a language header
    static func language(_ language: String) -> Header {
        return Header(name: "Accepts-Language", value: language)
    }
///NetworkUI: Creates a custom header
    static func custom(name: String, value: String) -> Header {
        return Header(name: name, value: value)
    }
}
