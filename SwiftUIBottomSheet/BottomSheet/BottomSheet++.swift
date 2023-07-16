//
//  BottomSheet++.swift
//  TestDemo
//
//  Created by 棋里棋气 on 2023/7/15.
//

import SwiftUI

extension View {

    @available(iOS 16.0, *)
    @ViewBuilder
    func getSheetViewIOS16<Content: View>(
        // custom start...
        allowDismiss: Bool = BottomSheetConstants.allowDismiss,
        scrollable: Bool = false, // 根据 sheet 展示内容类型（固定大小的内容 or 列表滚动内容） 传入
        // custom end...

        onDismiss: (() -> Void)? = nil,
        sheetContent: Content
    ) -> some View {
        let buildSheetView: some View = sheetContent
            // iOS 15.0
            // 是否允许用户交互关闭 sheet
            .interactiveDismissDisabled(!allowDismiss)
            // iOS 16.0
            .ifElse(scrollable, if: { view in
                view.presentationDetents([.medium])
            }, else: { view in
                view.fitBottomSheetHeight()
            })
            // 显示 sheet 顶部的 handle
            .presentationDragIndicator(BottomSheetConstants.showIndicators ? .visible : .hidden)

        // iOS 16.4 Added Custom Sheet Behavior
        if #available(iOS 16.4, *) {
            buildSheetView
                // 控制sheet内容区域滑动时的反馈
                // 默认`resizes`是将 sheet 继续放大，到 sheet 本身到最大时 sheet 内容可以继续滑动；
                // 使用`scrolls`则 sheet 不会先放大，而是直接进行 sheet 内容的滑动
                .presentationContentInteraction(.resizes)
                // 让 sheet 以外的背景区域可交互
                // 默认`disabled`
                // 设置`enabled`后 sheet 外的区域的 View 依旧可以响应用户的交互（这时候点击 sheet 区域外就不会自动关闭 sheet 了）
                .presentationBackgroundInteraction(.disabled)
                // 设置 sheet 的背景
                .presentationBackground(BottomSheetConstants.BOTTOM_SHEET_CONTENT_BACKGROUND)
                // 设置 sheet 的背景圆角大小
                .presentationCornerRadius(BottomSheetConstants.BOTTOM_SHEET_CORNER)
            // 让 sheet 有`popover`的效果
            // https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-swiftui-%E7%9A%84-presentationcompactadaptation-popover-%E5%9C%A8-iphone-%E4%B8%8A%E9%A1%AF%E7%A4%BA%E5%BD%88%E5%87%BA%E8%A6%96%E7%AA%97-9d87fdf9003f
            // .presentationCompactAdaptation()
        } else {
            buildSheetView
        }
    }

    /// iOS 15
    ///     Fixed Content: USE SwiftUIModal Package
    ///     Scrollable Content: USE native UIKit sheet with detents: [.medium] by default
    /// iOS 16
    ///     Fixed Content: USE native sheet with detents: [.height(fitBottomSheetHeight)]
    ///     Scrollable Content: USE navtive SwiftUI sheet with detents: [.medium] by default
    @ViewBuilder
    func fitBottomSheet<Content: View>(
        isPresented: Binding<Bool>,

        // custom start...
        allowDismiss: Bool = BottomSheetConstants.allowDismiss,
        scrollable: Bool = false, // 根据 sheet 展示内容类型（固定大小的内容 or 列表滚动内容） 传入
        // custom end...

        onDismiss: (() -> Void)? = nil,
        @ViewBuilder sheetContent: @escaping () -> Content
    ) -> some View {
        if #available(iOS 16.0, *) {
            // iOS 16 ↑ SwiftUI WAY
            self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
                getSheetViewIOS16(allowDismiss: allowDismiss, scrollable: scrollable, sheetContent: sheetContent())
            }
        } else {
            // iOS 15 UIKit WAY
            // USE SwiftUIModal Package
            self.bottomSheetIOS15Custom(
                isPresented: isPresented,
                content: sheetContent
            )
            .bottomSheetIOS15Configuration(with(.default) { $0.allowDismiss = allowDismiss })
            .onChange(of: isPresented.wrappedValue) { newValue in
                if !newValue {
                    onDismiss?()
                }
            }
        }
    }

    /// iOS 15
    ///     Fixed Content: USE SwiftUIModal Package
    ///     Scrollable Content: USE native UIKit sheet with detents: [.medium] by default
    /// iOS 16
    ///     Fixed Content: USE native sheet with detents: [.height(fitBottomSheetHeight)]
    ///     Scrollable Content: USE navtive SwiftUI sheet with detents: [.medium] by default
    @ViewBuilder
    func fitBottomSheet<Item: Identifiable & Equatable, Content: View>(
        item: Binding<Item?>,

        // custom start...
        allowDismiss: Bool = BottomSheetConstants.allowDismiss,
        scrollable: Bool = false, // 根据 sheet 展示内容类型（固定大小的内容 or 列表滚动内容） 传入
        // custom end...

        onDismiss: (() -> Void)? = nil,
        @ViewBuilder sheetContent: @escaping (Item) -> Content
    ) -> some View {
        if #available(iOS 16.0, *) {
            self.sheet(item: item, onDismiss: onDismiss) { value in
                getSheetViewIOS16(allowDismiss: allowDismiss, scrollable: scrollable, sheetContent: sheetContent(value))
            }
        } else {
            // bug!!!
            // iOS 15 UIKit WAY
            // USE SwiftUIModal Package
            self.bottomSheetIOS15Custom(item: item, content: { v in sheetContent(v) })
                .bottomSheetIOS15Configuration(with(.default) { $0.allowDismiss = allowDismiss })
        }
    }

    @ViewBuilder
    func getios15<Item: Identifiable & Equatable, Content: View>(
        item: Binding<Item?>,
        @ViewBuilder sheetContent: @escaping (Item) -> Content
    ) -> some View {
        if let value = item.wrappedValue {
            sheetContent(value)
        } else {
            EmptyView()
        }
    }
}

extension View {

    /// debug log
    /// - Parameter text: log
    func viewDebugPrint(_ text: @escaping () -> String) -> some View {
        print(text())

        return self
    }
}

var isIOS16Dot4: Bool {
    if #available(iOS 16.4, *) {
        return true
    } else {
        return false
    }
}
