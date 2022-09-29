//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/27/22.
//

import SwiftUI

extension View {
    func listen() -> some View {
        modifier(ViewDataModifier())
    }
}

struct ViewDataModifier: ViewModifier {
    @EnvironmentObject var data: NetworkData
    func body(content: Content) -> some View {
        content
            .presentLoader(isPresented: data.isLoading)
            .handleError()
            .animation(.easeIn, value: data.isLoading)
    }
}

