import Foundation
import Combine

public actor Network {
    internal static var configurations: NetworkConfigurations = DefaultConfigurations()
    public static func set(configurations: NetworkConfigurations) {
        Network.configurations = configurations
    }
//MARK: - Request Builder
    internal static func requestBuilder(route: Route) throws -> URLRequest {
        var requestURL: URL?
        if let baseURL = route.baseURL {
            let reproccessed = route.route.reproccessed(with: route.reprocess(url: route.route.applied(to: baseURL)))
            requestURL = reproccessed
        }else if let baseURL = configurations.baseURL {
            let reproccessed = route.route.reproccessed(with: configurations.reprocess(url: route.route.applied(to: baseURL)))
            requestURL = reproccessed
        }else {
            throw NetworkError(title: "Error", body: "No Base URL found!")
        }
        guard let requestURL else {
            throw NetworkError(title: "Error", body: "The constructed URL is invalid!")
        }
        var request = URLRequest(url: requestURL, timeoutInterval:  configurations.timeoutInterval)
        request.httpMethod = route.method.rawValue
        request.cachePolicy = configurations.cachePolicy
        var headers = route.headers
        if let data = route.body?.data {
            request.httpBody = data
        }else if !route.formData.isEmpty {
            let boundary = "Boundary-\(UUID().uuidString)"
            var body = ""
            route.formData.forEach { parameter in
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(parameter.key)\""
                if let stringValue = parameter.stringValue {
                    body += "\r\n\r\n\(stringValue)\r\n"
                }else if let dataValue = parameter.dataValue, let dataContent = String(data: dataValue, encoding: .utf8) {
                    body += "; filename=\"\(parameter.fileName ?? UUID().uuidString)\"\r\nContent-Type: \"content-type header\"\r\n\r\n\(dataContent)\r\n"
                }
            }
            body += "--\(boundary)--\r\n";
            let requestData = body.data(using: .utf8)
            request.httpBody = requestData
            if let index = headers.firstIndex(where: {$0.value == ContentType.multipartFormData.rawValue}) {
                headers[index].value += boundary
            }
        }
        request.configure(headers: headers)
        return request
    }
//MARK: - Result Builder
    internal static func resultBuilder<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>, request: URLRequest, data: (Data, URLResponse)) async throws -> Model {
        print("")
        let status = ResponseStatus(statusCode: (data.1 as? HTTPURLResponse)?.statusCode ?? 0)
        print("Status \(status.description)")
        print("---------------------------Request Begin---------------------------------")
        print(request.cURL(pretty: true))
        print("---------------------------End Request---------------------------------")
        print("")
        print("---------------------------Begin Response---------------------------------")
        print(data.0.prettyPrinted)
        print("---------------------------End Response---------------------------------")
        print("")
        if let map = call.map {
            NetworkData.remove(call.route.id)
            return try map(status)
        }
        let decoder = call.decoder ?? configurations.decoder
        do {
            let model = try decoder.decode(Model.self, from: data.0)
            if model is EmptyData && call.errorModel != nil, let errorModel = try? decoder.decode(ErrorModel.self, from: data.0) {
                throw errorModel
            }
            if let validity = call.validCode, !(try validity(status)) {
                throw NetworkError.unnaceptable(status: status)
            }
            NetworkData.remove(call.route.id)
            return model
        }catch let modelError {
            if call.errorModel != nil {
                do {
                    let errorModel = try decoder.decode(ErrorModel.self, from: data.0)
                    throw errorModel
                }catch let errorModelError {
                    throw errorModelError
                }
            }
            throw modelError
        }
    }
}
