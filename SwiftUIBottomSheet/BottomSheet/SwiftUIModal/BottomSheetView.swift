import SwiftUI

// MARK: - BottomSheetView

public struct BottomSheetView<Content>: DismissableView where Content: View {

    /// Remember, one of the advantages of @GestureState is that it automatically sets the value of your property back to its initial value when the gesture ends.
    /// In this case, it means we can drag a view around all we want, and as soon as we let go it will snap back to its original position.
    /// https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-gesturestate-property-wrapper
    @GestureState private var translation: CGFloat = 0

    /// sheet 是否显示（内部控制）
    @State private var show = false

    /// Shet Content View Height
    @State private var contentHeight: CGFloat = 0

    /// sheet 是否显示（外部控制）
    @Binding var isPresented: Bool

    /// 指定的 Configuration
    private let explicitConfiguration: BottomSheetConfiguration?
    @Environment(\.bottomSheetConfiguration) private var environmentConfiguration
    private var configuration: BottomSheetConfiguration {
        environmentConfiguration ?? explicitConfiguration ?? .default
    }

    /// Sheet Content View
    private let content: Content

    public init(
        isPresented: Binding<Bool>,
        configuration: BottomSheetConfiguration? = nil,
        @ViewBuilder content: () -> Content
    ) {
        _isPresented = isPresented
        self.explicitConfiguration = configuration
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // # drag handle
                if BottomSheetConstants.showIndicators {
                    configuration.indicator
                }

                // # sheet content view
                content
                    .frame(maxWidth: .infinity, maxHeight: screenHeight * 0.55) // maxHeight: screenHeight * 0.55（兼容 scrollable 避免拉的过长）
                    .fixedSize(horizontal: false, vertical: true)
                    .onTapGesture {}

                // Padding added to the bottom of the sheet to allow over drag to the top and also to avoid bottom rounded corners to be visible
                Rectangle()
                    .fill(.clear)
                    .frame(maxWidth: geometry.size.width, maxHeight: Constants.bottomPaddingHeight)
            }
            .ignoresSafeArea()
            .readSize {
                contentHeight = $0.height
            }
            .background(configuration.background) // sheet content background
            .frame(height: geometry.size.height, alignment: .bottom) // sheet height
            .offset(y: maxOffset)
            .animation(springAnimation, value: translation)
            .simultaneousGesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    if configuration.allowDismiss {
                        dismissIfNeededOnDragEnd(translationHeight: value.translation.height)
                    }
                }
            )
        } // end GeometryReader
        .background { // sheet 以外的区域的背景
            configuration.dim
                .gesture(TapGesture().onEnded { // 点击背景以外关闭 sheet
                    if configuration.allowDismiss {
                        dismiss()
                    }
                })
                .opacity(show ? 1 : 0)
                .ignoresSafeArea()
        }
        .contentShape(Rectangle()) // 让整个区域可响应点击
        .onChange(of: isPresented, perform: { newValue in
            // 响应外部主动关闭 sheet，内部调用 dismiss 来关闭（让关闭动画显示出来）
            if !newValue {
                dismiss()
            }
        })
        .onAppear {
            // 显示 sheet
            DispatchQueue.main.async {
                withAnimation(springAnimation) {
                    show = true
                }
            }
        }
    }

    /// 关闭 sheet
    public func dismiss(completion: @escaping () -> Void = {}) {
        withAnimation(springAnimation) {
            show = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            completion()

            isPresented = false
        }
    }

    // MARK: Helpers

    private let springAnimation: Animation = .interactiveSpring(
        response: 0.35,
        dampingFraction: 0.78,
        blendDuration: 0
    )

    private var maxOffset: CGFloat {
        let offset = show ? 0 : contentHeight
        return offset + Constants.bottomPaddingHeight + max(translation, -configuration.maxOverDrag)
    }

    private func dismissIfNeededOnDragEnd(translationHeight: CGFloat) {
        let ratioHeight = (contentHeight - Constants.bottomPaddingHeight) * configuration.dismissRatio
        if translationHeight > ratioHeight {
            dismiss()
        }
    }
}

// MARK: - Constants

private enum Constants {

    /// Padding added to the bottom of the sheet to allow over drag
    /// to the top and also to avoid bottom rounded corners to be visible
    static let bottomPaddingHeight: CGFloat = 100
}
