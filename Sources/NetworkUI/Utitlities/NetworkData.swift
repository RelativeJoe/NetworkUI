//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

public class NetworkData: ObservableObject {
//MARK: - Properties
    public static let shared = NetworkData()
    internal var retries: [String: Int] = [:]
    @Published public var isLoading = false
    @Published public var error: (any Errorable)? {
        didSet {
            guard error != nil else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.error = nil
            }
        }
    }
//MARK: - Functions
    internal func set(loading: Bool) async {
        await MainActor.run {
            isLoading = loading
        }
    }
    internal func add(_ description: String) {
        retries[description] = (retries[description] ?? -1) + 1
    }
    internal func remove(_ description: String) {
        retries.removeValue(forKey: description)
    }
}
