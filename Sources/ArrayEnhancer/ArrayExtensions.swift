//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2022-11-24.
//

import Foundation

public extension Array {
    
    func allEqualsSameValue<T: Equatable>(_ getValue: ((_ element: Element) -> T)) -> Bool {
        guard let first = first else {return true}
        let firstValue = getValue(first)
        return allSatisfy({x in getValue(x) == firstValue})
    }
    
    func allSatisfyOfSameIndex(in otherArray: Array, _ satisfies: ((_ lh: Element, _ rh: Element) -> Bool)) -> Bool {
        if count != otherArray.count {return false}
        for index in self.indices {
            let lh = self[index]
            let rh = otherArray[index]
            if !satisfies(lh, rh) {
                return false
            }
        }
        return true
    }
    
    func filterWithContext(_ isIncluded: (_ remaining: [Element], _ element: Element) throws -> Bool) rethrows -> [Element] {
        var mutable = self
        typealias ElementIndex = ReversedCollection<Range<Array<Element>.Index>>.Element
        return try mutable.indices.reversed().compactMap { (index: ElementIndex) in
            let element = mutable.remove(at: index)
            if try isIncluded(mutable, element) {
                return element
            }
            return nil
        }
    }
    
    func group(where shouldGroup: (_ lh: Element, _ rh: Element) -> Bool) -> [[Element]] {
        var groups = [[Element]]()
        var elements = self
        while !elements.isEmpty {
            if let element = elements.popLast() {
                var newGroup = [element]
                for index in elements.indices.reversed() {
                    let otherElement = elements[index]
                    if shouldGroup(element, otherElement) {
                        elements.remove(at: index)
                        newGroup.append(otherElement)
                    }
                }
                groups.append(newGroup)
            }
        }
        return groups
    }
    
    func groupToDictionary<T: Hashable & Equatable>(whereAllEqualing getValue: ((Element) -> T)) -> [T : [Element]] {
        var groups = [T : [Element]]()
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
                groups[elementValue] = newGroup
            }
        }
        return groups
    }
    
    
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
    
    func groupToAllPossibilities(where shouldGroup: (_ lh: Element, _ rh: Element) -> Bool) -> [[Element]] {
        var variations = [[[Indexed]]]()
        let elements = indexed()
        for index in self.indices {
            var elementsCopy = elements
            elementsCopy.append(elementsCopy.remove(at: index))
            variations.append(elementsCopy.group(where: {shouldGroup($0.element, $1.element)}))
        }
        let groups = variations.flatMap({$0}).filterWithContext { (remaining: [[Indexed]], group: [Indexed]) in
            return !remaining.contains(where: { (otherGroup: [Indexed]) in
                if group.allSatisfyOfSameIndex(in: otherGroup, {$0.index == $1.index}) {
                    return true
                }
                return false
            })
        }
        return groups.filter({!$0.isEmpty}).map({$0.map({$0.element})})
    }
    
    func indexed() -> [Indexed] {
        return indices.map {($0, self[$0])}
    }
    
    
}


public extension Array {
    
    func groupForRangeSpacing(_ rangeOf: ((_ lh: Element) -> ClosedRange<CGFloat>)) -> [(elements: [Element], spacing: CGFloat)] {
        typealias ElementSpacing = Array<Element>.ElementSpacing<Element>
        var elementSpacings: [ElementSpacing] = map {.init(element: $0, range: rangeOf($0), spacing: 0)}
        elementSpacings = elementSpacings.filterWithContext({ (remaining: [ElementSpacing], element: ElementSpacing) in
            return !remaining.contains(where: {$0.range.overlaps(element.range)})
        }).sorted(by: {$0.range.lowerBound < $1.range.lowerBound})
        
        for index in elementSpacings.indices {
            let elementSpacing = elementSpacings[index]
            if index <= elementSpacings.count - 2 {
                let nextElementSpacing = elementSpacings[index + 1]
                elementSpacing.spacing = nextElementSpacing.range.lowerBound - elementSpacing.range.upperBound
            }
        }

        typealias ElementSpacingIndexed = (index: Int, element: ElementSpacing)
        return elementSpacings.indexed().groupToAllPossibilities { (lh: ElementSpacingIndexed, rh: ElementSpacingIndexed) in
            if abs(lh.index - rh.index) == 1 {
                return lh.element.spacing == rh.element.spacing
            }
            return false
        }.map {($0.map({$0.element.element}), $0.first!.element.spacing)}
    }
    
    class ElementSpacing<T> {
        var element: T
        var range: ClosedRange<CGFloat>
        
        var spacing: CGFloat
        
        init(element: T, range: ClosedRange<CGFloat>, spacing: CGFloat) {
            self.element = element
            self.range = range
            self.spacing = spacing
        }
    }
    
}




