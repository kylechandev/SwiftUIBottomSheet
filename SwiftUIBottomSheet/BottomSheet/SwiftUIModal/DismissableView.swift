import SwiftUI

/// A type that represents a part of a modaly presented view
/// and can be dismissed.
/// ------
/// 目的是让`NonAnimatedUIKitModal`可以传递`dimiss`函数
public protocol DismissableView: View {

    func dismiss(completion: @escaping () -> Void)
}
