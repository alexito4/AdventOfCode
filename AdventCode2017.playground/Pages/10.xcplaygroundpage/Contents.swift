//: [Previous](@previous)

import Foundation

extension Array {
    
    public func shifted(by times: Int = 1) -> Array {
        var copy = self
        copy.shift(by: times)
        return copy
    }
    
    public mutating func shift(by times: Int = 1) {
        guard self.count > 1 else {
            return
        }
        let forward = times > 0
        var pendingTimes = abs(times)
        while pendingTimes > 0 {
            defer { pendingTimes -= 1 }
            
            if forward {
                let l = self.popLast()!
                self.insert(l, at: 0)
            } else {
                let f = self.removeFirst()
                self.append(f)
            }
        }
    }
    
    //    [].shifted().count == 0
    //    [1].shifted() ==> [1]
    //    [1,2].shifted() ==> [2, 1]
    //    [1,2,3,4,5,6,7,8,9,0].shifted() ==> [0,1,2,3,4,5,6,7,8,9]
    //
    //    [].shifted(by: -1).count == 0
    //    [1].shifted(by: -1) ==> [1]
    //    [1,2].shifted(by: -1) ==> [2, 1]
    //    [1,2,3,4,5,6,7,8,9,0].shifted(by: -1) ==> [2,3,4,5,6,7,8,9,0,1]
    //
    //    [].shifted(by: 2).count == 0
    //    [1].shifted(by: 2) ==> [1]
    //    [1,2].shifted(by :2) ==> [1, 2]
    //    [1,2,3,4,5,6,7,8,9,0].shifted(by: 2) ==> [9, 0,1,2,3,4,5,6,7,8]
    //
    //    [].shifted(by: -2).count == 0
    //    [1].shifted(by: -2) ==> [1]
    //    [1,2].shifted(by: -2) ==> [1, 2]
    //    [1,2,3,4,5,6,7,8,9,0].shifted(by: -2) ==> [3,4,5,6,7,8,9,0,1,2]
    
}

var str = "Hello, playground"

func round(list: Array<Int>, lengths: Array<Int>) -> Array<Int> {
    return round(list: list, lengths: lengths, currentPosition: 0, skipSize: 0).result
}

func round(list: Array<Int>, lengths: Array<Int>, currentPosition: Int, skipSize: Int) -> (position: Int, skipSize: Int, result: Array<Int>) {
    var list = list
    var currentPosition = currentPosition
    var skipSize = skipSize
    
    for length in lengths {
//        let start = currentPosition
//        let end = currentPosition + length
        
        var shifted = list.shifted(by: -currentPosition)
        
        var sublist = shifted[..<length]
        sublist.reverse()
        shifted.replaceSubrange(..<length, with: sublist)
        
        list = shifted.shifted(by: currentPosition)
        
        currentPosition += length + skipSize
        skipSize += 1
    }
    return (currentPosition, skipSize, list)
}

print("--------")
//var list = Array(0...255)
//let lengths = [76,1,88,148,166,217,130,0,128,254,16,2,130,71,255,229]
//list = round(list: list, lengths: lengths)
//print(list)
//let first = list[0]
//let second = list[1]
//let check = first * second
//print(check)

// Part 2

// Input to bytes using ascii codes
let bytes = "76,1,88,148,166,217,130,0,128,254,16,2,130,71,255,229".utf8
//let bytes = "1,2,4".utf8

// Add extra lengths to the sequence
let lengths = (bytes + [17, 31, 73, 47, 23]).map({ Int($0) })

var prevList = Array(0...255)
var prevPosition = 0
var prevSkip = 0

// Doing this iterations is slow and gets slower on each one. It would be an interesting exercice to invesitage where all the time goes and how can be improved.

for i in 1...64 {
    print("Iteration \(i)")
    let (p, s, list) = round(list: prevList, lengths: lengths, currentPosition: prevPosition, skipSize: prevSkip)
    prevList = list
    prevPosition = p
    prevSkip = s
    
//    print(list)
//    print(p)
//    print(s)
//    print("-")
}

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

func leftPadHex(_ hex: String) -> String {
    if hex.count > 1 {
        return hex
    }
    return "0" + hex
}

let sparseHash = prevList
let splitHash = sparseHash.chunks(16)
//splitHash
//splitHash.count
let denseHash = splitHash.reduce([], { acc, part in
    return acc + [part.reduce(0, { $0 ^ $1 })]
})
print(denseHash)
let knot = denseHash.reduce("", { $0 + leftPadHex(String($1, radix: 16)) })
print(knot)

//: [Next](@next)
