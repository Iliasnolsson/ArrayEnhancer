//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import Foundation

public extension Array {
    
    func allEqualsSameValue<T: Equatable>(_ getValue: ((_ element: Element) -> T)) -> Bool {
        guard let first = first else { return true }
        let firstValue = getValue(first)
        return !contains(where: { getValue($0) != firstValue })
    }
    
    func allSatisfyOfSameIndex(in otherArray: Array, _ satisfies: ((_ lh: Element, _ rh: Element) -> Bool)) -> Bool {
        if count != otherArray.count { return false }
        return !zip(self, otherArray).contains { !satisfies($0, $1) }
    }
    
}
