//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

public protocol ErrorConfigurations {
    func shouldRetry(_ error: Error) -> Bool
    func handle(_ error: Error) async
}

public extension ErrorConfigurations {
    func shouldRetry(_ error: Error) -> Bool {
        return true
    }
    func handle(_ error: Error) async {
    }
}
