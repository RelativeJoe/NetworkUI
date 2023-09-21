import Foundation
import Combine

///NetworkUI: The Network actor that handles requests
public actor Network: NetworkRequestable {
//MARK: - Properties
    public var configurations: NetworkConfigurations
    public var session: URLSession
//MARK: - Initializer
///NetworkUI: Initializer a `Network` instance using `NetworkConfigurations`
    public init(configurations: NetworkConfigurations = DefaultConfigurations(), session: URLSession = .shared) {
        self.configurations = configurations
        self.session = session
    }
//MARK: - Request Builder
    internal func requestBuilder(route: Route) throws -> URLRequest {
        let baseURL = route.baseURL ?? configurations.baseURL
        let rawURL = route.route.applied(to: baseURL)
        let requestURL = configurations.reprocess(url: rawURL)
        guard let requestURL else {
            throw NetworkError(title: "Error", body: "The url is invalid!")
        }
        let request = RequestBuilder(url: requestURL, cachePolicy: configurations.cachePolicy, timeoutInterval: configurations.timeoutInterval)
            .with(method: route.method.rawValue)
            .with(headers: route.headers)
            .with(json: route.body)
            .with(formData: route.formData)
            .configureHeaders()
            .build()
        return request
    }
//MARK: - Result Builder
    internal func resultBuilder<Model: Decodable, ErrorModel: Error & Decodable>(call: NetworkCall<Model, ErrorModel>, request: URLRequest, response: (data: Data, status: URLResponse)) async throws -> Model {
        let status = ResponseStatus(statusCode: (response.status as? HTTPURLResponse)?.statusCode ?? 0)
        RequestLogger.end(request: request, with: (response.data, status))
        if let map = call.map {
            return try map(status)
        }
        if let validity = call.validCode, !(try validity(status)) {
            throw NetworkError.unnaceptable(status: status)
        }
        let decoder = call.decoder ?? configurations.decoder
        do {
            return try decoder.decode(Model.self, from: response.data)
        }catch {
            if call.errorModel != nil {
                throw try decoder.decode(ErrorModel.self, from: response.data)
            }
            throw error
        }
    }
}
