import UIKit


class ViewController: UIViewController {
    
    let maskedTextField: UITextField = MaskedTextField(decorationTemplate: "__:__")
    let anotherMaskedTextField = MaskedTextField(decorationTemplate: "__∞∞__")
    var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMaskedTextField()
        addAnotherMaskedTextField()
        addKeyValueObserverForMaskedTextField()
    }

    fileprivate func addMaskedTextField() {
        // Do any additional setup after loading the view, typically from a nib.
        
        maskedTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maskedTextField)
        
        maskedTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        maskedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        maskedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        maskedTextField.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
    }

    fileprivate func addAnotherMaskedTextField() {
        // Do any additional setup after loading the view, typically from a nib.
        
        anotherMaskedTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(anotherMaskedTextField)
        
        anotherMaskedTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        anotherMaskedTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        anotherMaskedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        anotherMaskedTextField.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
    }
    
    fileprivate func addKeyValueObserverForMaskedTextField() {
        maskedTextField.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
//        observation = maskedTextField.observe(\.text) { (textField, change) in
//            print("Change's kind is «\(String(describing: change.kind))».")
//            print("New text is «\(String(describing: change.newValue))».")
//        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let object = object as? UITextField else { return }
        if object == maskedTextField && keyPath == "text" {
            let newText = change![.newKey]
            print("Text is changed to «\(String(describing: newText))».")
        }
    }
}

