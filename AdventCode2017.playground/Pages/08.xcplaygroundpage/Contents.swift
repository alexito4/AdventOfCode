//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: Input

let content2 = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""
let content = try! String(contentsOfFile: "/Users/alejandromartinez/Dropbox/Projects/AdventCode2017.playground/Pages/8.xcplaygroundpage/Resources/input.txt")

struct Instruction {
	enum Operation {
		case inc
		case dec
	}
	struct Condition {
		let register: String
		let relation: String
		let value: Int
	}
	let register: String
	let op: Operation
	let amount: Int
	let condition: Condition
	
	init(line: String) {
		// b inc 5 if a > 1
		let parts = line.split(separator: " ").map(String.init)
		self.register = parts[0]
		self.op = {
			let op = parts[1]
			if op == "inc" {
				return .inc
			} else {
				return .dec
			}
		}()
		self.amount = Int(parts[2])!
		self.condition = Condition(
			register: parts[4],
			relation: parts[5],
			value: Int(parts[6])!
		)
	}
}

extension Instruction.Condition {
	func check(_ memory: Dictionary<String, Int>) -> Bool {
		let current = memory[register, default: 0]
		switch relation {
			case ">": return current > value
			case ">=": return current >= value
			case "<": return current < value
			case "<=": return current <= value
			case "==": return current == value
			case "!=": return current != value
			default:
				fatalError()
		}
	}
}


let list = content.split(separator: "\n").map({ Instruction(line: String($0)) })

//: Part 1

func execute(_ input: [Instruction]) -> (Dictionary<String, Int>, Int) {
	var absoluteMax = Int.min
	var memory: Dictionary<String, Int> = [:] {
		didSet {
			let currentMax = memory.max(by: { $0.value < $1.value })!.value
			absoluteMax = max(absoluteMax, currentMax)
		}
	}
	for instruction in input {
		if instruction.condition.check(memory) {
			switch instruction.op {
				case .inc:
					memory[instruction.register, default: 0] += instruction.amount
				case .dec:
					memory[instruction.register, default: 0] -= instruction.amount
			}
		}
	}
	return (memory, absoluteMax)
}

let (memory, absoluteMax) = execute(list)
let max = memory.max(by: { $0.value < $1.value })!
print(max)
print(absoluteMax)

//: Part 2



//: [Next](@next)
