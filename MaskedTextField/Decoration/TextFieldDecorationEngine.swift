import UIKit


/// Automatically places auxiliary characters during editing of a text field.
class TextFieldDecorationEngine: TextFieldDelegateProxy {

    private var textField: MaskedTextField
    private var userIntentRecognizer: UserIntentRecognizer

    init(textField: MaskedTextField) {
        self.textField = textField

        userIntentRecognizer = UserIntentRecognizer(textField: textField)
    }

    override func textField(_ textField: UITextField,
                            shouldChangeCharactersIn range: NSRange,
                            replacementString string: String) -> Bool {

        let userIntent = TextReplacementOperation(
            rangeToBeReplaced: range,
            replacementString: string
        )

        let replacement = userIntentRecognizer.recognize(intent: userIntent)

        performReplacement(replacement)

        return false
    }

    private func performReplacement(_ replacement: TextReplacementOperation) {
        let significantReplacement = convertToSignificantReplacement(replacement)

        if significantReplacement.isEmpty {
            performEmptyReplacement()
        } else {
            if shouldPerformReplacement(significantReplacement) {
                performSignificantReplacement(significantReplacement)
            }
        }
    }

    private func convertToSignificantReplacement(_ replacement: TextReplacementOperation) -> TextReplacementOperation {
        return TextReplacementOperation(
            rangeToBeReplaced: significantRange(from: replacement.rangeToBeReplaced),
            replacementString: replacement.replacementString
        )
    }

    private func significantRange(from range: NSRange) -> NSRange {
        if let decoratedText = textField.decoratedText {
            return decoratedText.significantRange(from: range)
        } else {
            return range
        }
    }

    private func performEmptyReplacement() {
        if let currentRange = textField.selectedTextRange {
            let desiredRange = textField.textRange(from: currentRange.start, to: currentRange.start)

            textField.selectedTextRange = desiredRange
        }
    }

    /// Asks text field's delegate whether we need to perform text replacement.
    private func shouldPerformReplacement(_ replacement: TextReplacementOperation) -> Bool {
        if let method = parent?.textField(_:shouldChangeCharactersIn:replacementString:) {
            return method(
                textField,
                replacement.rangeToBeReplaced,
                replacement.replacementString
            )
        } else {
            return true
        }
    }

    private func performSignificantReplacement(_ replacement: TextReplacementOperation) {
        assert(!replacement.isEmpty)

        let currentText = textField.text ?? ""

        textField.text = NSString(string: currentText).replacingCharacters(
            in: significantUtf16range(from: replacement.rangeToBeReplaced),
            with: replacement.replacementString
        ).description

        adjustCaretPosition(after: replacement)
    }

    private func significantUtf16range(from significantRange: NSRange) -> NSRange {
        guard let decoratedText = textField.decoratedText else {
            return significantRange
        }

        return decoratedText.significantUtf16range(from: significantRange)
    }

    /// Moves the caret to desired position after the text replacement is complete.
    private func adjustCaretPosition(after replacement: TextReplacementOperation) {
        guard let decoratedText = textField.decoratedText else {
            return
        }

        let significantRangeEnd = replacement.rangeToBeReplaced.location + replacement.replacementString.count
        let decoratedRangeEnd = decoratedText.index(from: significantRangeEnd)
        
        let indexOfNextSignificantCharacter = decoratedText.indexOfFirstSignificantCharacter(
            toTheRightFrom: decoratedRangeEnd
        )
            
        let desiredCaretOffset = indexOfNextSignificantCharacter ?? decoratedText.value.count
        let utf16DesiredCaretOffset = decoratedText.utf16indexFromIndex(desiredCaretOffset)

        setCaretPosition(offset: utf16DesiredCaretOffset)
    }
    
    private func setCaretPosition(offset: Int) {
        if let desiredCaretPosition = textField.position(from: textField.beginningOfDocument, offset: offset) {
            textField.selectedTextRange = textField.textRange(from: desiredCaretPosition, to: desiredCaretPosition)
        }
    }
}
