import Foundation


public enum StringSanitizers {
  
  public static let empty: StringSanitizer = FunctionStringSanitizer { $0 }
  
  public static func prohibitedCharactersSanitizer(_ prohibited: CharacterSet) -> StringSanitizer {
    return FunctionStringSanitizer { string in
      string.filter {
        $0.unicodeScalars.filter(prohibited.contains).isEmpty
      }
    }
  }
}
