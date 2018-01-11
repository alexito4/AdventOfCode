//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

extension Int {
	func p() {
		print(self)
	}
}

func score(_ stream: String) -> (score: Int, gargabe: Int) {
	var stack = [Int]()
	var total = 0
	var garbage = false
	var ignore = false
	var garbageCount = 0
	for c in stream {
//		print(c)
		switch c {
		case "{" where !garbage && !ignore:
//			print(" started")
			if let previousScore = stack.last {
				stack.append(previousScore + 1)
			} else {
				stack.append(1)
			}
		case "}" where !garbage && !ignore:
//		print(" ended")

			if let previousScore = stack.last {
				total += previousScore
				stack.removeLast()
			}
		case "<" where !garbage && !ignore:
			garbage = true
		case ">" where garbage && !ignore:
			garbage = false
		case "!" where !ignore:
			ignore = true
		case _ where ignore:
			ignore = false
		case _ where garbage:
			garbageCount += 1
		default:
//			print("  default")
			break
		}
//		print("  \(ignore)")
//		print("  \(garbage)")
	}
	return (total, garbageCount)
}

//score("{}").p() // 1
//score("{{{}}}").p()
//score("{{},{}}").p()
//score("{{{},{},{{}}}}").p()
//score("{<a>,<a>,<a>,<a>}").p()
//score("{{<ab>},{<ab>},{<ab>},{<ab>}}").p()
//score("{{<!!>},{<!!>},{<!!>},{<!!>}}").p()
//score("{{<a!>},{<a!>},{<a!>},{<ab>}}").p()

let content = try! String(contentsOfFile: "/Users/alejandromartinez/Dropbox/Projects/AdventCode2017.playground/Pages/9.xcplaygroundpage/Resources/input.txt")
print(score(content))

//: [Next](@next)
