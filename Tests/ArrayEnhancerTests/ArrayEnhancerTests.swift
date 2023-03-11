import XCTest
@testable import ArrayEnhancer

final class ArrayEnhancerTests: XCTestCase {
    
    func testFilterWithContext() throws {
        // Given
        let numbers = [1, 2, 3, 4, 5, 5]
        let isIncluded: ([Int], Int) throws -> Bool = { remaining, element in
            if remaining.contains(element) {
                return false
            }
            return true
        }
        // When
        let filtered = try numbers.filterWithContext(isIncluded)
        
        // Then
        XCTAssertEqual(filtered, [1, 2, 3, 4, 5], "The filtered array should contain 5, 4, and 1.")
    }
    
    func testGroup() {
        let array = [1, 2, 3, 4, 5, 6, 7, 8]
        let groups = array.group(whereAllEqualing: { $0 % 2 })
        
        let expectedArrays = [[1, 3, 5, 7], [2, 4, 6, 8]]
        let expectedSets = expectedArrays.map(Set.init)
        let actualSets = groups.map(Set.init)
        
        XCTAssertTrue(actualSets.allSatisfy(expectedSets.contains))
        XCTAssertTrue(expectedSets.allSatisfy(actualSets.contains))
    }
    
    func testGroupToDictionary() {
        let array = ["apple", "banana", "cherry", "orange", "pear", "pineaple"]
        let dict = array.groupToDictionary(whereAllEqualing: { $0.first })
        XCTAssertEqual(dict.count, 5)
        XCTAssertEqual(dict["a"], ["apple"])
        XCTAssertEqual(dict["b"], ["banana"])
        XCTAssertEqual(dict["c"], ["cherry"])
        XCTAssertEqual(dict["o"], ["orange"])
        if let pDictionary = dict["p"] {
            let expects = Set(["pear", "pineaple"])
            if expects.allSatisfy(pDictionary.contains) {
                return;
            }
        }
        XCTFail("Dict at p not correct")
    }
    
    func testGroupToAllPossibilities() {
        let array = ["cat", "dog", "bat", "tiger", "lion", "monkey", "bear", "bob"]
        let groups = array.group(where: { $0.first == $1.first }).map(Set.init)
        let expects = [["cat"], ["dog"], ["tiger"], ["lion"], ["monkey"], ["bob", "bat", "bear"]].map(Set.init)
        
        XCTAssertTrue(groups.allSatisfy(expects.contains))
        XCTAssertTrue(expects.allSatisfy(groups.contains))
    }
    
    func testAllGroupings() {
        let array = [1, 2, 3]
        let groupings = array.allArrangements()
        XCTAssertEqual(groupings.count, 6)
        XCTAssertTrue(groupings.contains([1, 2, 3]))
        XCTAssertTrue(groupings.contains([1, 3, 2]))
        XCTAssertTrue(groupings.contains([2, 1, 3]))
        XCTAssertTrue(groupings.contains([2, 3, 1]))
        XCTAssertTrue(groupings.contains([3, 1, 2]))
        XCTAssertTrue(groupings.contains([3, 2, 1]))
    }
    
    
    func testAllEqualsSameValue() {
        let arr1 = [1, 1, 1, 1, 1]
        XCTAssertTrue(arr1.allEqualsSameValue({ $0 }))
        
        let arr2 = [1, 2, 3, 4, 5]
        XCTAssertFalse(arr2.allEqualsSameValue({ $0 }))
    }
    
    func testGroupForRangeSpacing() {
        // Create an array of rectangles with varying y-coordinates
        let rectangles: [CGRect] = [
            CGRect(x: 0, y: 400, width: 50, height: 50),
            CGRect(x: 0, y: 200, width: 50, height: 50),
            CGRect(x: 0, y: 500, width: 50, height: 50),
            CGRect(x: 0, y: 0, width: 50, height: 50),
            CGRect(x: 0, y: 100, width: 50, height: 50)
        ]
        
        // Call the method to group the rectangles based on their y-coordinate spacing
        let groups = rectangles.groupForEqualSpacing({$0.minY...$0.maxY})
        
        /*
         for group in groups {
         print("Elements with spacing \(group.spacing):")
         for element in group.elements {
         print("- \(element)")
         }
         }
         */
        
        XCTAssertEqual(groups[0].spacing, 450.0)
        XCTAssertEqual(groups[0].elements.count, 2)
        XCTAssertTrue(groups[0].elements.contains(CGRect(x: 0, y: 0, width: 50, height: 50)))
        XCTAssertTrue(groups[0].elements.contains(CGRect(x: 0, y: 500, width: 50, height: 50)))
        
        XCTAssertEqual(groups[1].spacing, 350.0)
        XCTAssertEqual(groups[1].elements.count, 2)
        XCTAssertTrue(groups[1].elements.contains(CGRect(x: 0, y: 100, width: 50, height: 50)))
        XCTAssertTrue(groups[1].elements.contains(CGRect(x: 0, y: 500, width: 50, height: 50)))
        
        XCTAssertEqual(groups[2].spacing, 250.0)
        XCTAssertEqual(groups[2].elements.count, 2)
        XCTAssertTrue(groups[2].elements.contains(CGRect(x: 0, y: 100, width: 50, height: 50)))
        XCTAssertTrue(groups[2].elements.contains(CGRect(x: 0, y: 400, width: 50, height: 50)))
        
        XCTAssertEqual(groups[3].spacing, 350.0)
        XCTAssertEqual(groups[3].elements.count, 2)
        XCTAssertTrue(groups[3].elements.contains(CGRect(x: 0, y: 0, width: 50, height: 50)))
        XCTAssertTrue(groups[3].elements.contains(CGRect(x: 0, y: 400, width: 50, height: 50)))
        
        XCTAssertEqual(groups[4].spacing, 250.0)
        XCTAssertEqual(groups[4].elements.count, 2)
        XCTAssertTrue(groups[4].elements.contains(CGRect(x: 0, y: 200, width: 50, height: 50)))
        XCTAssertTrue(groups[4].elements.contains(CGRect(x: 0, y: 500, width: 50, height: 50)))
        
        XCTAssertEqual(groups[5].spacing, 50.0)
        XCTAssertEqual(groups[5].elements.count, 2)
        XCTAssertTrue(groups[5].elements.contains(CGRect(x: 0, y: 400, width: 50, height: 50)))
        XCTAssertTrue(groups[5].elements.contains(CGRect(x: 0, y: 500, width: 50, height: 50)))
        
        XCTAssertEqual(groups[7].spacing, 50.0)
        XCTAssertEqual(groups[7].elements.count, 3)
        XCTAssertTrue(groups[7].elements.contains(CGRect(x: 0, y: 0, width: 50, height: 50)))
        XCTAssertTrue(groups[7].elements.contains(CGRect(x: 0, y: 100, width: 50, height: 50)))
        XCTAssertTrue(groups[7].elements.contains(CGRect(x: 0, y: 200, width: 50, height: 50)))
    }
    
}
