public class TimeStringDecorator: StringDecorator {
  
  public func decorate(_ string: String) -> DecoratedString {
    var decoratedCharacters = string.map {
      DecoratedCharacter.significant($0)
    }
    
    if decoratedCharacters.count > 2 {
      let colon = DecoratedCharacter.insignificant(":")
      decoratedCharacters.insert(colon, at: 2)
    }
    
    return DecoratedString(characters: decoratedCharacters)
  }
}
