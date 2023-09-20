import XCTest


class MaskedTextFieldUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false

    // UI tests must launch the application that they test.
    // Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests
    // before they run.
    // The setUp method is a good place to do this.
  }
  
  func testThatDecorationEngineWorks() {
    let app = XCUIApplication()
    let window = app.windows.element(boundBy: 0)
    
    let firstTextField = window.textFields.element(boundBy: 0)
    firstTextField.tap()
    
    app.keys["more"].tap()
    
    app.keys["2"].tap()
    app.keys["3"].tap()
    app.keys["5"].tap()
    app.keys["7"].tap()
    
    let firstTextFieldValue = firstTextField.value as? String
    XCTAssert(firstTextFieldValue == "23:57")
  }

  func testThatValidationEngineWorks() {
    let app = XCUIApplication()
    let window = app.windows.element(boundBy: 0)
    
    let firstTextField = window.textFields.element(boundBy: 0)
    firstTextField.tap()
    
    app.keys["more"].tap()
    
    app.keys["2"].tap()
    app.keys["3"].tap()
    app.keys["1"].tap()
    app.keys["5"].tap()
    app.keys["4"].tap()
    app.keys["7"].tap()
    
    let firstTextFieldValue = firstTextField.value as? String
    XCTAssert(firstTextFieldValue == "23:15")
  }
  
  func testThatSanitizationEngineWorks() {
    let app = XCUIApplication()
    let window = app.windows.element(boundBy: 0)
    
    let firstTextField = window.textFields.element(boundBy: 0)
    firstTextField.tap()
    
    app.keys["more"].tap()
    
    app.keys["2"].tap()
    app.keys["3"].tap()
    app.keys["space"].tap()
    app.keys["?"].tap()
    app.keys["4"].tap()
    app.keys["7"].tap()
    app.keys["space"].tap()

    app.keys["more"].tap()
    app.keys["x"].tap()
    app.keys["d"].tap()
    
    app.keys["more"].tap()
    app.keys["!"].tap()

    let firstTextFieldValue = firstTextField.value as? String
    XCTAssert(firstTextFieldValue == "23:47")
  }
}
