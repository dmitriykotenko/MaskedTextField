import Foundation


/// Kind of cleaning which is applied to text before inserting this text from the clipboard.
public enum TextFieldSanitization {

  /// Do not perform any sanitization.
  case none
  
  /// Remove all characters not belonging to specified character set.
  case accept(CharacterSet)
  
  /// Remove all characters belonging to specified character set.
  case reject(CharacterSet)
  
  /// Custom sanitization.
  case custom((String) -> String)
}
