//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let input = """
0: 4
1: 2
2: 3
4: 4
6: 8
8: 5
10: 8
12: 6
14: 6
16: 8
18: 6
20: 6
22: 12
24: 12
26: 10
28: 8
30: 12
32: 8
34: 12
36: 9
38: 12
40: 8
42: 12
44: 17
46: 14
48: 12
50: 10
52: 20
54: 12
56: 14
58: 14
60: 14
62: 12
64: 14
66: 14
68: 14
70: 14
72: 12
74: 14
76: 14
80: 14
84: 18
88: 14
"""

let test = """
0: 3
1: 2
4: 4
6: 4
"""

struct Scanner {
    let depth: Int
    let range: Int
}

struct Layer {
    let scanner: Scanner?
    var currentRange: Int
    var rangeChange: Int
}

struct State {
    var layers: [Layer]
    
    var packet = -1
    
    init(layers: [Layer]) {
        self.layers = layers
    }
    
    // If there is a scanner at the top of the layer as your packet enters it, you are caught.
    // So only call this after simulating the packet BUT BEFORE simulating the scanners
    func isCaught() -> Bool {
        let layer = layers[packet]
        guard let _ = layer.scanner else {
            return false
        }
        return layer.currentRange == 0
    }
    
    // Only useful if caught
    func severity() -> Int {
        let layer = layers[packet]
        guard let scanner = layer.scanner else {
            return 0
        }
        let depth = packet
        return depth * scanner.range
    }
    
    mutating func simulatePacket() {
        packet += 1
    }
    
    mutating func simulateScanners() {
        layers = layers.map {
            if let scanner = $0.scanner {
                var layer = $0
                if layer.currentRange == 0 {
                    layer.rangeChange = 1
                } else if layer.currentRange == scanner.range - 1 {
                    layer.rangeChange = -1
                }
                layer.currentRange += layer.rangeChange
                return layer
            } else {
                return $0
            }
        }
    }
    
    func display() {
        let layersNum = layers.enumerated().map({ " \($0.0)  " }).joined()
        print("\(layersNum)")
        
        let maxRange = scanners.max(by: { $0.range < $1.range })!.range
        for range in 1...maxRange {
            let rangeLine = layers.enumerated().map({ i, layer in
                if let scanner = layer.scanner, scanner.range >= range {
                    let s = layer.currentRange+1 == range ? "S" : " "
                    if range == 1 && packet == i {
                        return "(\(s)) "
                    } else {
                        return "[\(s)] "
                    }
                } else if range == 1 {
                    if packet == i {
                        return "(.) "
                    } else {
                        return "... "
                    }
                } else {
                    return "    "
                }
            }).joined()
            print(rangeLine)
        }
    }
}



let scanners = input//test
    .split(separator: "\n")
    .map({ (sub: Substring) -> Scanner in
        let parts = sub
            .split(separator: ":")
            .map(String.init)
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .map({ Int($0)! })
        return Scanner(depth: parts[0], range: parts[1])
    })

let lastLayer = scanners.last!.depth

let layers: [Layer] = (0...lastLayer)
    .map { i in
        let scanner = scanners.first(where: { $0.depth == i})
        return Layer(scanner: scanner, currentRange: 0, rangeChange: 1)
    }
    
var state = State(layers: layers)

// Part 1

//print("\nInitial state:")
//state.display()
//
//var caught = [Int]()
//var severity = 0
//
//for step in 0...lastLayer {
//    print("\nPicosecond \(step):")
//
//    state.simulatePacket()
//    state.display()
//    
//    if state.isCaught() {
//        caught.append(step)
//        severity += state.severity()
//    }
//
//    state.simulateScanners()
//    state.display()
//}
//
//print("Was caught in \(caught)")
//print("Severity: \(severity)")

// Part 2
takes to long to run the simulation. there is a faster mathy way of doing it

let heights = scanners
let wait = (0...)
    .filter { wait in
        print("Try \(wait)")
        return heights.first(where: {
            let pos = $0.depth
            let height = $0.range
            return (wait + pos) % (2 * (height - 1)) == 0
        }) != nil
    }
    .first
print(wait)

//var delay = 0
//var safe = false
//
//while !safe {
//    // Reset state
//    state = State(layers: layers)
//
////    print("Trying delay \(delay)")
//    for _ in 0..<delay {
//        state.simulateScanners()
//    }
//
////    print("\nState after delaying:")
////        state.display()
//
//    var wasCaught = false
//    for _ in 0...lastLayer {
////        print("\nPicosecond \(delay+step):")
//
//        state.simulatePacket()
////            state.display()
//
//        if state.isCaught() {
//            wasCaught = true
//            break
//        }
//
//        state.simulateScanners()
////            state.display()
//    }
//
//    if wasCaught {
//        delay += 1
//    } else {
//        safe = true
//    }
//}
//
//
//let safeDelay = delay
//print("Minimum safe delay: \(safeDelay)")

//: [Next](@next)
