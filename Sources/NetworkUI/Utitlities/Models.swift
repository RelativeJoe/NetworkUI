//
//  Models.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public struct EmptyData: Codable, Error {
}

///NetworkUI: The policy dictating whether a failed request should be retryed and how many times
public enum NetworkRetries {
///NetworkUI: Never retry the request
    case never
///NetworkUI: Always retry the request as per the routes' retryCount or the `NetworkConfigurations'` retryCount
    case always
///NetworkUI: A custom number of retries
    case custom(Int)
}

///NetworkUI: The authorization type of the request
public enum Authorisation {
    case bearer(token: String)
}

///NetworkUI: The content type of the request's body
public enum ContentType: String {
    case applicationJson = "application/json"
    case multipartFormData = "multipart/form-data; boundary="
}
