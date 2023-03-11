//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import QuartzCore

public extension Array where Element: Equatable {
    
    func groupForEqualSpacing(_ rangeOf: ((_ element: Element) -> ClosedRange<Int>)) -> [(elements: [Element], spacing: Int)] {
        let result = groupForEqualSpacing { element -> ClosedRange<Double> in
            let floatRange = rangeOf(element)
            return Double(floatRange.lowerBound)...Double(floatRange.upperBound)
        }
        return result.map { (elements, spacing) in
            return (elements, Int(spacing))
        }
    }
    
    func groupForEqualSpacing(_ rangeOf: ((_ element: Element) -> ClosedRange<CGFloat>)) -> [(elements: [Element], spacing: CGFloat)] {
        let result = groupForEqualSpacing { element -> ClosedRange<Double> in
            let floatRange = rangeOf(element)
            return Double(floatRange.lowerBound)...Double(floatRange.upperBound)
        }
        return result.map { (elements, spacing) in
            return (elements, CGFloat(spacing))
        }
    }
    
    func groupForEqualSpacing(_ rangeOf: ((_ element: Element) -> ClosedRange<Double>)) -> [(elements: [Element], spacing: Double)] {
        
        // First, get all possible groupings of the array of elements.
        let groupings = allArrangements()
        
        // Then, for each grouping, get all possible setups of equal spacing.
        var setups = groupings.flatMap { group -> [(elements: [Element], spacing: Double)] in
            return group.iterrateGroupForEqualSpacing(rangeOf)
        }
        
        setups = setups.filterWithContext { remaining, a in
            if remaining.contains(where: { b in
                if a.spacing == b.spacing {
                    return a.elements.allSatisfyOfSameIndex(in: b.elements, { lh, rh in
                        return lh == rh
                    })
                }
                return false
            }) {
                return false
            }
            return true
        }
        setups = setups.sorted(by: {$0.elements.count > $1.elements.count})
        setups = setups.filterWithContext({ remaining, a in
            if remaining.contains(where: { b in
                if a.spacing == b.spacing {
                    if b.elements.count > a.elements.count {
                        if a.elements.allSatisfy({b.elements.contains($0)}) {
                            return true
                        }
                    }
                }
                return false
            }) {
                return false
            }
            return true
        })
        return setups
    }
    
    private func iterrateGroupForEqualSpacing(_ rangeOf: ((_ element: Element) -> ClosedRange<Double>)) -> [(elements: [Element], spacing: Double)] {
        
        // Create an array of tuples where each tuple contains the element and its corresponding range.
        let elementRanges = map { ($0, rangeOf($0)) }
        
        // Sort the array of element ranges based on their lower bounds.
        let sortedRanges = elementRanges
        
        // Calculate the spacing between adjacent ranges by subtracting the upper bound of the previous range from the lower bound of the current range.
        var spacings: [Double] = []
        for index in 1..<sortedRanges.count {
            let previousRange = sortedRanges[index-1].1
            let currentRange = sortedRanges[index].1
            let spacing = currentRange.lowerBound - previousRange.upperBound
            spacings.append(spacing)
        }
        
        // Group the elements based on their spacing values.
        var result: [(elements: [Element], spacing: Double)] = []
        var currentGroup: [Element] = []
        var currentSpacing: Double?
        
        for (index, element) in sortedRanges.enumerated() {
            currentGroup.append(element.0)
            
            if index < spacings.count {
                let spacing = spacings[index]
                
                if currentSpacing == nil {
                    currentSpacing = spacing
                }
                
                if spacing != currentSpacing {
                    result.append((currentGroup, currentSpacing!))
                    currentGroup = [element.0]
                    currentSpacing = spacing
                }
            }
        }
        
        result.append((currentGroup, currentSpacing ?? 0))
        
        return result.filter {$0.spacing >= 0 && !$0.elements.isEmpty}
    }
    
}
