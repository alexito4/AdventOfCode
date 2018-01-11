import Foundation

public func testData(name: String = "input", extension: String = "txt") -> String {
    let fileURL = Bundle.main.url(forResource: name, withExtension: `extension`)
    let content = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    return content
}

public func assert(_ expression: @autoclosure () -> Bool) -> String {
    return testOutput(expression(), "")
}

infix operator ==>
public func ==> <T: Equatable>(lhs: T, rhs: T) -> String {
    return testOutput(lhs == rhs, "\(lhs) != \(rhs)")
}
public func ==> <T: Equatable>(lhs: [T], rhs: [T]) -> String {
    return testOutput(lhs == rhs, "\(lhs) != \(rhs)")
}

func testOutput(_ success: Bool, _ message: String) -> String {
    if success {
        return "✅"
    } else {
        return "❌\(" " + message)"
    }
}
