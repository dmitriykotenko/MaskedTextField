import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when entering russian international passport numbers.
class PartialInternationalPassportNumberValidatorTests: StringValidatorTester {
  
  override func setUp() {
    super.setUp()
    
    validator = StringValidators.partialInternationalPassportNumber
    tag = "russian international passport number"
  }
  
  func testThatEmptyStringIsAllowed() {
    assertSuccess(string: "")
  }
  
  func testThatSingleDigitIsAllowed() {
    assertSuccess(string: "0")
  }
  
  func testThatShortNumberStringIsAllowed() {
    assertSuccess(string: "8001")
  }
  
  func testThatNineDigitsStringIsAllowed() {
    assertSuccess(string: "123456789")
  }
  
  func testThatStringContainingSpacesIsProhibited() {
    assertError(string: "2 3")
  }
  
  func testThatStringContainingLettersIsProhibited() {
    assertError(string: "ABC")
  }
  
  func testThatTenDigitsStringIsProhibited() {
    assertError(string: "0123456789")
  }
}
