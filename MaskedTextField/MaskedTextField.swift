import UIKit


/// Enhanced text field:
///
/// — automatically places auxiliary characters during the editing
/// — does not allow the user to enter some invalid texts
///
/// .text property contains only significant characters – i. e. the characters entered by the user.
/// For instance, when the decoration template is "+_ ___ ___-__-__" and the user entered a phone number +7 900 816-04-28, .text property contains the value "79008160428". Spaces, dashes and plus sign are not visible outside.
public class MaskedTextField: UITextField {
  
  public override var delegate: UITextFieldDelegate? {
    set {
      decorationEngine?.parent = newValue
    }
    
    get {
      return decorationEngine?.parent
    }
  }
  
  public override var text: String? {
    set {
      decoratedText = newValue.map(decorator.decorate)
      
      super.text = decoratedText?.value
    }
    
    get {
      return decoratedText?.significantValue
    }
  }
  
  /// Text field's current text with every character marked as significant or not significant.
  var decoratedText: DecoratedString?
  
  /// Sets a template to place auxiliary characters.
  /// E. g., the template for the phone number could be "+_ ___ ___-__-__".
  /// Underscores represent text entered by the user.
  /// Every character except underscore is auxiliary.
  func setDecorationTemplate(_ decorationTemplate: String) {
    decorator = TemplateStringDecorator(template: decorationTemplate)
  }
  
  /// The rules to place auxiliary characters in elaborate cases (when the decoration template is not sufficient).
  func setDecorator(_ decorator: StringDecorator) {
    self.decorator = decorator
  }
  
  /// Sets a filter which recognizes invalid values and does not allow to enter these values.
  func setValidator(_ validator: @escaping Validator<String>) {
    validationEngine?.validator = validator
  }
  
  private var decorator: StringDecorator = EmptyStringDecorator()
  private var decorationEngine: TextFieldDecorationEngine?
  private var validationEngine: TextFieldValidationEngine?
  
  private var delegatesChain: [TextFieldDelegateProxy] = []
  private var externalDelegate = TextFieldSurgeon()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    privateInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    privateInit()
  }
  
  /// Creates MaskedTextField with predefined decoration template.
  ///
  /// - parameters:
  ///     - decorationTemplate: A template to place auxiliary characters during the editing. E. g. for phone numbers the template could be "+_ ___ ___-__-__". Underscores represent text entered by the user. All other characters are auxiliary and placed automatically during the editing.
  ///     - validator: A filter that prohibits the user to change field's text if new text is inappropriate. E. g. when entering time of day, the text is appropriate if it contains only digits and its length is less than or equal to 4.
  public convenience init(decorationTemplate: String = "",
                          validator: @escaping (String?) -> Bool = { _ in true }) {
    self.init(frame: .zero)
    
    setDecorationTemplate(decorationTemplate)
    setValidator(validator)
  }
  
  private func privateInit() {
    decorationEngine = TextFieldDecorationEngine(textField: self)
    
    guard let decorationEngine = decorationEngine else {
      fatalError("Could not initialize TextFieldDecorationEngine.")
    }
    
    validationEngine = TextFieldValidationEngine()
    
    guard let validationEngine = validationEngine else {
      fatalError("Could not initialize TextFieldValidationEngine.")
    }
    
    setupDelegatesChain([decorationEngine, validationEngine])
  }
  
  /// Build delegates chain for the text field.
  ///
  /// The first delegate in the chain connects directly to the text field.
  /// The last delegate in the chain connects to external delegate.
  private func setupDelegatesChain(_ delegates: [TextFieldDelegateProxy]) {
    delegatesChain = delegates
    
    // The first delegate in the chain connects directly to the text field.
    super.delegate = delegatesChain.first
    
    // Every subsequent delegate connects to its predecessor.
    if delegatesChain.count > 1 {
      let parents = delegatesChain.suffix(from: 1)
      
      for (child, parent) in zip(delegatesChain, parents) {
        child.parent = parent
      }
    }
    
    // The last delegate in the chain is connected to external delegate.
    delegatesChain.last?.parent = externalDelegate
  }
}
