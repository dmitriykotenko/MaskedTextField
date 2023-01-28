public class EmptyStringDecorator: StringDecorator {
  
  public func decorate(_ string: String) -> DecoratedString {
    DecoratedString(
      characters: string.map {
        DecoratedCharacter.significant($0)
      }
    )
  }
}
