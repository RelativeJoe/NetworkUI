import Foundation
import Combine

public struct Network {
    internal static var configurations: NetworkConfigurations!
    @MainActor static func requestPublisher<T: EndPoint, Model: Codable>(endPoint: T, model: Model.Type, errorHandler: Bool = true, withLoader: Bool = true) -> AnyPublisher<BaseResponse<Model>, Never> {
        let request = try! requestBuilder(endPoint: endPoint)
        if withLoader {
            NetworkData.shared.isLoading = true
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { result in
                do {
                    return try resultBuilder(result.data, model: model, withLoader: withLoader)
                }catch {
                    return errorBuilder(endPoint: endPoint, error: error, model: model, withLoader: withLoader, errorHandler: errorHandler)
                }
            }.replaceError(with: BaseResponse.error(nil))
            .eraseToAnyPublisher()
    }
    @available(iOS 15.0, *)
    @MainActor public static func request<T: EndPoint, Model: Codable>(endPoint: T, model: Model.Type, errorHandler: Bool = true, withLoader: Bool = true) async -> BaseResponse<Model> {
        do {
            NetworkData.shared.retries[endPoint.id.description] = 1
            let request = try requestBuilder(endPoint: endPoint)
            if withLoader {
                NetworkData.shared.isLoading = true
            }
            let networkResult = try await URLSession.shared.data(for: request)
            return try resultBuilder(networkResult.0, model: model, withLoader: withLoader)
        }catch {
            return await errorBuilder(endPoint: endPoint, error: error, model: model, withLoader: withLoader, errorHandler: errorHandler)
        }
    }
//MARK: - Request Builder
    private static func requestBuilder<T: EndPoint>(endPoint: T) throws -> URLRequest {
        guard let baseURL = endPoint.baseURL ?? configurations.baseURL else {
            throw NetworkError(title: "Error", body: "No Base URL found!")
        }
        let requestURL = baseURL.appendingPathComponent(endPoint.route)
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
//MARK: - Error Builder
    @MainActor private static func errorBuilder<T: EndPoint, Model: Codable>(endPoint: T, error: Error, model: Model.Type, withLoader: Bool, errorHandler: Bool) -> BaseResponse<Model> {
        if withLoader {
            NetworkData.shared.isLoading = false
        }
        guard let networkError = error as? NetworkError else {
            return BaseResponse.error(nil)
        }
//        let retryCount = endPoint.retryCount ?? configurations.retryCount
//        let currentCount = NetworkData.shared.retries[endPoint.id.description] ?? 0
//        if (configurations.errorLayer.shouldRetry(networkError) != nil) && retryCount > currentCount {
//            NetworkData.shared.retries[endPoint.id.description]! += 1
//            return await request(endPoint: endPoint, model: model, errorHandler: errorHandler, withLoader: withLoader)
//        }else {
//            NetworkData.shared.retries.removeValue(forKey: endPoint.id.description)
//        }
        if errorHandler && configurations.errorLayer.shouldDisplay(networkError) {
            NetworkData.shared.error = networkError
        }
        return BaseResponse.error(networkError)
    }
//MARK: - Result Builder
    @MainActor private static func resultBuilder<Model: Codable>(_ data: Data, model: Model.Type, withLoader: Bool) throws -> BaseResponse<Model> {
        print("------Begin Response------")
        print(data.prettyPrinted)
        print("------End Response------")
        let decoder = JSONDecoder()
        let object = try decoder.decode(BaseResponse<Model>.self, from: data)
        if withLoader {
            NetworkData.shared.isLoading = false
        }
        guard !object.error else {
            throw NetworkError(title: object.title, body: object.body)
        }
        return object
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
