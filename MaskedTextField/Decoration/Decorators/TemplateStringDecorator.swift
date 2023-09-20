class TemplateStringDecorator: StringDecorator {
  
  private static let defaultPlaceholder = "_"
  
  private var template: String
  private var prefix: String
  private var bodySuffixes: [String]
  private var globalSuffix: String?
  
  init(template: String,
       globalSuffix: String? = nil,
       placeholder: String = defaultPlaceholder) {
    self.template = template
    self.globalSuffix = globalSuffix

    let characterGroups = template.components(separatedBy: placeholder)
    
    prefix = characterGroups[0]
    bodySuffixes = Array(characterGroups.dropFirst())
  }
  
  func decorate(_ string: String) -> DecoratedString {
    let decoratedBody = decorateBody(of: string)

    let decoratedGlobalSuffix: [FlaggedCharacter] =
      (globalSuffix ?? "").map { .insignificant($0, caretGravity: .toBeginning) }

    let decoratedCharacters = [decoratedPrefix, decoratedBody, decoratedGlobalSuffix].flatMap { $0 }
    
    return DecoratedString(characters: decoratedCharacters)
  }
  
  private var decoratedPrefix: [FlaggedCharacter] {
    prefix.map { .insignificant($0) }
  }
  
  private func decorateBody(of string: String) -> [FlaggedCharacter] {
    string.enumerated().flatMap {
      decorateCharacter($0.element, at: $0.offset)
    }
  }
  
  private func decorateCharacter(_ character: Character,
                                 at index: Int) -> [FlaggedCharacter] {
    [.significant(character)] + suffix(for: index).map { .insignificant($0) }
  }
  
  private func suffix(for index: Int) -> String {
    if index < bodySuffixes.count {
      return bodySuffixes[index]
    } else {
      return ""
    }
  }
}
