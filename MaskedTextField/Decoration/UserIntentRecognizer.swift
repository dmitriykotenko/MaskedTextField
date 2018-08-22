import UIKit


/// Recognizes user's intent when editing a text field.
/// For example, when the user taps “Backspace”, user's intent is not to erase
/// the closest character to the left of the caret. Instead, the intent is
/// to erase the closest significant character to the left of the caret.
class UserIntentRecognizer {
    
    private var textField: MaskedTextField
    
    init(textField: MaskedTextField) {
        self.textField = textField
    }
    
    func recognize(intent: TextReplacementOperation) -> TextReplacementOperation {
        let correctedRange = convertRangeFrom(utf16range: intent.rangeToBeReplaced)
        
        let correctedIntent = TextReplacementOperation(
            rangeToBeReplaced: correctedRange,
            replacementString: intent.replacementString
        )
        
        return expandRangeIfNecessary(correctedIntent)
    }
    
    private func convertRangeFrom(utf16range: NSRange) -> NSRange {
        if let decoratedText = textField.decoratedText {
            return decoratedText.rangeFromUtf16Range(utf16range)
        } else {
            return utf16range
        }
    }
    
    private func expandRangeIfNecessary(_ replacement: TextReplacementOperation) -> TextReplacementOperation {
        let replacementString = replacement.replacementString
        var range = replacement.rangeToBeReplaced
        
        if shouldExpandRangeToFirstSignificantCharacter(replacement: replacement) {
            range = expandToFirstSignificantCharacter(range: replacement.rangeToBeReplaced)
        }
        
        return TextReplacementOperation(
            rangeToBeReplaced: range,
            replacementString: replacementString
        )
    }
    
    private func shouldExpandRangeToFirstSignificantCharacter(replacement: TextReplacementOperation) -> Bool {
        let firstReplacedCharacterIsSignificant =
            textField.decoratedText?.isCharacterSignificant(at: replacement.rangeToBeReplaced.location) ?? false
        
        return replacement.replacementString.isEmpty
            && replacement.rangeToBeReplaced.length > 0
            && textField.selectedRange?.length == 0
            && !firstReplacedCharacterIsSignificant
    }
    
    private func expandToFirstSignificantCharacter(range: NSRange) -> NSRange {
        if let firstSignificantCharacterPosition =
            textField.decoratedText?.indexOfFirstSignificantCharacter(toTheLeftFrom: range.location) {
            
            let expandedLength = range.length + (range.location - firstSignificantCharacterPosition)
            
            let expandedRange = NSRange(
                location: firstSignificantCharacterPosition,
                length: expandedLength
            )
            
            return expandedRange
        } else {
            return range
        }
    }
}


fileprivate extension UITextInput {
    
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else {
            return nil
        }
        
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        
        return NSRange(location: location, length: length)
    }
}
