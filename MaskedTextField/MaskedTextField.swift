import UIKit


/// Text field which automatically places auxiliary characters during the editing.
///
/// .text property contains only significant characters – i. e. the characters entered by the user.
/// For instance, when the template is "+_ ___ ___-__-__" and the user entered a phone number +7 900 816-04-28, .text property contains the value "79008160428". Spaces, dashes and plus sign are not visible outside.
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

    private var decorator: StringDecorator = EmptyStringDecorator()
    private var decorationEngine: TextFieldDecorationEngine?
    
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
    public convenience init(decorationTemplate: String) {
        self.init(frame: .zero)
        
        decorator = TemplateStringDecorator(template: decorationTemplate)
    }
    
    private func privateInit() {
        decorationEngine = TextFieldDecorationEngine(textField: self)
        
        guard let decorationEngine = decorationEngine else {
            fatalError("Could not initialize TextFieldDecorationEngine.")
        }

        super.delegate = decorationEngine
    }
}
