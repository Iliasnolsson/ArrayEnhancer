//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import Foundation

public extension Array {
    
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
    
}
