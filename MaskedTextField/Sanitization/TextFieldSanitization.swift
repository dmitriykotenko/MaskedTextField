import Foundation


/// Kind of cleaning which is applied to text before inserting this text from the clipboard.
public enum TextFieldSanitization {

  /// Do not perform any sanitization.
  case none
  
  /// Remove all characters not belonging to specified character set.
  case accept(CharacterSet)
  
  /// Remove all characters belonging to specified character set.
  case reject(CharacterSet)
  
  /// Use given function as sanitizer.
  case function((String) -> String)

  /// Use custom sanitizer.
  case custom(StringSanitizer)
}
