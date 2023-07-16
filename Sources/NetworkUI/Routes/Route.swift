//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

///NetworkUI: Configuration of a certain request
public protocol Route {
///NetworkUI: Configure the base url of the request. Defaults to the one set in the `NetworkConfigurations`
    var baseURL: URL? {get}
///NetworkUI: Configure the path and/or the query parameters of the request
    var route: URLRoute {get}
///NetworkUI: Configure the method of the request
    var method: RequestMethod {get}
///NetworkUI: Configure the body of the request
    var body: JSON? {get}
///NetworkUI: Configure the form data parameters of the request
    @FormDataResultBuilder var formData: [FormData] {get}
///NetworkUI: Configure the headers of the request
    @HeaderResultBuilder var headers: [Header] {get}
///NetworkUI: Configure the maximum retry count if the request fails
    var retryCount: Int? {get}
///NetworkUI: Configure the id if the request
    var id: CustomStringConvertible {get}
///NetworkUI: Reprocess the the url of the request after being built
    func reprocess(url: URL?) -> URL?
}

public extension Route {
    var baseURL: URL? {
        return nil
    }
    var headers: [Header] {
        return []
    }
    var retryCount: Int? {
        return nil
    }
    var id: CustomStringConvertible {
        return (baseURL?.absoluteString ?? "") + method.rawValue + route.components.description
    }
    var body: JSON? {
        return nil
    }
    func reprocess(url: URL?) -> URL? {
        return url
    }
    var formData: [FormData] {
        return []
    }
}
