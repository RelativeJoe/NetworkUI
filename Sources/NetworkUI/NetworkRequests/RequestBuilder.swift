//
//  RequestBuilder.swift
//  
//
//  Created by Joe Maghzal on 21/09/2023.
//

import Foundation

public class RequestBuilder {
//MARK: - Properties
    private var request: URLRequest
    private var headers = [Header]()
//MARK: - Initializer
    public init(url: URL, cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval) {
        self.request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
//MARK: - Functions
    @discardableResult public func with(method: String) -> Self {
        request.httpMethod = method
        return self
    }
    @discardableResult public func with(json: JSON?) -> Self {
        guard let json else {
            return self
        }
        request.httpBody = json.data
        headers.append(.content(type: .applicationJson))
        return self
    }
    @discardableResult public func with(headers: [Header]) -> Self {
        self.headers.append(contentsOf: headers)
        return self
    }
    @discardableResult public func with(formData: [FormData]) -> Self {
        guard !formData.isEmpty else {
            return self
        }
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        formData.forEach { parameter in
            body.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
            body.append("Content-Disposition:form-data; name=\"\(parameter.key)\"".data(using: .utf8) ?? Data())
            if let stringValue = parameter.stringValue {
                body.append("\r\n\r\n\(stringValue)\r\n".data(using: .utf8) ?? Data())
            }else if let dataValue = parameter.dataValue {
                body.append("; filename=\"\(parameter.fileName ?? UUID().uuidString)\"\r\nContent-Type: \"content-type header\"\r\n\r\n".data(using: .utf8) ?? Data())
                body.append(dataValue)
            }
        }
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        request.httpBody = body
        var header = Header.content(type: .multipartFormData)
        header.value += boundary
        headers.append(header)
        return self
    }
    @discardableResult public func configureHeaders() -> Self {
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        return self
    }
    public func build() -> URLRequest {
        return request
    }
}
