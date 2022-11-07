//
//  File.swift
//  
//
//  Created by Joe Maghzal on 9/29/22.
//

import SwiftUI

public extension View {
    @ViewBuilder func presentLoader(isPresented: Bool) -> some View {
        if isPresented {
            self.modifier(LoaderViewModifier())
        }else {
            self
        }
    }
}

struct LoaderViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(true)
            NetworkData.shared.loadingView?()
        }
    }
}

