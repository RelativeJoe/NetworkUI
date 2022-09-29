//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

public struct JSON {
    public var data: Data?
    public static func codable<T: Codable>(object: T) -> JSON {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        return JSON(data: data)
    }
    public static func dictionary(dictionary: Dictionary<String, Any>) -> JSON {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        let encoder = JSONEncoder()
        return JSON(data: data)
    }
}
