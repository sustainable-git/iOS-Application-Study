# Chapter3 : Swift 프로그래밍 언어 - Part 1
<p align="center"> <img src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%203/imageFiles/3.jpg?raw=true> </p>

<br>
 <br>

## Concentration Game
<p align="center"> <img width=100% src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%203/imageFiles/demo.gif?raw=true ></p>

<br>
 <br>

## Today i learned

<p><img src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%203/imageFiles/1.jpg?raw=true></p>

- Storyboard
  - Align / Add new Constraints / Resolve Auto Layout Issues / Embed in
  - 개별 Stack View도 하나의 객체처럼 조작 가능
  - View와 View를 control + drag 로 연결하면 둘 사이의 constraints를 설정 가능

- Leading, Trailing
  - iOS는 히브리어나 아랍어와 같은 언어를 위해(글자를 우측에서 좌측으로 기입)
  - left와 right를 사용하지 않았음

- Tuple 사용법
```swift
    let x = ("hello", 5, 0.85)
    let (word, number, value) = x // word = "hello", number = 5, value = 0.85

    let x : (w: String, i: Int, v: Double) = ("hello", 5, 0.85)
    print(x.w, x.i, x.v) // x.w로 출력 가능

    func getSize() -> (weight: Double, height: Double) { return (250, 80) }

    let x = getSize()
    print("weight is \(x.weight)") // weight is 250
    print("height is \(getSize().height)") // height is 80
```

- Access Control
  - open : (for fameworks only) public and objects outside my framework can subclass this
  - public : (for frameworks only) this can be used by objects outside my framework
  - internal(default) : usable by any object in my app or framework
  - fileprivate : accessible by any code in this source file
  - private(set) : readable outside, but not settable
  - private : only callable from within this object

- Assert
```swift
    assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
```

<p><img src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%203/imageFiles/2.jpg?raw=true></p>

- Extensions
  - you can add methods/properties to a class/struct/enum
  - restrictions : 값을 저장하는 변수를 만들 수 없음
  - tip : 해당 타입을 확장하는 용도로만 사용해야 함
```swift
    let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count))) // extension 사용 전
``` 
```swift
    extension Int {
        var arc4ramdom : Int {
            return Int(arc4random_uniform(UInt32(self)))
        }
    }
```

- Enum
  - 각각의 case들이 연동된 데이터 혹은 값을 가질 수 있음
  - 이외에는 아무것도 저장할 수 없음
```swift
    enum FastFoodMenuItem {
        case hamburger(patties: Int)
        case fries(size: FriyOrderSize)
        case drink(String, ounces: Int) // "name: String" 를 기입하지 않아도 됨
        case cookie
    }
```
-  - Setting the value
```swift
    let menuItem: FastFoodMenuItem = FastFoodMenuItem.hamburger(patties: 2)
    let otherItem: FastFoodMenuItem = .cookie
    let sideItem = FastFoodMenuItem.fries(size: .large)
```
-  - Checking an enum's state
```swift
    switch menuItem {
        case .hamburger(let pattyCount):  print("a burger with \(pattyCount) patties!")
        case .fries: /* */
        case .drink(let brand, let ounces) : print("a \(ounces)oz \(brand)")
        case .cookie: break
    }
```

- Swift memory Management
    - Automatic Reference Counting(ARC)
    - class는 heap에 저장되고, 해당 class를 가리키는 pointer가 생성되면 count를 1만큼 더한다
    - pointer가 가리키는 것이 없어지면, count를 1만큼 빼고, 0이 되면 class를 heap에서 없앤다
    
- ARC에 영향을 주는 keywords
    - strong(default) : pointer가 존재하면 heap에 stay
    - weak : strong pointer가 존재할때만 stay (따라서 Optional 이어야만 함)
    - unowned : 개발자에 의해 제어가 명확한 경우에만 사용, nil이 될 수 없음
