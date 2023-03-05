//
//  File.swift
//  
//
//  Created by Joe Maghzal on 04/03/2023.
//

import Foundation

@resultBuilder
public struct AnyResultBuilder<Result> {
    public static func buildOptional<Component: Resultable>(_ component: Component?) -> some Resultable where Component.ResultType == Result {
        return Results<Result>(builderResult: component?.result ?? [])
    }
    public static func buildBlock(_ parts: any Resultable...) -> [Result] {
        let results = parts.reduce(into: [Result]()) { partialResult, item in
            partialResult.append(contentsOf: item.result)
        }
        return Results<Result>(builderResult: results as? [Result] ?? []).result
    }
    static func buildEither<Component: Resultable>(first component: Component) -> some Resultable where Component.ResultType == Result {
        return Results<Result>(builderResult: component.result)
    }
    static func buildEither<Component: Resultable>(second component: Component) -> some Resultable where Component.ResultType == Result {
        return Results<Result>(builderResult: component.result)
    }
}

public struct Results<Result>: Resultable {
    public var builderResult: [Result]
    public var result: [Result] {
        return builderResult
    }
}

public protocol Resultable {
    associatedtype ResultType
    var result: [ResultType] {get}
}

extension Header: Resultable {
    public var result: [Header] {
        return [self]
    }
}

extension Array: Resultable where Element == Header {
    public var result: [Header] {
        return self
    }
}
