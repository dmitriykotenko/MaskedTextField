import UIKit


/// Custom implementations of Cut and Paste commands for MaskedTextField.
class TextFieldCopyPaster {
  
  private weak var textField: MaskedTextField?
  private let internalDelegate: UITextFieldDelegate
  private let externalDelegate: UITextFieldDelegate
  
  private let pasteboard = UIPasteboard.general
  
  init(textField: MaskedTextField,
       internalDelegate: UITextFieldDelegate,
       externalDelegate: UITextFieldDelegate) {
    self.textField = textField
    self.internalDelegate = internalDelegate
    self.externalDelegate = externalDelegate
  }
  
  func cut() {
    guard
      let textField = textField,
      let selectedText = textField.selectedText,
      let selectedUtf16range = textField.selectedUtf16range,
      let selectedSignificantRange = textField.selectedSignificantRange
      else { return }
    
    let shouldCut = externalDelegate.textField?(
      textField,
      shouldChangeCharactersIn: selectedSignificantRange,
      replacementString: ""
    ) ?? true
    
    guard shouldCut else { return }
    
    // 1. Copy selected text to clipboard.
    pasteboard.string = selectedText
    
    // 2. Remove selected text from the screen.
    _ = internalDelegate.textField?(
      textField,
      shouldChangeCharactersIn: selectedUtf16range,
      replacementString: ""
    )
  }
  
  func paste() {
    guard
      let textField = textField,
      let selectedUtf16range = textField.selectedUtf16range
      else { return }
    
    guard
      pasteboard.hasStrings,
      // Joining with spaces is default UITextField's behavior when pasting multiple strings at once.
      let pastedText = pasteboard.strings.map ({ $0.joined(separator: " ") })
      else { return }
    
    _ = internalDelegate.textField?(
      textField,
      shouldChangeCharactersIn: selectedUtf16range,
      replacementString: pastedText
    )
  }
  
  private func significantRange(from range: NSRange) -> NSRange {
    return textField?.decoratedText?.significantRange(from: range) ?? range
  }
}


fileprivate extension MaskedTextField {
  
  var selectedText: String? {
    guard
      let decoratedText = decoratedText,
      let selectedUtf16range = selectedUtf16range
      else { return nil }
    
    let selectedSubstring = NSString(string: decoratedText.value)
      .substring(with: selectedUtf16range)
    
    return selectedSubstring
  }

  var selectedRange: NSRange? {
    guard let selectedUtf16range = selectedUtf16range else { return nil }
    
    return decoratedText?.rangeFromUtf16Range(selectedUtf16range)
  }
  
  var selectedSignificantRange: NSRange? {
    guard let selectedRange = selectedRange else { return nil }
    
    return decoratedText?.significantRange(from: selectedRange)
  }
}
