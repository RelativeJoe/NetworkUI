//
//  File.swift
//  
//
//  Created by Joe Maghzal on 10/06/2023.
//

import Foundation

public protocol Iterable: URLable {
    var parameters: [URLQueryItem] {get}
}

public extension Iterable {
    var parameters: [URLQueryItem] {
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            return []
        }
        return mirror.children.reduce(into: [URLQueryItem]()) { partialResult, item in
            guard case Optional<CustomStringConvertible>.some = item.value, let property = item.label else {return}
            partialResult.append(URLQueryItem(name: property, value: (item.value as? CustomStringConvertible)?.description))
        }
    }
}
