//
//  BottomSheetConstants.swift
//  TestDemo
//
//  Created by 棋里棋气 on 2023/7/15.
//

import Foundation
import SwiftUI

// MARK: - 定义一些 BottomSheet 的通用属性值

internal enum BottomSheetConstants {

    /// BottomSheet 默认的背景圆角大小
    static let BOTTOM_SHEET_CORNER: CGFloat = 16.0

    /// BottomSheet 的内容背景
    // static let BOTTOM_SHEET_CONTENT_BACKGROUND: Material = .thinMaterial
    static let BOTTOM_SHEET_CONTENT_BACKGROUND: Color = Color(UIColor.systemBackground)

    /// 默认是否可以让用户手动交互关闭 sheet （例如点击 sheet 以外的区域，向下滑动 sheet 一段距离）
    static let allowDismiss: Bool = true
    
    /// 默认是否显示 drag handle
    static let showIndicators: Bool = true
}
