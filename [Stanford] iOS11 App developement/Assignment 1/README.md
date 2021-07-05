# Assignment 1 : Concentration
[Assignment1 Pdf📎](https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%201/Programming_Project_1_Concentration.pdf)
<p align="left"> <img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%201/imageFiles/1.jpg?raw=true"> </p>
<p align="left"> <img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%201/imageFiles/2.jpg?raw=true"> </p>

<br>
 <br>

## Concentration Game
<p align="center"> <img width=100% src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%201/imageFiles/demo.gif?raw=true> </p>

<br>
 <br>

## Required Tasks
1. Get the Concentration game working as demonstrated in lectures 1 and 2. Type in all the code. Do not copy/paste from anywhere.
- 처음부터 다시 만듦

2. Add more cards to the game.
- 카드 갯수 8개 -> 16개로 변경

3. Add a “New Game” button to your UI which ends the current game in progress and begins a brand new game.
```swift
    // Control 부분
    @IBAction func newGameButton(_ sender: UIButton) {
        game.restart() // Model을 초기화
        updateViewFromModel() // View을 초기화
        theme = themeInitializer[Int(arc4random_uniform(UInt32(themeInitializer.count)))] // theme를 초기화
        iconDictionary = [Int : String]() // iconDictionary를 초기화
    }
    
    // Model 부분
    func restart() {
        flipCount = 0 // 초기화
        score = 0 // 초기화
        flipedCardIndex = nil //초기화
        checkedCardIndexArray = Array(repeating: false, count: cards.count)
        for cardResetIndex in cards.indices { // 모든 card를 초기화
            cards[cardResetIndex].isFaceUp = false
            cards[cardResetIndex].isMatched = false
        }
        cards.shuffle() // card를 다시 섞음
    }
```

4. Currently the cards in the Model are not randomized (that’s why matching cards end up always in the same place in our UI). Shuffle the cards in Concentration’s  init() method.
```swift
    cards.shuffle() // init, restart 함수에 포함 
```

5. Give your game the concept of a “theme”. A theme determines the set of emoji from which cards are chosen. All emoji in a given theme are related by that theme. See the Hints for example themes. Your game should have at least 6 different themes and should choose a random theme each time a new game starts.
```swift
    lazy var theme = themeInitializer[Int(arc4random_uniform(UInt32(themeInitializer.count)))] // themeInitializer 초기화 이후, theme를 random하게 선택
    // ...
    @IBAction func newGameButton(_ sender: UIButton) {
        // ...
        theme = themeInitializer[Int(arc4random_uniform(UInt32(themeInitializer.count)))] // theme를 random하게 선택
        iconDictionary = [Int : String]() // 각 theme의 icon이 저장된 dictionary를 초기화
    }
```

6. Your architecture must make it possible to add a new theme in a single line of code.
```swift
    // Control 부분
    let themeInitializer = [["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]] // theme 추가시 themeInitializer 배열에 추가하면 됨
```

7. Add a game score label to your UI. Score the game by giving 2 points for every match and penalizing 1 point for every previously seen card that is involved in a mismatch.
```swift
    if let matchIndex = flipedCardIndex, matchIndex != index {
        if cards[index].identifier == cards[matchIndex].identifier { // matched
            cards[index].isMatched = true
            cards[matchIndex].isMatched = true
            score += 2 // Match되었다면 score가 2 상승
        } else { // miss matched
            if checkedCardIndexArray[matchIndex] { score -= 1 } // Match되지 않았고, 이미 확인된 Card를 선택했었다면 score가 1 하락
            if checkedCardIndexArray[index] { score -= 1 } // Match되지 않았고, 이미 확인된 Card를 선택했다면 score가 1 하락
            checkedCardIndexArray[matchIndex] = true // 확인했으면 checkedCardIndexArray에 해당 index를 true로 기록
            checkedCardIndexArray[index] = true // 확인했으면 checkedCardIndexArray에 해당 index를 true로 기록
        }
        // ...
    }
```
8. Tracking the flip count almost certainly does not belong in your Controller in a proper MVC architecture. Fix that.
```swift
    // Model 부분
    var flipcount = 0
    // ...
    func cardTouch(at index : Int) {
        guard !cards[index].isMatched else { return } // Matched인 card를 touch할 경우 아무 일도 일어나지 않음
        if !cards[index].isFaceUp { flipCount += 1 } // flipedDown 상태인 card를 touch할 경우 flipCount가 1 상승
        // ...
    }
```
9. All new UI you add should be nicely laid out and look good in portrait mode on an iPhone X.
- iPhone 12에 적합하도록 함 







