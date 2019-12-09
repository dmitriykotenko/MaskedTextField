import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when editing a text field.
class StringValidatorTester: XCTestCase {
  
  var validator: StringValidator = StringValidators.empty
  var tag: String = "anything"
  
  func assertSuccess(string: String) {
    if validator.isValid(string) == false {
      XCTFail(
        "String \"\(string)\" must be considered valid when entering \(tag)."
      )
    }
  }
  
  func assertError(string: String) {
    if validator.isValid(string) == true {
      XCTFail(
        "String \"\(string)\" must be considered invalid when entering \(tag)."
      )
    }
  }
}
