import Foundation

public func countLetters(_ word: String) -> Dictionary<Character, Int> {
    return word.reduce([:]) { (acc, c: Character) in
        var copy = acc
        copy[c, default: 0] += 1
        return copy
    }
}
