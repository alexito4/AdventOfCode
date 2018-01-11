//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: Input

let content = testData()
let list = content.split(separator: "\n").map({ Int($0)! })

//: Part 1

func process(_ input: [Int]) -> Int {
    var memory = input
    var count = 0
    var pc = 0
    
    while pc >= 0 && pc < memory.count {
        count += 1
        
        let op = memory[pc]
        memory[pc] += 1
        pc += op
    }
    
    return count
}

process([0,3,0,1,-3]) ==> 5
//process(list) ==> 364539

//: Part 2

func process2(_ input: [Int]) -> Int {
    var memory = input
    var count = 0
    var pc = 0
    
    while pc >= 0 && pc < memory.count {
        count += 1
        
        let op = memory[pc]
        if op >= 3 {
            memory[pc] -= 1
        } else {
            memory[pc] += 1
        }
        pc += op
    }
    
    return count
}

process2([0,3,0,1,-3]) ==> 10
//process2(list) ==> 27477714

//: [Next](@next)
