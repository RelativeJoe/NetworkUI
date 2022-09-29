//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/29/22.
//

import SwiftUI

public extension View {
    @ViewBuilder func handleError() -> some View {
        self.modifier(ErrorViewModifier())
    }
}

struct ErrorViewModifier: ViewModifier {
    @EnvironmentObject var data: NetworkData
    func body(content: Content) -> some View {
        ZStack {
            content
            if let error = data.error {
                data.errorView?(error)
            }
        }
    }
}
