import UIKit


/// Validates any value before it becomes text field's text.
///
/// If the value is invalid, does not allow to perform an update.
class TextFieldValidationEngine: TextFieldDelegateProxy {
  
  var validator: Validator<String>?
  
  override init() {
    super.init()
  }
  
  override func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
    guard let validator = validator else {
      return askParent(textField, range, string)
    }
    
    let currentText = (textField.text ?? "") as NSString
    let newText = currentText.replacingCharacters(in: range, with: string)
    
    if validator(String(newText)) == true {
      return askParent(textField, range, string)
    } else {
      // If new value is not valid, do not allow to use it.
      return false
    }
  }
  
  private var askParent: (_ textField: UITextField,
    _ range: NSRange,
    _ replacementString: String) -> Bool {
    
    let parentMethod = parent?.textField(_:shouldChangeCharactersIn:replacementString:)
    
    return parentMethod ?? alwaysAllow
  }
  
  private var alwaysAllow: (_ textField: UITextField,
    _ range: NSRange,
    _ replacementString: String) -> Bool {
    return { _, _, _ in true }
  }
}
