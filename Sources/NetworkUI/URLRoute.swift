//
//  File.swift
//  
//
//  Created by Joe Maghzal on 13/01/2023.
//

import Foundation

public protocol URLable {
}

public struct URLRoute {
    internal var components: [URLable]
    internal var postComponents: [URLable]
    public init(from item: URLable) {
        self.components = [item]
        self.postComponents = []
    }
    internal init(components: [URLable], postComponents: [URLable]) {
        self.components = components
        self.postComponents = postComponents
    }
    public func with(_ component: URLable, isPost: Bool) -> Self {
        var newComponents = components
        var newPostComponents = postComponents
        if isPost {
            newComponents.append(component)
        }else {
            newPostComponents.append(component)
        }
        return URLRoute(components: newComponents, postComponents: postComponents)
    }
    public func with(_ item: Self, isPost: Bool) -> Self {
        var newComponents = components
        var newPostComponents = postComponents
        if isPost {
            newPostComponents.append(contentsOf: item.components)
        }else {
            newComponents.append(contentsOf: item.components)
        }
        return URLRoute(components: newComponents, postComponents: newPostComponents)
    }
    internal func applied(to url: URL?) -> URL? {
        var newURL = url
        components.forEach { item in
            if let string = item as? String {
                newURL?.append(path: string)
            }else if let parameter = item as? URLQueryItem {
                newURL?.append(queryItems: [parameter])
            }
        }
        return newURL
    }
    internal func reproccessed(with url: URL?) -> URL? {
        var newURL = url
        postComponents.forEach { item in
            if let string = item as? String {
                newURL?.append(path: string)
            }else if let parameter = item as? URLQueryItem {
                newURL?.append(queryItems: [parameter])
            }
        }
        return newURL
    }
}

extension String: URLable {
}

extension URLQueryItem: URLable {
}
