//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import Foundation

internal extension Data {
    var prettyPrinted: String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: .mutableLeaves), let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes]), let string = String(data: data, encoding: .utf8) else {
            return ""
        }
        return string
    }
}

internal extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        var cURL = "curl "
        var header = ""
        var data: String = ""
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        cURL += method + url + header + data
        return cURL
    }
    mutating func configure(headers: [Header]) {
        headers.forEach { header in
            addValue(header.value, forHTTPHeaderField: header.name)
        }
    }
}
