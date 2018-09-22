import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when entering dates via numeric keyboard.
class PartialDateValidatorTests: StringValidatorTester {
  
  override func setUp() {
    super.setUp()
    
    validator = StringValidators.partialDate
    tag = "date"
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
  
  func testThatEightDigitsStringIsAllowed() {
    assertSuccess(string: "12345678")
  }
  
  func testThatStringContainingSpacesIsProhibited() {
    assertError(string: "2 3")
  }
  
  func testThatStringContainingLettersIsProhibited() {
    assertError(string: "ABC")
  }
  
  func testThatNineDigitsStringIsProhibited() {
    assertError(string: "123456789")
  }
  
  func testThatLongStringIsProhibited() {
    assertError(string: "1161111111111111111111111111111")
  }
}
