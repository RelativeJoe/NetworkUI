//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

///NetworkUI: The JSON body of a request
public struct JSON {
//MARK: - Properties
    internal var data: Data?
}

//MARK: - Modifiers
public extension JSON {
///NetworkUI: Configure the body using `Codable`
    static func codable<T: Codable>(object: T, encoder: JSONEncoder = JSONEncoder()) -> JSON {
        let encoder = encoder
        let data = try? encoder.encode(object)
        return JSON(data: data)
    }
///NetworkUI: Configure the body using a dictionary
    static func dictionary(dictionary: Dictionary<String, Any>) -> JSON {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return JSON(data: data)
    }
///NetworkUI: Configure the body using `Data`
    static func data(_ data: Data) -> JSON {
        return JSON(data: data)
    }
}
