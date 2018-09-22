import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when entering russian inland passport numbers.
class PartialRussianPassportNumberValidatorTests: StringValidatorTester {
  
  override func setUp() {
    super.setUp()
    
    validator = StringValidators.partialRussianPassportNumber
    tag = "russian inland passport number"
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
  
  func testThatTenDigitsStringIsAllowed() {
    assertSuccess(string: "0123456789")
  }
  
  func testThatStringContainingSpacesIsProhibited() {
    assertError(string: "2 3")
  }
  
  func testThatStringContainingLettersIsProhibited() {
    assertError(string: "ABC")
  }
  
  func testThatElevenDigitsStringIsProhibited() {
    assertError(string: "00123456789")
  }
}
