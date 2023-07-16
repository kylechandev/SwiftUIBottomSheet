import SwiftUI
import UIKit

// MARK: - NonAnimatedUIKitModal

/// A sliding sheet from the bottom of the screen that uses UIKit to present true modal view, but the whole animation and UI is driven by the SwiftUI
/// https://github.com/nonameplum/SwiftUIModal

/// A view that presents SwiftUI ``DismissableView`` modaly without animation.
public struct NonAnimatedUIKitModal<Presented>: UIViewControllerRepresentable where Presented: DismissableView {

    public let isPresented: Binding<Bool>
    public let content: () -> Presented

    /// Creates non-animated modal that enables programmatic control
    /// of the modal visibility and content.
    /// - Parameters:
    ///   - isPresented: A Binding to state that controls the visibility of the modal.
    ///   - content: The view to show in the modal.
    public init(
        isPresented: Binding<Bool>,
        content: @escaping () -> Presented
    ) {
        self.isPresented = isPresented
        self.content = content
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented.wrappedValue, let vc = context.coordinator.presentedController {
            vc.rootView = content()
        }

        if isPresented.wrappedValue {
            var contentController: NonAnimatedHostingController<Presented>!
            contentController = NonAnimatedHostingController(rootView: content())

            // 设置 sheet 的样式为自定义，并且关闭系统自动的动画，这样我们就能完全自定义 sheet 的展示效果了（实际 sheet 动画由我们自定义实现）
            contentController.modalPresentationStyle = .custom

            contentController.view.backgroundColor = .clear
            context.coordinator.presentedController = contentController
            uiViewController.present(contentController, animated: false) // 关闭动画
        } else {
            // dismiss
            if uiViewController.presentedViewController != nil {
                context.coordinator.presentedController?.rootView.dismiss(completion: { // 关闭我们自定义的 sheet
                    uiViewController.dismiss(animated: false) // 让系统的 sheet modal 关闭掉（如果不做这一步，界面会无法响应，因为系统的 modal 还在显示，只是看不到而已）
                })
            }
        }
    }

    public final class Coordinator {

        private let parent: NonAnimatedUIKitModal
        weak var presentedController: UIHostingController<Presented>?

        init(_ parent: NonAnimatedUIKitModal) {
            self.parent = parent
        }
    }
}

// MARK: - NonAnimatedHostingController

// Custom UIHostingController for halfSheet...
private final class NonAnimatedHostingController<Presented: View>: UIHostingController<Presented> {

    override func viewDidLoad() {
        // 这里的View就是SheetView
        // sheet background
        // view.backgroundColor = .clear

        definesPresentationContext = true
    }
}
