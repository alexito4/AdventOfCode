//: [Previous](@previous)

import Foundation

var str = "Hello, playground"
print(str)
//: # Input

let content = testData()
let list = content.split(separator: "\n")

//: # Part 1

func countValidPassphrases(_ list: [String]) -> Int {
    func isValidPassphrase(_ phrase: String) -> Bool {
        let words = phrase.split(separator: " ")
        let originalCount = words.count
        
        let nonRepeated = Set(words)
        let nonRepeatedCount = nonRepeated.count
        
        return originalCount == nonRepeatedCount
    }
    
    return list
        .filter({ isValidPassphrase($0) })
        .count
}

countValidPassphrases(["aa bb cc dd ee"]) ==> 1
countValidPassphrases(["aa bb cc dd aa"]) ==> 0
countValidPassphrases(["aa bb cc dd aaa"]) ==> 1
countValidPassphrases(list.map(String.init))

//: # Part 2
func countValidPassphrases2(_ list: [String]) -> Int {
    func isValidPassphrase(_ phrase: String) -> Bool {
        let words = phrase.split(separator: " ").map(String.init)
        
        for (i, word) in words.enumerated() {

            let letters = countLetters(word)
            for other in words[i.advanced(by: 1)...] {
                guard word != other else {
                    return false
                }
                
                guard word.count == other.count else {
                    continue
                }
                
                
                let otherLetters = countLetters(other)
                if letters == otherLetters {
                    return false
                }
            }
        }
        
        return true
    }
    
    return list
        .filter({ isValidPassphrase($0) })
        .count
}

countValidPassphrases2(["abcde fghij"]) ==> 1
countValidPassphrases2(["abcde xyz ecdab"]) ==> 0
countValidPassphrases2(["a ab abc abd abf abj"]) ==> 1
countValidPassphrases2(["iiii oiii ooii oooi oooo"]) ==> 1
countValidPassphrases2(["oiii ioii iioi iiio"]) ==> 0
countValidPassphrases2(list.map(String.init))

print("DONE")
//: [Next](@next)
