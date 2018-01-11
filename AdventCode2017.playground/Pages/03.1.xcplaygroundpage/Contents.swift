//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//let input = 368078
//
//func process(_ input: Int) -> Int {
//    var steps = 0
//    var num = input
//    while num > 1 {
//        defer { steps += 1 }
//        
//        if num % 2 == 0 {
//            num -= 1
//        } else {
//            num -= 2
//        }
//    }
//    return steps
//}
//
//process(1) ==> 0
//process(12) ==> 3
//process(23) ==> 2
//process(1024) ==> 31
//
//process(2) ==> 1
//process(3) ==> 1
//process(4) ==> 1

let input = 347991
let side = Int(ceil(sqrt(Double(input))))
let maxValue = side * side

var array = Array(repeatElement(Array(repeatElement(0, count: side)), count: side))

enum Direction {
    case top, bottom, left, right
}

let middle = Int(ceil(Double(side) / 2)) - 1
var x = middle
var y = middle
var direction: Direction = .right

array[x][y] = 1

for i in 1...maxValue {
    var value = array[x - 1][y] + array[x + 1][y] + array[x][y - 1]
    value += array[x][y + 1] + array[x + 1][y + 1] + array[x + 1][y - 1]
    value += array[x - 1][y + 1] + array[x - 1][y - 1] + array[x][y]
    //        if i == input {
    //            print("Result1:", abs(x - middle) + abs(y - middle))
    //            break
    //        }
    //        array[x][y] = i
    array[x][y] = value
    if value > input {
        print("Result2:", value)
        break
    }
    switch direction {
    case .bottom:
        if array[x][y - 1] == 0 {
            y -= 1
            direction = .right
        } else {
            x -= 1
        }
    case .right:
        if array[x + 1][y] == 0 {
            x += 1
            direction = .top
        } else {
            y -= 1
        }
    case .top:
        if array[x][y + 1] == 0 {
            y += 1
            direction = .left
        } else {
            x += 1
        }
    case .left:
        if array[x - 1][y] == 0 {
            x -= 1
            direction = .bottom
        } else {
            y += 1
        }
    }
}


//: [Next](@next)
