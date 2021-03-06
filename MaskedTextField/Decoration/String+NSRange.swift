import Foundation


extension String {
  
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let from16 = utf16.index(
        utf16.startIndex,
        offsetBy: nsRange.location,
        limitedBy: utf16.endIndex
      ),
      let to16 = utf16.index(
        utf16.startIndex,
        offsetBy: nsRange.location + nsRange.length,
        limitedBy: utf16.endIndex
      ),
      let from = from16.samePosition(in: self),
      let to = to16.samePosition(in: self)
      else { return nil }
    
    return from ..< to
  }
}
