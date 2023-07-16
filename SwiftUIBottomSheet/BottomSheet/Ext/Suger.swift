//
//  Suger.swift
//  TestDemo
//
//  Created by 棋里棋气 on 2023/7/16.
//

import Foundation

@discardableResult
public func with<T>(_ item: T, _ closure: (inout T) -> Void) -> T {
    var mutableItem = item
    closure(&mutableItem)
    return mutableItem
}
