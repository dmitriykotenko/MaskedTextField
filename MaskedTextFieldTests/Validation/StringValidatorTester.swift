import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when editing a text field.
class StringValidatorTester: XCTestCase {
  
  var validator: StringValidator = StringValidators.empty
  var tag: String = "anything"
  
  func assertSuccess(string: String) {
    let change = TextChange(
      oldText: "",
      replacementRange: .init(location: 0, length: 0),
      replacementString: string
    )

    if validator.isValid(change) == false {
      XCTFail(
        "String \"\(string)\" must be considered valid when entering \(tag)."
      )
    }
  }
  
  func assertError(string: String) {
    let change = TextChange(
      oldText: "",
      replacementRange: .init(location: 0, length: 0),
      replacementString: string
    )

    if validator.isValid(change) == true {
      XCTFail(
        "String \"\(string)\" must be considered invalid when entering \(tag)."
      )
    }
  }
}
