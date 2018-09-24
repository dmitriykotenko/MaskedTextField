import UIKit


/// Performs cleanup before inserting any text from the clipboard.
class TextFieldSanitizationEngine: TextFieldDelegateProxy {
  
  var sanitizer: (String) -> String = { $0 }
  
  override func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
    
    let sanitizedString = sanitizer(string)
    
    _ = askParent(textField, range, sanitizedString)
    
    return false
  }
}
