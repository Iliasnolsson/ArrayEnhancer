//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import Foundation

public extension Array {
    
    func group<T: Hashable & Equatable>(whereAllEqualing getValue: ((Element) -> T)) -> [[Element]] {
        var groups = [[Element]]()
        var elements = self
        while !elements.isEmpty {
            if let element = elements.popLast() {
                var newGroup = [element]
                let elementValue = getValue(element)
                for index in elements.indices.reversed() {
                    let otherElement = elements[index]
                    let otherValue = getValue(otherElement)
                    if elementValue == otherValue {
                        elements.remove(at: index)
                        newGroup.append(otherElement)
                    }
                }
                groups.append(newGroup)
            }
        }
        return groups
    }
    
    typealias Indexed = (index: Int, element: Element)

    func group(where shouldGroup: (_ lh: Element, _ rh: Element) -> Bool) -> [[Element]] {
        var variations = [[[Indexed]]]()
        let elements = indexed()
        for index in self.indices {
            var elementsCopy = elements
            elementsCopy.append(elementsCopy.remove(at: index))
            variations.append(elementsCopy.groupIterate(where: {shouldGroup($0.element, $1.element)}))
        }
        let groups = variations.flatMap({$0}).filterWithContext { (remaining: [[Indexed]], group: [Indexed]) in
            return !remaining.contains(where: { (otherGroup: [Indexed]) in
                if group.count == otherGroup.count {
                    if group.allSatisfy({a in otherGroup.contains(where: {$0.index == a.index})}) {
                        return true
                    }
                }
                return false
            })
        }
        return groups.filter({!$0.isEmpty}).map({$0.map({$0.element})})
    }

    func indexed() -> [Indexed] {
        return indices.map { ($0, self[$0]) }
    }
    
    private func groupIterate(where shouldGroup: (_ lh: Element, _ rh: Element) -> Bool) -> [[Element]] {
        var groups = [[Element]]()
        var remaining = self
        while let last = remaining.last {
            remaining.removeLast()
            var newGroup = [last]
            var i = remaining.count - 1
            while i >= 0 {
                let other = remaining[i]
                if shouldGroup(last, other) {
                    newGroup.append(other)
                    remaining.remove(at: i)
                }
                i -= 1
            }
            groups.append(newGroup)
        }
        return groups
    }
    
    
    
}
