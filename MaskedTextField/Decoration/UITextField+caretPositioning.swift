import UIKit


extension UITextField {

  func setCaretOffset(_ offset: Int) {
    if let newCaretPosition = position(from: beginningOfDocument, offset: offset) {
      moveCaret(to: newCaretPosition)
    }
  }

  func moveCaret(to newPosition: UITextPosition) {
    selectedTextRange = textRange(from: newPosition, to: newPosition)
  }
}
