//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2022-11-24.
//

import Foundation

public extension Array {
    
    /**
     Generates all possible arrangements of the elements in the array.
     
     - Returns: An array of arrays where each subarray represents one of the possible arrangements of the elements in the array.
     */
    func allArrangements() -> [[Element]] {
        var groupings: [[Element]] = [[]]
        for element in self {
            var newGroupings: [[Element]] = []
            for grouping in groupings {
                for i in 0...grouping.count {
                    var newGrouping = grouping
                    newGrouping.insert(element, at: i)
                    newGroupings.append(newGrouping)
                }
            }
            groupings = newGroupings
        }
        return groupings
    }

    
    private func combinations(of length: Int) -> [[Element]] {
        if length == 0 {
            return [[]]
        } else {
            guard count >= length else { return [] }
            if length == 1 {
                return map { [$0] }
            } else {
                let head = self[0]
                let tail = Array(self[1...])
                let combinationsWithoutHead = tail.combinations(of: length)
                let combinationsWithHead = tail.combinations(of: length - 1).map { [head] + $0 }
                return combinationsWithoutHead + combinationsWithHead
            }
        }
    }
    
}
