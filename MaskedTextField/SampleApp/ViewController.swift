import UIKit


class ViewController: UIViewController {
  
  let maskedTextField: MaskedTextField = MaskedTextField(
    decoration: .template("__:__"),
    sanitization: .accept(.decimalDigits),
    validation: .function({ $0.count <= 4 })
  )
  
  let anotherMaskedTextField = MaskedTextField(decoration: .template("__∞∞__"))
  
  let uiTextField = UITextField()

  var observation: NSKeyValueObservation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addMaskedTextField()
    addAnotherMaskedTextField()
    addUiTextField()
    addKeyValueObserverForMaskedTextField()
  }
  
  private func addMaskedTextField() {
    maskedTextField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(maskedTextField)
    
    maskedTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
    maskedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    maskedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    maskedTextField.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
  }
  
  private func addAnotherMaskedTextField() {
    anotherMaskedTextField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(anotherMaskedTextField)
    
    anotherMaskedTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
    anotherMaskedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    anotherMaskedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    anotherMaskedTextField.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
  }
  
  private func addUiTextField() {
    uiTextField.textContentType = .telephoneNumber
    uiTextField.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(uiTextField)
    
    uiTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 240).isActive = true
    uiTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    uiTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    uiTextField.backgroundColor = UIColor.red.withAlphaComponent(0.1)
  }

  private func addKeyValueObserverForMaskedTextField() {
    maskedTextField.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    guard let object = object as? UITextField else { return }
    if object == maskedTextField && keyPath == "text" {
      let newText = change![.newKey]
      print("Text is changed to «\(String(describing: newText))».")
    }
  }
}

