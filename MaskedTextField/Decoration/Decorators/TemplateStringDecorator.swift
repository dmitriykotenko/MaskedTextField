class TemplateStringDecorator: StringDecorator {

    private static let defaultPlaceholder = "_"

    private var template: String
    private var prefix: String
    private var suffixes: [String]

    init(template: String, placeholder: String = defaultPlaceholder) {
        self.template = template

        let characterGroups = template.components(separatedBy: placeholder)

        prefix = characterGroups[0]
        suffixes = Array(characterGroups.dropFirst())
    }

    func decorate(_ string: String) -> DecoratedString {
        let decoratedBody = decorateBody(of: string)

        let decoratedCharacters = [decoratedPrefix, decoratedBody].flatMap { $0 }

        return DecoratedString(characters: decoratedCharacters)
    }

    private var decoratedPrefix: [DecoratedCharacter] {
        return prefix.map {
            insignificant($0)
        }
    }

    private func decorateBody(of string: String) -> [DecoratedCharacter] {
        return string.enumerated().flatMap {
            decorateCharacter($0.element, at: $0.offset)
        }
    }

    private func decorateCharacter(_ character: Character, at index: Int) -> [DecoratedCharacter] {
        var result = suffix(for: index).map {
            insignificant($0)
        }

        result.insert(significant(character), at: 0)

        return result
    }

    private func suffix(for index: Int) -> String {
        if index < suffixes.count {
            return suffixes[index]
        } else {
            return ""
        }
    }

    private func significant(_ character: Character) -> DecoratedCharacter {
        return DecoratedCharacter(
            character: character,
            isSignificant: true
        )
    }

    private func insignificant(_ character: Character) -> DecoratedCharacter {
        return DecoratedCharacter(
            character: character,
            isSignificant: false
        )
    }
}
