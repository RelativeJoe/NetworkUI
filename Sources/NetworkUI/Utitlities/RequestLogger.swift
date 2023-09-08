//
//  RequestLogger.swift
//  
//
//  Created by Joe Maghzal on 08/09/2023.
//

import Foundation

struct RequestLogger {
    static func start(request: URLRequest, count: Int) {
        print("")
        print("-----------------------------------------------------------------------")
        if count == 0 {
            print("Started Request:")
            print(request.cURL(pretty: true))
        }else {
            print("Retrying Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        }
        print("-----------------------------------------------------------------------")
        print("")
    }
    static func end(request: URLRequest, with response: (Data, ResponseStatus)) {
        print("")
        print("-----------------------------------------------------------------------")
        print("Response Received for \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "") with status \(response.1.code):")
        print(response.0.prettyPrinted)
        print("------------------------------------------------------------------------")
        print("")
    }
}
