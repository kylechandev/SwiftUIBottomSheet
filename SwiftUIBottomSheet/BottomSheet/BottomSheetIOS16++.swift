//
//  BottomSheetIOS16++.swift
//  TestDemo
//
//  Created by 棋里棋气 on 2023/7/15.
//

import SwiftUI

// MARK: - FitSheetHeightPreferenceKey

/// 读取 SheetView 的内容高度

private struct FitSheetHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - FitSheetReadHeightModifier

@available(iOS 16.0, *)
struct FitSheetReadHeightModifier: ViewModifier {

    @State private var readHeight: CGFloat = .zero

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                Color.clear.preference(key: FitSheetHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(FitSheetHeightPreferenceKey.self) { height in
            self.readHeight = height
        }
        // 设置 sheet modal 的内容高度
        .presentationDetents([.height(readHeight)])
    }
}

// MARK: - 读取并设置 SheetView 的固定高度

extension View {

    @available(iOS 16.0, *)
    func fitBottomSheetHeight() -> some View {
        self.modifier(FitSheetReadHeightModifier())
    }
}
