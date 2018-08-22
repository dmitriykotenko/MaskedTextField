/// Helpful character sets.
extension String {

    /// Roman digits (both uppercased and lowercased).
    static var romanDigits: String {
        let lowercasedDigits = "ivxlcdm"
        let uppercasedDigits = lowercasedDigits.uppercased()
        
        return lowercasedDigits + uppercasedDigits
    }

    /// Russian letters (both uppercased and lowercased).
    static var cyrillicLetters: String {
        let lowercasedLetters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
        let uppercasedLetters = lowercasedLetters.uppercased()
        
        return lowercasedLetters + uppercasedLetters
    }
}
