import XCTest
@testable import MaskedTextField


/// Tests for engine which filters unwanted values when entering russian birth certificate numbers.
class PartialBirthCertificateNumberValidatorTests: StringValidatorTester {
  
  override func setUp() {
    super.setUp()
    
    validator = StringValidators.partialBirthCertificateNumber
    tag = "russian birth certificate number"
  }
  
  func testThatEmptyStringIsAllowed() {
    assertSuccess(string: "")
  }
  
  func testThatSingleRomanDigitIsAllowed() {
    assertSuccess(string: "i")
    assertSuccess(string: "v")
    assertSuccess(string: "x")
    assertSuccess(string: "l")
    assertSuccess(string: "c")
    assertSuccess(string: "d")
    assertSuccess(string: "m")
  }
  
  func testThatSingleDigitIsAllowed() {
    assertSuccess(string: "0")
  }
  
  func testThatSingleRussianLetterIsAllowed() {
    assertSuccess(string: "ъ")
  }
  
  func testThatLetterYoIsAllowed() {
    assertSuccess(string: "ё")
  }
  
  func testThatStringWithoutRomanLettersIsAllowed() {
    assertSuccess(string: "ыю123456")
  }
  
  func testThatIncompleteBirthCertificateNumberIsAllowed() {
    assertSuccess(string: "Lё123")
  }
  
  func testThatLowercasedBirthCertificateNumberIsAllowed() {
    assertSuccess(string: "iiаб654321")
  }
  
  func testThatUppercasedBirthCertificateNumberIsAllowed() {
    assertSuccess(string: "IIГФ654321")
  }
  
  func testThatWhitespacesStringIsProhibited() {
    assertError(string: "   ")
  }
  
  func testThatStringContainingDashesAndSpacesIsProhibited() {
    assertError(string: "XIX-ёЪ №123456")
  }
  
  func testThatSevenDigitsAreProhibited() {
    assertError(string: "IVжй1234567")
  }
  
  func testThatElevenRomanDigitsAreProhibited() {
    assertError(string: "CMMMDIVLLLDжй123456")
  }
}
