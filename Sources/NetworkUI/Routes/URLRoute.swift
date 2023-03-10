//
//  File.swift
//  
//
//  Created by Joe Maghzal on 13/01/2023.
//

import Foundation

public protocol URLable {
}

extension String: URLable {}

extension URLQueryItem: URLable {}

public struct URLRoute: URLable {
//MARK: - Properties
    internal var components: [URLable]
    internal var postComponents: [URLable]
//MARK: - Initializers
    public init(from item: URLable) {
        self.components = [item]
        self.postComponents = []
    }
    internal init(components: [URLable], postComponents: [URLable]) {
        self.components = components
        self.postComponents = postComponents
    }
}

//MARK: - Returning Functions
public extension URLRoute {
    func appending(_ component: (any URLable)?, isPost: Bool = false) -> Self {
        guard let component else {
            return self
        }
        var newComponents = components
        var newPostComponents = postComponents
        if isPost {
             newPostComponents.append(component)
        }else {
            newComponents.append(component)
        }
        return URLRoute(components: newComponents, postComponents: newPostComponents)
    }
}

//MARK: - Returning Functions Using Closures
public extension URLRoute {
    func appending(isPost: Bool = false, component: @escaping () throws -> (any URLable)?) rethrows -> Self {
        return appending(try component(), isPost: isPost)
    }
}

//MARK: - Mutating Functions
public extension URLRoute {
    mutating func append(_ component: (any URLable)?, isPost: Bool = false) {
        guard let component else {return}
        if isPost {
            postComponents.append(component)
        }else {
            components.append(component)
        }
    }
}

//MARK: - Mutating Functions Using Closures
public extension URLRoute {
    mutating func append(isPost: Bool = false, component: @escaping () throws -> (any URLable)?) rethrows {
        append(try component(), isPost: isPost)
    }
}

//MARK: - Public Functions
public extension URLRoute {
    func applied(to url: URL?) -> URL? {
        var newURL = url
        components.forEach { item in
            if let string = item as? String {
                newURL?.append(path: string)
            }else if let parameter = item as? URLQueryItem {
                newURL?.append(queryItems: [parameter])
            }else if let route = item as? URLRoute {
                newURL = route.applied(to: url)
            }
        }
        return newURL
    }
    func reproccessed(with url: URL?) -> URL? {
        var newURL = url
        postComponents.forEach { item in
            if let string = item as? String {
                newURL?.append(path: string)
            }else if let parameter = item as? URLQueryItem {
                newURL?.append(queryItems: [parameter])
            }else if let route = item as? URLRoute {
                newURL = route.applied(to: url)
            }
        }
        return newURL
    }
}
