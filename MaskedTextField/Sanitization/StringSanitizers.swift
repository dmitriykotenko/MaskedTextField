import Foundation


public enum StringSanitizers {
  
  public static let empty: StringSanitizer = FunctionStringSanitizer { $0 }
  
  public static func prohibitedCharactersSanitizer(_ prohibited: CharacterSet) -> StringSanitizer {
    FunctionStringSanitizer { string in
      string.filter {
        $0.unicodeScalars.filter(prohibited.contains).isEmpty
      }
    }
  }
}
