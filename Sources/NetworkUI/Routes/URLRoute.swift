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
//MARK: - Initializers
    public init(from item: URLable) {
        self.components = [item]
    }
    internal init(components: [URLable]) {
        self.components = components
    }
}

//MARK: - Returning Functions
public extension URLRoute {
    func appending(_ component: (any URLable)?) -> Self {
        guard let component else {
            return self
        }
        var newComponents = components
        newComponents.append(component)
        return URLRoute(components: newComponents)
    }
}

//MARK: - Returning Functions Using Closures
public extension URLRoute {
    func appending(component: @escaping () throws -> (any URLable)?) rethrows -> Self {
        return appending(try component())
    }
}

//MARK: - Mutating Functions
public extension URLRoute {
    mutating func append(_ component: (any URLable)?) {
        guard let component else {return}
        components.append(component)
    }
}

//MARK: - Mutating Functions Using Closures
public extension URLRoute {
    mutating func append(component: @escaping () throws -> (any URLable)?) rethrows {
        append(try component())
    }
}

//MARK: - Public Functions
public extension URLRoute {
    static func proccess(_ url: URL?, with components: [URLable]) -> URL? {
        return components.reduce(into: url) { newURL, item in
            if let string = item as? String {
                if #available(macOS 13.0, iOS 16.0, *) {
                    newURL?.append(path: string)
                }else {
                    newURL = newURL?.appendingPathComponent(string)
                }
            }else if let parameter = item as? URLQueryItem {
                if #available(macOS 13.0, iOS 16.0, *) {
                    newURL?.append(queryItems: [parameter])
                }else {
                    guard let urlString = newURL?.absoluteString else {return}
                    var components = URLComponents(string: urlString)
                    components?.queryItems?.append(parameter)
                    newURL = components?.url
                }
            }else if let route = item as? URLRoute {
                newURL = route.applied(to: url)
            }else if let iterable = item as? Iterable {
                newURL = Self.proccess(newURL, with: iterable.parameters)
            }
        }
    }
    func applied(to url: URL?) -> URL? {
        return Self.proccess(url, with: components)
    }
}
