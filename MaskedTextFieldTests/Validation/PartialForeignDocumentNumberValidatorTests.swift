import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when entering non-russian identity numbers.
class PartialForeignDocumentNumberValidatorTests: StringValidatorTester {
  
  override func setUp() {
    super.setUp()
    
    validator = StringValidators.partialForeignDocumentNumber
    tag = "non-russian identity number"
  }
  
  func testThatEmptyStringIsAllowed() {
    assertSuccess(string: "")
  }
  
  func testThatSingleDigitIsAllowed() {
    assertSuccess(string: "6")
  }
  
  func testThatSingleLatinLetterIsAllowed() {
    assertSuccess(string: "w")
  }
  
  func testThatStringContainingOnlyLatinLettersAndDigitsIsAllowed() {
    assertSuccess(string: "123pqrstuv234234")
  }
  
  func testThatUppercasedLatinLettersAreAllowed() {
    assertSuccess(string: "X654321Q")
  }
  
  /// Русская буква — разрешённый символ при вводе номер иностранного докумнета.
  func testThatSingleRussianLetterIsAllowed() {
    assertSuccess(string: "ъ")
  }
  
  func testThatStringWithoutSpacesIsAllowed() {
    assertSuccess(string: "abcdEFgh-ж-1234567")
  }
  
  func testThatWhitespacesStringIsProhibited() {
    assertError(string: "   ")
  }
  
  func testThatStringContainingSpacesIsProhibited() {
    assertError(string: "wyx 123456")
  }
}
