//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

public struct JSON {
//MARK: - Propertirs
    internal var data: Data?
}

//MARK: - Modifiers
public extension JSON {
    static func codable<T: Codable>(object: T, encoder: JSONEncoder? = nil) -> JSON {
        let encoder = encoder ?? JSONEncoder()
        let data = try? encoder.encode(object)
        return JSON(data: data)
    }
    static func dictionary(dictionary: Dictionary<String, Any>) -> JSON {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return JSON(data: data)
    }
    static func data(_ data: Data) -> JSON {
        return JSON(data: data)
    }
}
