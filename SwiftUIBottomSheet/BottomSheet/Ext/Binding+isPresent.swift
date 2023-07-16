import SwiftUI

internal extension Binding {
    
    /// 对应 Binding<Item> 的 Binding<Bool> 的封装
    
    func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        .init(
            get: { self.wrappedValue != nil },
            set: { isPresent, transaction in
                if !isPresent {
                    self.transaction(transaction).wrappedValue = nil
                }
            }
        )
    }
}
