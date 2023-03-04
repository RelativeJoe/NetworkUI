import Foundation
import Combine

public actor Network {
    internal static var configurations: NetworkConfigurations = DefaultConfigurations()
    public static func set(configurations: NetworkConfigurations) {
        Network.configurations = configurations
    }
//MARK: - Request Builder
    internal static func requestBuilder<T: Route>(endPoint: T) throws -> URLRequest {
        var requestURL: URL?
        if let baseURL = endPoint.baseURL {
            let reproccessed = endPoint.route.reproccessed(with: endPoint.reprocess(url: endPoint.route.applied(to: baseURL)))
            requestURL = reproccessed
        }else if let baseURL = configurations.baseURL {
            let reproccessed = endPoint.route.reproccessed(with: configurations.reprocess(url: endPoint.route.applied(to: baseURL)))
            requestURL = reproccessed
        }else {
            throw NetworkError(title: "Error", body: "No Base URL found!")
        }
        guard let requestURL else {
            throw NetworkError(title: "Error", body: "The constructed URL is invalid!")
        }
        var request = URLRequest(url: requestURL, timeoutInterval:  configurations.timeoutInterval)
        request.httpMethod = endPoint.method.rawValue
        request.cachePolicy = configurations.cachePolicy
        request.configure(headers: endPoint.headers)
        if let data = endPoint.body?.data {
            request.httpBody = data
        }
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
