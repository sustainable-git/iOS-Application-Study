# Chapter4 : Swift 프로그래밍 언어 - Part 2
<img>

## Concentration Game
<demo>

## Today i learned

- class와 struct의 차이
  - struct에서 proterty를 수정하려면 mutating을 붙여야함! (class는 필요없음)
  - 구조체는 value type임. 따라서 heap에 저장되지 않고, 매번 복사해야 하므로 mutating 붙여 내용이 변경되었을 때만 복사함

<img>
- Protocol
    - protocol is simply a collection of method and property declarations
    - kotlin의 interface와 유사하며, 다중 상속을 제공함
    - Objective-C 에서는 optional을 이용해 반드시 구현하지 않아도 되는 method나 variable을 만들 수 있음
    - you must specify whether a property is get only or both `get` and `set`
    - Any functions that are expected to mutate the reveiver should be marked mutating
    (unless you are going to restrict your protocol to class implementers with `class` keyword)
    - In a class, `init` must be marked `required`(or otherwise a subclass might not conform)
    - you are allowed to add protocol conformance via an extension

```swift
    protocol SomeProtocol : InheritedProtocol1, InheritedProtocol2 {
        var someProperty : Int { get, set }
        mutating func changeIt()
        init(arg: Type)
    }

    struct SomeStruct : SomeProtocol, AnotherProtocol {
        // implementation of SoemStruct here
        // which must include all the properties and methods in SomeProtocol & AnotherProtocol
    }

    class SomeClass : SuperClass, SomeProtocol, AnotherProtocol {
        required init(...)
    }

    extension Something : SomeProtocol {
        /* ... */
    }
```

<img> <img>
- Deligation
  - we use protocols to implement "blind communication" between a View and its Controller
    1. A View declares a delegation protocol
    2. The View's API has a weak delegate property whose type is that delegation protocol
    3. The View uses the delegate property to get/do things it can't own or control on its own
    4. The Controller declares that it implements the protocol
    5. The Controller sets delegate of the View to itself using the property in #2 above
    6. The Controller implements the protocol

```swift
    weak var delegate: UIScrollViewDelegate?

    @objc protocol UIScrollViewDelegate {
        /* ... */
    }
```

- Another use of Protocols
  - Being a key in a Dictionary
(Dictionary is declared like this : Dictionary<Key: Hashable, Value>

```swift
    protocol Hashable: Equatable {
        var hashValue: Int { get } // 이 문법은 hash(into: ) 문법으로 대체됨
    }

    protocol Equatable {
        static func ==(lhs: Self, rhs: Seld) -> Bool { /* ... */ }
    }
```

- Card를 Hashable 하게 만드는 방법
```swift
    struct Card : Hashable {
        func hash(into hasher: inout Hasher) { } // hash value
    
        static func ==(lhs: Card, rhs: Card) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        /* ... */
    }
```
|**Before**|**After**|
|:-:|:-:|
|<img>|<img>|

<br>
 <br>

- "Multiple inheritance" with protocols
  - Using extension to provide protocol implementation
  - Examples
    - CountableRange
    - Sequence(support `for in`)
    - Collection

```swift
    extension Sequence {
        func contains(_ element : Element) -> Bool { /* ... */ }
    }
```

- Functional Programming
  - By combining protocols with generics and extenstions,
   you can build code that focusses more on the behavior of data structures than storage

<img>
- String
  - The Characters(Unicodes) in a String
  - 문자열은 index가 불가능함. 대신 String.Index를 사용

```swift
    let pizzaJoint = "cafe pesto"
    let fourthCharacterIndex = pizzaJoint.index(pizzaJoint.startIndex, offsetBy: 3) 
    s.insert(contentsOf: " foo", at: s.firstIndex(of: " ")!) // cafe foo pesto
```
|**Before**|**After**|
|:-:|:-:|
|<img>|<img>|

<img>
- NSAttributedString
  - "NS" is a clue of "old style" Objective-C
  - To get mutability, use `NSMutableAttributedString`
  - It doesn't contain Unicode characters

```swift
    let attributes: [NSAttributedString.Key : Any] = [
        .strokeColor : UIColor.orange,
        .strokeWidth : 5.0
    ]

    let attribtext = NSAttributedString(string: "Flips: 0", attributes: attributes)
    flipCountLabel.attributedText = attribtext
```
<img>

<br>
 <br>

- Function Types
    - you can declare a variable to be of type "function"

```swift
    var operation: (Double) -> Double
    operation = sqrt
    let result = operation(4.0) // 2
```

<img>
- Closures
    - "in line" function
    - If the closure was the only argument, you can skip the () completely
    - you can also execute a closure to do initialization of a property
    - it's reference type

```swift
    var operation: (Double) -> Double
    operation = { (operand: Double) -> Double in return - operand } // operation = { -$0 }
    let result = operation(4.0) // -4

    var someProperty: Type = {
        return (initValue)
    }()
    // this is especially useful with lazy property
```
|**Before**|**After**|
|:-:|:-:|
|<img>|<img>|

