import Foundation
import Combine

public struct Network {
    internal static var configurations: NetworkConfigurations!
//MARK: - Request Builder
    internal static func requestBuilder<T: EndPoint>(endPoint: T) throws -> URLRequest {
        guard let baseURL = endPoint.baseURL ?? configurations.baseURL else {
            throw NetworkError(title: "Error", body: "No Base URL found!")
        }
        guard let requestURL = endPoint.route.reproccessed(with: configurations.reprocess(url: endPoint.route.applied(to: baseURL))) else {
            throw NetworkError(title: "Error", body: "The constructed URL is invalid!")
        }
        var request = URLRequest(url: requestURL, timeoutInterval:  configurations.timeoutInterval)
        request.httpMethod = endPoint.method.rawValue
        request.configure(headers: endPoint.headers)
        if let data = endPoint.body?.data {
            request.httpBody = data
        } 
        print("------Begin Request------")
        print(request.cURL(pretty: true))
        print("------End Request------")
        return request
    }
//MARK: - Result Builder
    @MainActor internal static func resultBuilder<Model: Codable>(_ data: Data, model: Model.Type, withLoader: Bool) throws -> Model {
        print("------Begin Response------")
        print(data.prettyPrinted)
        print("------End Response------")
        let decoder = JSONDecoder()
        if withLoader {
            NetworkData.shared.isLoading = false
        }
        return try decoder.decode(Model.self, from: data)
    }
    public static func set(configurations: NetworkConfigurations) {
        Network.configurations = configurations
    }
}

public struct BaseResponse<T: Codable>: Codable {
//MARK: - Properties
    public var error: Bool
    public var body: String?
    public var title: String?
    public var data: T?
    public enum CodingKeys: String, CodingKey {
        case error, body, title, data
    }
    public static func error(_ error: NetworkError?) -> BaseResponse<T> {
        return BaseResponse(error: true, body: error?.body, title: error?.title)
    }
    public static func error(body: String, title: String) -> BaseResponse<T> {
        return BaseResponse(error: true, body: body, title: title)
    }
}
