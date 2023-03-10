//
//  EmptyData.swift
//  
//
//  Created by Joe Maghzal on 05/02/2023.
//

import Foundation

public struct EmptyData: Codable, Error {
}

public enum NetworkHandler {
    case loading, error, all, none
    var withLoading: Bool {
        switch self {
            case .loading, .all:
                return true
            default:
                return false
        }
    }
    var withError: Bool {
        switch self {
            case .error, .all:
                return true
            default:
                return false
        }
    }
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
