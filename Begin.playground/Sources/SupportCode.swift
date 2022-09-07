import Foundation

public func example(of descrition: String, action: () -> Void) {
    print("\n ===== Example of \(descrition) ======")
    action()
}
