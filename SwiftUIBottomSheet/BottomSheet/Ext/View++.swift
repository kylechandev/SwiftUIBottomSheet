//
//  View++.swift
//  TestDemo
//
//  Created by 棋里棋气 on 2023/7/15.
//

import SwiftUI

internal extension View {

    /// View modifier to conditionally add a view modifier else add a different one.
    ///
    /// [Five Stars](https://fivestars.blog/swiftui/conditional-modifiers.html)
    @ViewBuilder
    func ifElse<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        @ViewBuilder if ifTransform: (Self) -> TrueContent,
        @ViewBuilder else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}
