import XCTest
@testable import MaskedTextField


/// Tests for validator which considers any string valid.
class EmptyValidatorTests: StringValidatorTester {
  
  override func setUp() {
    super.setUp()
    
    validator = StringValidators.empty
    tag = "anything"
  }
  
  func testThatEmptyStringIsAllowed() {
    assertSuccess(string: "")
  }
  
  func testThatSingleDigitIsAllowed() {
    assertSuccess(string: "0")
  }
  
  func testThatSingleRussianLetterIsAllowed() {
    assertSuccess(string: "ъ")
  }
  
  func testThatWhitespacesStringIsAllowed() {
    assertSuccess(string: "   ")
  }
  
  func testThatSingleEnglishWordIsAllowed() {
    assertSuccess(string: "danger")
  }

  func testThatStringContainingPunctuationIsAllowed() {
    assertSuccess(string: "d@Wek(@348!123")
  }

  func testThatSingleSentenceIsAllowed() {
    assertSuccess(string: "I take a healthy bite from your dainty fingertips.")
  }
  
  func testThatVeryLongStringContainingDifferentCharactersIsAllowed() {
    assertSuccess(string: "Amd@3438!*$ LDFKJ  skdf@34kjs*\njklj29фываУывлао©®™₷   < “”«¹²³‰↑")
  }
}
