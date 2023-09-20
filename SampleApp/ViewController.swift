import UIKit


class ViewController: UIViewController {
  
  let maskedTextField: MaskedTextField = MaskedTextField(
    decoration: .template("__:__"),
    sanitization: .accept(.decimalDigits),
    validation: .maximumLength(4)
  )
  
  let anotherMaskedTextField = MaskedTextField(decoration: .template("__∞∞__"))

  let maskedTextFieldWithSuffix: MaskedTextField = MaskedTextField(
    decoration: .template("___🤷🏽‍♀️___🇪🇷___", suffix: " руб-руб-руб."),
    sanitization: .accept(.decimalDigits),
    validation: .function { $0.newText.count <= 9 }
  )

  let uiTextField = UITextField()

  var observation: NSKeyValueObservation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addTextFields()
    addKeyValueObserverForMaskedTextField()
  }
  
  private func addTextFields() {
    addTextField(maskedTextField, topAnchor: 60, color: .orange)
    addTextField(anotherMaskedTextField, topAnchor: 120, color: .blue)
    addTextField( maskedTextFieldWithSuffix, topAnchor: 180, color: .green)

    uiTextField.textContentType = .telephoneNumber
    addTextField(uiTextField, topAnchor: 240, color: .red)
  }

  private func addTextField(_ textField: UITextField,
                            topAnchor: CGFloat,
                            color: UIColor) {
    textField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(textField)

    textField.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchor).isActive = true
    textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    textField.backgroundColor = color.withAlphaComponent(0.1)
  }

  private func addKeyValueObserverForMaskedTextField() {
    maskedTextField.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    guard let object = object as? UITextField else { return }
    if object == maskedTextField && keyPath == "text" {
      let newText = change![.newKey]
      print("Text is changed to «\(String(describing: newText))».")
    }
  }
}

