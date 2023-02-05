//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

public struct Header {
//MARK: - Properties
    internal var name: String
    internal var value: String
}

//MARK: - Modifiers
public extension Header {
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
    static func custom(name: String, value: String) -> Header {
        return Header(name: name, value: value)
    }
}
