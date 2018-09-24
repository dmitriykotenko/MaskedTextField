import UIKit


/// Enhanced text field:
///
/// — automatically places auxiliary characters during the editing
/// — does not allow the user to enter some invalid texts
///
/// .text property contains only significant characters – i. e. the characters entered by the user.
/// For instance, when the decoration template is "+_ ___ ___-__-__" and the user sees a phone number +7 900 816-04-28 on the screen, .text property will contain the value "79008160428". Spaces, dashes and plus sign are not visible outside.
public class MaskedTextField: UITextField {
  
  public override var delegate: UITextFieldDelegate? {
    set {
      externalDelegate.parent = newValue
    }
    
    get {
      return externalDelegate.parent
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
  
  /// Sets rules to place auxiliary characters when editing a text field.
  ///
  /// In most cases the rules can be described as some template.
  /// E. g., the template for the phone number could be "+_ ___ ___-__-__".
  /// (In this case, when the user enters "79001113355", the onscreen text will be +7 900 111-33-55".).
  /// Underscores represent text entered by the user.
  /// Every character except underscore considered auxiliary.
  ///
  /// For elaborate cases, custom decorator can be specified via .custom option.
  func setDecoration(_ decoration: TextFieldDecoration) {
    switch decoration {
    case .none:
      decorator = EmptyStringDecorator()
    case .template(let template):
      decorator = TemplateStringDecorator(template: template)
    case .custom(let customDecorator):
      decorator = customDecorator
    }

    // Synchronize .text property with new decorator.
    applyDecoration()
  }
  
  private func applyDecoration() {
    let currentText = text
    text = currentText
  }
  
  /// Sets a filter which recognizes invalid values and does not allow to enter these values.
  func setValidation(_ validation: TextFieldValidation) {
    switch validation {
    case .none:
      validationEngine?.validator = StringValidators.empty
    case .maximumLength(let length):
      validationEngine?.validator = StringValidators.maximumLengthValidator(length)
    case .regex(let pattern):
      validationEngine?.validator = StringValidators.regexValidator(pattern)
    case .custom(let customValidator):
      validationEngine?.validator = customValidator
    }    
  }
  
  private var decorator: StringDecorator = EmptyStringDecorator()
  private var decorationEngine: TextFieldDecorationEngine?
  private var validationEngine: TextFieldValidationEngine?
  
  private var delegatesChain: [TextFieldDelegateProxy] = []
  private var externalDelegate: TextFieldDelegateProxy = TextFieldSurgeon()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    privateInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    privateInit()
  }
  
  /// Creates MaskedTextField with predefined decoration and validation.
  ///
  /// - parameters:
  ///     - decoration: Rules to place auxiliary characters during the editing. E. g. for phone numbers the rules can be described as a template "+_ ___ ___-__-__". (Underscores represent text entered by the user. All other characters are auxiliary and placed automatically during the editing.) Default value is .none which means no decoration.
  ///     - validation: A filter that prohibits the user to change field's text if new text is inappropriate. E. g. when entering time of day, the text is appropriate if it contains only digits and its length is less than or equal to 4. Default value is .none and means everything is valid.
  ///
  /// Validation works only for user-initiated changes. It does not wok when .text property is changed programmatically.
  /// Decoration works for both programmatic and user-initiated changes.
  public convenience init(decoration: TextFieldDecoration = .none,
                          validation: TextFieldValidation = .none) {
    self.init(frame: .zero)
    
    setDecoration(decoration)
    setValidation(validation)
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
  /// The .externalDelegate connects to the last delegate in the chain.
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
    
    // The external delegate connects to the last delegate in the chain.
    delegatesChain.last?.parent = externalDelegate
  }
}
