//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: Input

//: Part 1

func reallocate(_ banks: [Int]) -> [Int] {
    let maxIndex: Int = {
        var maxIndex = 0
        for (i, n) in banks.enumerated() {
            if n > banks[maxIndex] {
                maxIndex = i
            }
        }
        return maxIndex
    }()
    
    var newBank = banks
    
    newBank[maxIndex] = 0
    var blocksToMove = banks[maxIndex]
    
    var currentIndex = maxIndex
    while blocksToMove > 0 {
        currentIndex += 1
        if currentIndex > banks.count - 1 {
            currentIndex = 0
        }
        
        newBank[currentIndex] += 1
        blocksToMove -= 1
    }
    
    return newBank
}

func part1(_ input: [Int]) -> Int {
    // [Int] is not hashable so we need to convert [Int] to String to have a set of them
    func bankToSetItem(_ bank: [Int]) -> String {
        return bank.reduce("", { $0 + String($1) })
    }
    var knownStates: Set<String> = Set()
    knownStates.insert(bankToSetItem(input))
    
    var redistributions = 0
    var currentBank = input
    while true {
        currentBank = reallocate(currentBank)
        redistributions += 1
        
        let setItem = bankToSetItem(currentBank)
        if knownStates.contains(setItem) {
            break
        }
        knownStates.insert(setItem)
    }
    
    return redistributions
}

//reallocate([0,2,7,0])
part1([0,2,7,0]) ==> 5
//part1([0,5,10,0,11,14,13,4,11,8,8,7,1,4,12,11]) ==> 7864

//: Part 2

func part2(_ input: [Int]) -> Int {
    var knownStates = [input]
    
    var currentBank = input
    while true {
        currentBank = reallocate(currentBank)
        
        let foundIndex = knownStates.index(where: { $0 == currentBank })
        if  let index = foundIndex {
            let loopSize = knownStates.count - index
            return loopSize
        }
        knownStates.append(currentBank)
    }
}

part2([0,2,7,0]) ==> 4
//part2([0,5,10,0,11,14,13,4,11,8,8,7,1,4,12,11]) ==> 1695

//: [Next](@next)
