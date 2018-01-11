import Foundation


extension Array {
    public func debug() {
        Swift.print(self)
    }
}


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

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension StringProtocol {
    func split(withWord separator: String) -> [String] {
        var res = [String]()
        
        var current = self.startIndex
        var accIndex = current
        
        var ignoreAccumulations = false
        func finishAccumulation(endingAt: Self.Index? = nil) {
            // Handle edge cases
            guard ignoreAccumulations == false else {
                return
            }
            guard current != self.startIndex else {
                current = self.endIndex
                ignoreAccumulations = true
                return
            }
            
            let accEnd = self.index(before: current)
            if accIndex <= accEnd {
                res.append(String(self[accIndex...accEnd]))
            }
            
            // Reset
            if let matchingIndex = endingAt {
                current = matchingIndex
                accIndex = current
            }
        }
        
        while current != self.endIndex {
            var matched = true
            var matchingIndex = current
            for (i, sc) in separator.enumerated() {
                if self[matchingIndex] != sc {
                    matched = false
                    break
                } else {
                    matchingIndex = self.index(after: matchingIndex)
                    // Check if it's going over the end of the separator
                    let isLastSeparatorCharacter = i >= separator.count-1
                    if matchingIndex == self.endIndex && !isLastSeparatorCharacter {
                        matched = false
                        break
                    }
                }
            }
            if matched {
                finishAccumulation(endingAt: matchingIndex)
            } else {
                current = self.index(after: current)
            }
        }
        finishAccumulation()
        
        return res
    }
}
