//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

struct JSON {
    var data: Data?
    static func codable<T: Codable>(object: T) -> JSON {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        return JSON(data: data)
    }
    static func dictionary(dictionary: Dictionary<String, Any>) -> JSON {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        let encoder = JSONEncoder()
        return JSON(data: data)
    }
}
