//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

public class NetworkData: ObservableObject {
    public static let shared = NetworkData()
    internal var loadingView: (() -> AnyView)?
    internal var errorView: ((NetworkError) -> AnyView)?
    @Published internal var retries: [String: Int] = [:]
    @Published public var isLoading = false
    @Published public var error: NetworkError? {
        didSet {
            guard error != nil else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.error = nil
            }
        }
    }
}

public extension NetworkData {
    static func build(@ViewBuilder view: @escaping (NetworkError) -> some View) {
        shared.errorView = { error in
            AnyView(view(error))
        }
    }
    static func build(@ViewBuilder view: @escaping () -> some View) {
        shared.loadingView = {
            AnyView(view())
        }
    }
}
