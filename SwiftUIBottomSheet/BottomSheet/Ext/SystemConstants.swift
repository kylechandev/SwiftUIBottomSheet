//
//  SystemConstans.swift
//  TestDemo
//
//  Created by 棋里棋气 on 2023/7/16.
//

import Foundation
#if canImport(UIKit)
    import UIKit
#endif

private var screenSize: CGSize {
    #if os(iOS) || os(tvOS)
        return UIScreen.main.bounds.size
    #elseif os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size
    #elseif os(macOS)
        return NSScreen.main?.frame.size ?? .zero
    #else
        return CGSize.zero
    #endif
}

/// 获取屏幕宽度
internal var screenWidth: CGFloat {
    screenSize.width
}

/// 获取屏幕高度
internal var screenHeight: CGFloat {
    screenSize.height
}
