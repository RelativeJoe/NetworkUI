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

public struct URLRoute {
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
    func appending(_ item: Self?, isPost: Bool = false) -> Self {
        guard let item else {
            return self
        }
        var newComponents = components
        var newPostComponents = postComponents
        if isPost {
            newPostComponents.append(contentsOf: item.components)
        }else {
            newComponents.append(contentsOf: item.components)
        }
        return URLRoute(components: newComponents, postComponents: newPostComponents)
    }
}

//MARK: - Returning Functions Using Closures
public extension URLRoute {
    func appending(component: @escaping () throws -> (any URLable)?, isPost: Bool = false) rethrows -> Self {
        return appending(try component(), isPost: isPost)
    }
    func appending(item: @escaping () throws -> Self?, isPost: Bool = false) rethrows -> Self {
        return appending(try item(), isPost: isPost)
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
    mutating func append(_ item: Self?, isPost: Bool = false) {
        guard let item else {return}
        if isPost {
            postComponents.append(contentsOf: item.components)
        }else {
            components.append(contentsOf: item.components)
        }
    }
}

//MARK: - Mutating Functions Using Closures
public extension URLRoute {
    mutating func append(component: @escaping () throws -> (any URLable)?, isPost: Bool = false) rethrows {
        append(try component(), isPost: isPost)
    }
    mutating func append(item: @escaping () throws -> Self?, isPost: Bool = false) rethrows {
        append(try item(), isPost: isPost)
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
            }
        }
        return newURL
    }
}
