// //
// //  SheetIOS15.swift
// //  TestDemo
// //
// //  Created by 棋里棋气 on 2023/7/15.
// //
//
// import SwiftUI
// import UIKit
//
// /// https://www.youtube.com/watch?v=rQKT7tn4uag
// /// https://gist.github.com/dankamel/d7d66bea734ff1a2ea2a6f6abfd538ad
// /// https://sarunw.com/posts/bottom-sheet-in-ios-15-with-uisheetpresentationcontroller/
//
// // Custom Half Sheet Modifier....
// extension View {
//
//     // binding show bariable...
//     @ViewBuilder
//     func bottomSheetIOS15<Content: View>(
//         showSheet: Binding<Bool>,
//
//         // custom start...
//         allowDismiss: Bool,
//         // custom end...
// 
//         content: Content
//     ) -> some View {
//         self.background( // 必须用`background`，如果用`overlay`的话会导致页面无法响应
//             HalfSheetHelper(
//                 sheetView: content,
//                 showSheet: showSheet,
//                 allowDismiss: allowDismiss
//             )
//         )
//     }
// }
//
// // MARK: - HalfSheetHelper
//
// // UIKit integration
// struct HalfSheetHelper<Content: View>: UIViewControllerRepresentable {
//
//     var sheetView: Content
//     @Binding var showSheet: Bool
//
//     // custom start...
//     let allowDismiss: Bool
//     // custom end...
//
//     func makeCoordinator() -> Coordinator {
//         Coordinator(parent: self)
//     }
//
//     func makeUIViewController(context: Context) -> UIViewController {
//         let controller: UIViewController = UIViewController()
//         controller.view.backgroundColor = .clear
//         return controller
//     }
//
//     func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//         if showSheet {
//             // presenting Modal View...
//             let sheetController = CustomHostingController(rootView: sheetView)
//             sheetController.showDragIndicator = BottomSheetConstants.showIndicators
//             // false: 让 sheet 不能被用户手动关闭
//             sheetController.isModalInPresentation = !allowDismiss
//             sheetController.presentationController?.delegate = context.coordinator
//             uiViewController.present(sheetController, animated: true)
//         } else {
//             // closing view when showSheet toggled again...
//             uiViewController.dismiss(animated: true)
//         }
//     }
//
//     // on dismiss...
//     final class Coordinator: NSObject, UISheetPresentationControllerDelegate {
//
//         var parent: HalfSheetHelper
//
//         init(parent: HalfSheetHelper) {
//             self.parent = parent
//         }
//
//         func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
//             // 用户`交互`关闭 sheet 后（代码关闭不会回调），通知回调
//             parent.showSheet = false
//
//         }
//     }
// }
//
// // MARK: - CustomHostingController
//
// // Custom UIHostingController for halfSheet...
// private final class CustomHostingController<Content: View>: UIHostingController<Content> {
//
//     // custom start...
//     var showDragIndicator: Bool = false
//     // custom end...
//
//     override func viewDidLoad() {
//         // 这里的View就是SheetView
//         // sheet background
//         // view.backgroundColor = .clear
//
//
//         // setting presentation controller properties...
//         if let presentationController = presentationController as? UISheetPresentationController {
//             if #available(iOS 16.0, *) {
//                 presentationController.detents = [
//                     // iOS16 才支持
//                     // https://nemecek.be/blog/159/how-to-configure-uikit-bottom-sheet-with-custom-size
//                     // .custom { _ in
//                     //     return 200
//                     // },
//                     // .custom { context in
//                     //     return context.maximumDetentValue * 0.6
//                     // },
//                     .medium(),
//                     .large(),
//                 ]
//             } else {
//                 // Fallback on earlier versions
//                 presentationController.detents = [
//                     .medium(),
//                     // .large(),
//                 ]
//             }
//
//             // drag handle
//             presentationController.prefersGrabberVisible = showDragIndicator
//
//             // this(false) allows you to scroll even during medium detent
//             presentationController.prefersScrollingExpandsWhenScrolledToEdge = true
//
//             // sheet corner size
//             presentationController.preferredCornerRadius = BottomSheetConstants.BOTTOM_SHEET_CORNER
//         }
//     }
// }
