import SwiftUI

// MARK: - BottomSheetConfiguration

/// A type to configure a bottom sheet with a custom appearance and custom interaction behavior.
public struct BottomSheetConfiguration {

    /// Default bottom sheet configuration
    public static let `default` = BottomSheetConfiguration()

    /// A dimension that's proportional to the bottom sheet height
    /// that is used to decide if the bottom sheet should be dismissed.
    public var dismissRatio: CGFloat = 0.38 // sheet 向下滑动多少距离后可以自动触发关闭

    /// A dimension in points that allows to specify additional offset
    /// that the bottom sheet view can be draged over it's height.
    public var maxOverDrag: CGFloat = 38 // sheet 可以被额外向上拽动的距离（一个视觉动画效果）

    /// A view used a bottom sheet content background.
    public var background = AnyView(
        RoundedRectangle(cornerRadius: BottomSheetConstants.BOTTOM_SHEET_CORNER)
            .fill(BottomSheetConstants.BOTTOM_SHEET_CONTENT_BACKGROUND)
    ) // sheet 的背景

    /// A view that is used as the dim behind the bottom sheet content.
    public var dim = AnyView(Color.black.opacity(0.15)) // sheet 以外背景变暗的比例

    /// A view that is used as a drag indicator on top of the bottom sheet content.
    public var indicator = AnyView(
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(UIColor.separator))
            .frame(width: 36, height: 5)
            .padding([.top], 6)
            // .padding([.bottom], 16) // 不需要 paddingBottom，因为系统原生就没有，这样都统一不设置，全盘交给 sheetContentView 自己适配处理
    ) // sheet drag handle
    
    /// 是否允许手动关闭 sheet
    public var allowDismiss: Bool = true
    
    public var scrollable: Bool = false

    fileprivate init() {}

    /// Creates the bottom sheet configuration with a custom appearance and custom interaction behavior.
    /// - Parameters:
    ///   - dismissRatio: A dimension that's proportional to the bottom sheet height
    ///                   that is used to decide if the bottom sheet should be dismissed.
    ///   - maxOverDrag: A dimension in points that allows to specify additional offset
    ///                  that the bottom sheet view can be draged over it's height.
    ///   - background: A view used a bottom sheet content background.
    ///   - dim: A view that is used as the dim behind the bottom sheet content.
    ///   - indicator: A view that is used as a drag indicator on top of the bottom sheet content.
    public init<Background: View, Dim: View, Indicator: View>(
        dismissRatio: CGFloat? = nil,
        maxOverDrag: CGFloat? = nil,
        background: (() -> Background)? = nil,
        dim: (() -> Dim)? = nil,
        indicator: (() -> Indicator)? = nil,
        allowDismiss: Bool = true,
        scrollable: Bool = true
    ) {
        if let dismissRatio {
            self.dismissRatio = dismissRatio
        }
        if let maxOverDrag {
            self.maxOverDrag = maxOverDrag
        }
        if let background {
            self.background = AnyView(background())
        }
        if let dim {
            self.dim = AnyView(dim())
        }
        if let indicator {
            self.indicator = AnyView(indicator())
        }
        self.allowDismiss = allowDismiss
        self.scrollable = scrollable
    }
}

// MARK: - BottomSheetConfigurationKey

private struct BottomSheetConfigurationKey: EnvironmentKey {
    static let defaultValue: BottomSheetConfiguration? = nil
}

extension EnvironmentValues {
    var bottomSheetConfiguration: BottomSheetConfiguration? {
        get { self[BottomSheetConfigurationKey.self] }
        set { self[BottomSheetConfigurationKey.self] = newValue }
    }
}

public extension View {
    /// Sets the bottom sheet configuration with a custom appearance and custom interaction behavior.
    ///
    /// ```swift
    /// struct FullBottomSheetPresentedOnDismiss: View {
    ///     @State private var isPresenting = false
    ///     var body: some View {
    ///         Button("Present Full-Screen Bottom Sheet") {
    ///             isPresenting.toggle()
    ///         }
    ///         .bottomSheet(isPresented: $isPresenting, onDismiss: didDismiss) {
    ///             VStack {
    ///                 Text("A bottom sheet view.")
    ///                     .font(.title)
    ///             }
    ///         }
    ///         .bottomSheetConfiguration(.default)
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    /// }
    /// ```
    func bottomSheetIOS15Configuration(_ configuration: BottomSheetConfiguration) -> some View {
        environment(\.bottomSheetConfiguration, configuration)
    }
}
