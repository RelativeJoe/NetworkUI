//
//  Models.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public struct EmptyData: Codable, Error {
}

public enum NetworkRetries {
    case never, always, custom(Int)
}

public enum Authorisation {
    case bearer(token: String)
}

public enum ContentType: String {
    case applicationJson = "application/json"
    case multipartFormData = "multipart/form-data; boundary="
}
