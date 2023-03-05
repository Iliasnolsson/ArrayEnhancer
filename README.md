# ArrayEnhancer


ArrayEnhancer is a Swift package that provides a set of extensions to the built-in `Array` type to enhance its functionality. 

Download & Usage
-----

To use ArrayEnhancer in your project, simply add it as a dependency in your `Package.swift` file:


```swift
dependencies: [
    .package(url: "https://github.com/<username>/<repository>.git", from: "1.0.0")
]
```

Then, import the package in your source files:


```swift
import ArrayEnhancer
```

Examples
--------
The ArrayEnhancer Swift package provides a variety of useful extensions for arrays that can simplify and streamline many common array operations. In this section, we'll explore some examples of how to use the ArrayEnhancer package with an array of Person instances. 

These examples will demonstrate how to leverage the power of ArrayEnhancer to perform a variety of useful operations on arrays of Person instances, including filtering, grouping, and more.


```swift
let people = [
    Person(age: 25, firstName: "John", lastName: "Doe"),
    Person(age: 30, firstName: "Jane", lastName: "Doe"),
    Person(age: 35, firstName: "Bob", lastName: "Smith"),
    Person(age: 40, firstName: "Alice", lastName: "Johnson"),
    Person(age: 45, firstName: "Charlie", lastName: "Brown")
]
```

### `allEqualsSameValue`

This method could be used to check if all `Person` instances in the array have the same age:

```swift
let allAgesEqual = people.allEqualsSameValue { $0.age }
print(allAgesEqual) // Output: false
```

### `allSatisfyOfSameIndex`

This method could be used to check if all `Person` instances in two arrays have the same age and first name at each index:

```swift
let otherPeople = [
    Person(age: 25, firstName: "John", lastName: "Doe"),
    Person(age: 30, firstName: "Jane", lastName: "Doe"),
    Person(age: 35, firstName: "Bob", lastName: "Smith"),
    Person(age: 40, firstName: "Alice", lastName: "Johnson"),
    Person(age: 45, firstName: "Charlie", lastName: "Brown")
]

let allSatisfy = people.allSatisfyOfSameIndex(in: otherPeople) { $0.age == $1.age && $0.firstName == $1.firstName }
print(allSatisfy) // Output: true
```

### `filterWithContext`

This method could be used to filter out all `Person` instances in the array whose age is less than the average age of all people:

```swift
let averageAge = Double(people.reduce(0) { $0 + $1.age }) / Double(people.count)

let filtered = try! people.filterWithContext { remaining, person in
    let remainingAges = remaining.map { $0.age }
    let remainingAverageAge = Double(remainingAges.reduce(0, +)) / Double(remainingAges.count)
    return person.age >= remainingAverageAge
}

print(filtered) // Output: [Person(age: 35, firstName: "Bob", lastName: "Smith"), Person(age: 40, firstName: "Alice", lastName: "Johnson"), Person(age: 45, firstName: "Charlie", lastName: "Brown")]
```

### `group`

This method could be used to group all `Person` instances in the array by their last name:

```swift
let grouped = people.group { $0.lastName }
print(grouped) // Output: [[Person(age: 25, firstName: "John", lastName: "Doe"), Person(age: 30, firstName: "Jane", lastName: "Doe")], [Person(age: 35, firstName: "Bob", lastName: "Smith")], [Person(age: 40, firstName: "Alice", lastName: "Johnson")], [Person(age: 45, firstName: "Charlie", lastName: "Brown")]]
```

### `groupToDictionary`

This method could be used to group all `Person` instances in the array by their age:

```swift
let grouped = people.groupToDictionary { $0.age }
print(grouped) // Output: [25: [Person(age: 25, firstName: "John", lastName: "Doe")], 30: [Person(age: 30, firstName
```


Documentation
--------

### `allEqualsSameValue`

This method returns a Boolean value indicating whether all elements in the array have the same value, as determined by the specified closure.


```swift
func allEqualsSameValue<T: Equatable>(_ getValue: ((_ element: Element) -> T)) -> Bool
```

### `allSatisfyOfSameIndex`

This method returns a Boolean value indicating whether all elements at the same index in two arrays satisfy a given predicate.

```swift
func allSatisfyOfSameIndex(in otherArray: Array, _ satisfies: ((_ lh: Element, _ rh: Element) -> Bool)) -> Bool
```

### `filterWithContext`

This method returns an array containing the elements of the original array that satisfy a given closure.

The difference between this method & the regular array `filter` method is that you with `filterWithContext` within the filter validation closure also get an insight into the current state of the filtered array through the `remaining` parameter.

```swift
func filterWithContext(_ isIncluded: (_ remaining: [Element], _ element: Element) throws -> Bool) rethrows -> [Element]
```

### `group`

This method returns an array of arrays, where each subarray contains elements that satisfy a given closure.

```swift
func group(where shouldGroup: (_ lh: Element, _ rh: Element) -> Bool) -> [[Element]]
```

### `groupToDictionary`

This method returns a dictionary where the keys are the values returned by a given closure and the values are arrays of elements that have the same value.

```swift
func groupToDictionary<T: Hashable & Equatable>(whereAllEqualing getValue: ((Element) -> T)) -> [T : [Element]]
```

### `groupToAllPossibilities`

This method returns an array of arrays, where each subarray contains elements that satisfy a given closure and where no two subarrays contain elements at the same index.

```swift
func groupToAllPossibilities(where shouldGroup: (_ lh: Element, _ rh: Element) -> Bool) -> [[Element]]
```

### `groupForRangeSpacing`

This method returns an array of tuples, where each tuple contains an array of elements and the spacing between them, based on a given range.


```swift
func groupForRangeSpacing(_ rangeOf: ((_ lh: Element) -> ClosedRange<CGFloat>)) -> [(elements: [Element], spacing: CGFloat)]
```


Contributing
------------

Contributions to `ArrayEnhancer` are welcome and encouraged! If you have any ideas for new features or improvements, feel free to open an issue or submit a pull request.

License
-------

`ArrayEnhancer` is available under the MIT license. See the LICENSE file for more info.

Author
------

`ArrayEnhancer` was created by Ilias Nikolaidis Olsson. If you have any questions or comments about `ArrayEnhancer`, feel free to get in touch with me via email or through GitHub.
