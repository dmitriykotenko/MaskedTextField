/// Validators for different kinds of strings.
public enum StringValidators {
    
    static let empty: Validator<String> = { _ in true }
    
    static let partialDate: Validator<String> = { string in
        regexCheck(string, pattern: "^[0-9]{0,8}$")
    }
    
    static let partialRussianPassportNumber: Validator<String> = { string in
        regexCheck(string, pattern: "^[0-9]{0,10}$")
    }
    
    static let partialInternationalPassportNumber: Validator<String> = { string in
        regexCheck(string, pattern: "^[0-9]{0,9}$")
    }
    
    static let partialBirthCertificateNumber: Validator<String> = { string in
        let uppercasedString = string?.uppercased()
        
        let romanDigitsSection = "[" + String.romanDigits + "]{0,10}"
        let cyrillicLettersSection = "[" + String.cyrillicLetters + "]{0,2}"
        let digitsSection = "[0-9]{0,6}"
        
        return regexCheck(
            string,
            pattern: "^" + romanDigitsSection + cyrillicLettersSection + digitsSection + "$"
        )
    }
    
    static let partialForeignDocumentNumber: Validator<String> = { string in
        /// Only spaces are prohibited.
        return regexCheck(string, pattern: "^\\S*$")
    }
}


fileprivate func regexCheck(_ string: String?,
                            pattern: String) -> Bool {
    
    guard let string = string else {
        return true
    }
    
    return string.range(of: pattern, options: .regularExpression) != nil
}
