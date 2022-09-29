//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

@MainActor class NetworkData: ObservableObject {
    static let shared = NetworkData()
    var loadingView: (() -> AnyView)?
    var errorView: ((NetworkError) -> AnyView)?
    @Published var retries: [String: Int] = [:]
    @Published var isLoading = false
    @Published var error: NetworkError? {
        didSet {
            guard error != nil else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.error = nil
            }
        }
    }
}
