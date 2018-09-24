import Foundation


public enum StringSanitizers {
  
  static let empty: Sanitizer<String> = { $0 }
  
  static func prohibitedCharactersSanitizer(_ prohibited: CharacterSet) -> Sanitizer<String> {
    return { string in
      string.filter {
        $0.unicodeScalars.filter(prohibited.contains).isEmpty
      }
    }
  }
}
