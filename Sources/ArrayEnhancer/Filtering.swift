//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import Foundation

public extension Array {
    
    func filterWithContext(_ isIncluded: (_ remaining: [Element], _ element: Element) throws -> Bool) rethrows -> [Element] {
        var result: [Element] = []
        var remaining = self
        
        for index in stride(from: remaining.count - 1, through: 0, by: -1) {
            let element = remaining[index]
            remaining.remove(at: index)
            if try isIncluded(remaining, element) {
                result.insert(element, at: 0)
            }
        }
        return result
    }

}
