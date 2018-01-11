//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: Part 1

let inputt = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

let input = try! String(contentsOfFile: "/Users/alejandromartinez/Dropbox/Projects/AdventCode2017.playground/Pages/7.xcplaygroundpage/Resources/input.txt")

final class Program: CustomDebugStringConvertible, Hashable {
    static func ==(lhs: Program, rhs: Program) -> Bool {
        return lhs.name == rhs.name
    }
    
	let name: String
    var weight = 0
	var children: [Program]
    var parent: Program?
	
	init(name: String) {
		self.name = name
		self.children = []
	}
    
    var debugDescription: String {
        var res = "\(name) (\(weight))" //+ " " + ObjectIdentifier(self).debugDescription
//        if let parent = parent {
//            res += " - \(parent.name)"
//        }
        if children.count > 0 {
            res += ": \(children)"
        }
        return res
    }
    
    
    
    var hashValue: Int {
        return name.hashValue
    }
}

var nameDict = [String:Program]()
func findOrCreateProgram(name: String) -> Program {
    if let found = nameDict[name] {
        return found
    } else {
        let program = Program(name: name)
        nameDict[name] = program
        return program
    }
}

// Let's try to create a refrence tree normalized.
for line in input.split(separator: "\n") {
	let parts = line.split(separator: " ").map(String.init)

    let name = parts[0]
    let weight = Int(parts[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))!

    // Find the program in the dict or create a new one
    let program = findOrCreateProgram(name: name)
    program.weight = weight
    
    if parts.count > 2 {
        for childName in parts.suffix(from: 3) {
            let cleanChildName = childName.replacingOccurrences(of: ",", with: "")
            let child = findOrCreateProgram(name: cleanChildName)
            program.children.append(child)
        }
    }
}
for program in nameDict.values {
    for child in program.children {
        assert(child.parent == nil)
        child.parent = program
    }
}

//print(nameDict.reduce("", { $0 + "\n" + $1.value.debugDescription }))

//: Part 1

let bottomProgram = nameDict.values.first(where: { $0.parent == nil })!
//print(bottomProgram)

//: Part 2

extension Program {
    func childrenWeight() -> [Int] {
        return children.map { $0.towerWeight() }
    }
    
    func towerWeight() -> Int {
        return weight + childrenWeight().reduce(0,+)
     }
}

extension Array where Element: Hashable {
    func indexOfFirstDifferent() -> Int? {
        var counts = [Element: Int]()
        for n in self {
            counts[n, default: 0] += 1
        }
        guard counts.keys.count > 1 else {
            return nil
        }
        guard let min = counts.min(by: { $0.1 < $1.1 }) else {
            return nil
        }
        return index(of: min.0)
    }
    
    func element(notAt index: Int) -> Element {
        precondition(index >= 0, "Index out of bounds \(index)")
        precondition(index < count, "Index \(index) out of bounds \(count)")
        var newIndex = index + 1
        if newIndex < count {
            return self[newIndex]
        } else {
            newIndex = index - 1
            return self[newIndex]
        }
    }
}

//for child in bottomProgram.children {    
//    print(child.towerWeight())
//    print(child.childrenWeight()) // ifthey are allthe samethe culprit is the current node.
//}
//print(bottomProgram.childrenWeight())
//let different = bottomProgram.childrenWeight().indexOfFirstDifferent()
//print(different)

func comp(analyze program: Program) -> (program: Program, actual: Int, should: Int)? {
    guard let differentIndex = program.childrenWeight().indexOfFirstDifferent() else {
        return nil
    }
    let different = program.children[differentIndex]
//    print("Different \(different)")
    if let childResult = comp(analyze: different) {
        return childResult
    } else {
        // Children are fine, current different needs to change
        let target = program.children.element(notAt: differentIndex).towerWeight()
        let newWeight = target - different.towerWeight()
        return (different, different.weight, different.weight + newWeight)
    }
}
let result = comp(analyze: bottomProgram)!
print(result)


//: [Next](@next)
