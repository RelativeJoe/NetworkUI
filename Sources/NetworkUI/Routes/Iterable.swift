//
//  File.swift
//  
//
//  Created by Joe Maghzal on 10/06/2023.
//

import Foundation

public protocol Iterable: URLable {
    var nonNilProperties: [String: CustomStringConvertible] {get}
    var parameters: [URLQueryItem] {get}
}

public extension Iterable {
    var nonNilProperties: [String: CustomStringConvertible] {
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            return [:]
        }
        return mirror.children.reduce(into: [:]) { partialResult, item in
            guard case Optional<CustomStringConvertible>.some = item.value, let property = item.label else {return}
            partialResult[property] = item.value as? CustomStringConvertible
        }
    }
    var parameters: [URLQueryItem] {
        return nonNilProperties.reduce(into: [URLQueryItem]()) { partialResult, item in
            partialResult.append(URLQueryItem(name: item.key, value: item.value.description))
        }
    }
}
