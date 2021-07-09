# Assignment 2 : Set
[Assignment2 Pdf📎]()

<img>
<img>
<img>

## Set Game
<demo>

## Required Task
1. Implement a game of solo (i.e. one player) Set.
 - 완료

2. Have room on the screen for at least 24 Set cards. All cards are always face up in Set.

<img>

 - 최대 24개의 Set cards 사용가능

3. Deal 12 cards only to start. They can appear anywhere on screen (i.e. they don’t have to be aligned at the top or bottom or anything; they can be scattered to start if you want), but should not overlap.

<img>

 - 시작시 12개의 카드에서 시작

4. You will also need a “Deal 3 More Cards” button (as per the rules of Set).
 - `Deal 3 more` 버튼 추가

5. Allow the user to select cards to try to match as a Set by touching on the cards. It is up to you how you want to show “selection” in your UI. See Hints below for some ideas. Also support “deselection” (but when only 1 or 2 (not 3) cards are currently selected).

- deselection 가능
- select시 카드 주위에 파란색 경계가 생김

```swift
    if set.selectedCardArr.contains(card) {
        button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) // blue color
    } else { button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        button.layer.borderWidth = 3.0
        button.layer.cornerRadius = 8.0
```

6. After 3 cards have been selected, you must indicate whether those 3 cards are a match or a mismatch (per Set rules). You can do this with coloration or however you choose, but it should be clear to the user whether the 3 cards they selected match or not.

- 화면 상단 Notice 부분에서 확인가능

```swift
    if set.selectedCardArr.count == 3 { // notice labeling
        if set.isSet(set.selectedCardArr){ noticeLabel.text = "Matched" }
        else { noticeLabel.text = "misMatched" }
    } else { noticeLabel.text = "" }
```

7. When any card is chosen and there are already 3 non-matching Set cards selected, deselect those 3 non-matching cards and then select the chosen card.

- 선택된 카드가 3개 이상일 때, 카드를 터치하면 항상 deselect되도록 함

```swift
    if selectedCardArr.count >= 3 { selectedCardArr.removeAll() }
```

8. As per the rules of Set, when any card is chosen and there are already 3 matching Set cards selected, replace those 3 matching Set cards with new ones from the deck of 81 Set cards (again, see Set rules for what’s in a Set deck). If the deck is empty then matched cards can’t be replaced, but they should be hidden in the UI. If the card that was chosen was one of the 3 matching cards, then no card should be selected (since the selected card was either replaced or is no longer visible in the UI).

- touchCard 할 때마다 모든 matched card는 buttonCardDict에서 UIButton에 할당된 Card가 바뀌면서 replaced 된다
- deck에 card가 남아있지 않으면 nil이 되어 UI에서 사라지도록 하였다

```swift
    private lazy var cardIndexs = Array(0..<set.cards.count) // 81개 카드 제한
    private var buttonCardDict = [UIButton:Card]() // UI버튼마다 카드를 할당
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let card = buttonCardDict[sender] else { return } // UIButton에 Card가 할당되어 있지 않으면 touchCard가 응답하지 않음
        /* ... */    
    
        for (key, value) in buttonCardDict { // touchCard시 모든 UIButton을 확인후, matchedCard이면 buttonCardDict에서 제거 및 새로운 카드 할당
            if set.matchedCardArr.contains(value) { // matched
                if cardIndexs.count > 0 { // deck이 모두 소진되면 replace되지 않음
                    buttonCardDict.updateValue(set.cards[cardIndexs.removeFirst()], forKey: key) }
                else { buttonCardDict[key] = nil }
            }
        }
    }
```


- 아래의 코드와 같이 81개의 Card 이외에는 존재하지 않음

``` swift
private func initializer() -> [Card] {
    var returnArr = [Card]()
    
    for shape in 0...2 {
        for number in 0...2 {
            for shade in 0...2 {
                for color in 0...2 {
                    let card = Card.init(color: Color(rawValue: color)!, shade: Shade(rawValue: shade)!, number: Number(rawValue: number)!, shape: Shape(rawValue: shape)!)
                    returnArr.append(card)
                }
            }
        }
    }
    
    return returnArr
}
```

9. When the Deal 3 More Cards button is pressed either a) replace the selected cards if they are a match or b) add 3 cards to the game.

- matched 상태인 경우에는 카드를 지우는 역할만 한다
- matched가 아닐 때에는 24개의 카드 내에서 3개의 카드를 추가한다

```swift
    @IBAction private func touchDeal3MoreButton(_ sender: Any) {
        if set.isMatched {
            set.selectedCardArr.removeAll()
        } else if numberOfShowingCards < 24 && cardIndexs.count > 0 {
            for _ in 0..<3 {
                buttonCardDict[buttonCollection[numberOfShowingCards]] = set.cards[cardIndexs.removeFirst()]
                numberOfShowingCards += 1
            }
        }
        updateViewFromModel()
    }
```

10. The Deal 3 More Cards button should be disabled if there are a) no more cards in the Set deck or b) no more room in the UI to fit 3 more cards (note that there is always room for 3 more cards if the 3 currently-selected cards are a match since you replace them).

- 현재 놓인 카드가 24개이거나 deck에 카드가 존재하지 않으면 Deal 3 more 버튼이 사라진다
- Deal 3 more 버튼은 matched 상태에서는 카드를 지우는 역할을 하므로 항상 존재한다

```swift
    if set.isMatched || (numberOfShowingCards < 24 && cardIndexs.count != 0) { // deal 3 more button showing
        deal3MoreButton.setTitle("Deal 3 more", for: UIControl.State.normal)
        deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    } else {
        deal3MoreButton.setTitle("", for: UIControl.State.normal)
        deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
```

11. Instead of drawing the Set cards in the classic form (we’ll do that next week), we’ll use these three characters ▲ ● ■ and use attributes in NSAttributedString to draw them appropriately (i.e. colors and shading). That way your cards can just be UIButtons. See the Hints for some suggestions for how to show the various Set cards.

- card의 속성은 NSAttributedString으로 return하여 사용함
- 모양은 ▲ ● ■ 만 사용

```swift
    private func cardShape(ofCard card: Card) -> NSAttributedString {
    /* ... */
        switch card.shape {
            case .triangle : string = "▲"
            case .square : string = "■"
            case .circle : string = "●"
        }
    }
```

12. Use a method that takes a closure as an argument as a meaningful part of your solution. You cannot use one that was shown in lecture.

- 3개의 카드를 선택했을 때에 Set을 구분하는 데에 사용

```swift
    func isSet(_ threeCards: [Card]) -> Bool {
        guard threeCards.count == 3 else { return false }
        if Set(threeCards.map{$0.color}).count == 2 { return false }
        if Set(threeCards.map{$0.shade}).count == 2 { return false }
        if Set(threeCards.map{$0.number}).count == 2 { return false }
        if Set(threeCards.map{$0.shape}).count == 2 { return false }
        return true
    }
```

13. Use an enum as a meaningful part of your solution.

- Card 모델을 구현하는 데에 사용

```swift
    struct Card : Equatable {
        let color : Color
        let shade : Shade
        let number : Number
        let shape : Shape
    }

    enum Color : Int {
        case red = 0
        case green = 1
        case blue = 2
    }

    enum Shade : Int {
        case none = 0
        case half = 1
        case full = 2
    }

    enum Number : Int {
        case one = 0
        case two = 1
        case three = 2
    }

    enum Shape : Int {
        case triangle = 0
        case square = 1
        case circle = 2
    }
```

14. Add a sensible extension to some data structure as a meaningful part of your
solution. You cannot use one that was shown in lecture.

- Model에 불필요한 개념을 Controller 부분에서 extension을 이용해 구현함

```
    extension SetGame {
        var isMatched : Bool {
            if selectedCardArr.count == 3 && isSet(selectedCardArr) { return true }
            else { return false }
        }
    }
```

15. Your UI should be nicely laid out and look good (at least in portrait mode, preferably in landscape as well, though not required) on any iPhone 7 or later device. This means you’ll need to do some simple Autolayout with stack views.

<img>

- 세로 및 가로모드 정상동작
- iPhone 12에 적합하도록 함, iPhone SE 2세대부터 정상작동

16. Like you did for Concentration, you must have a New Game button and show the Score in the UI. It is up to you how you want to score your Set game. For example, you could give 3 points for a match and -5 for a mismatch and maybe even -1 for a deselection. Perhaps fewer points are scored depending on how many cards are on the table (i.e. how many times Deal 3 More Cards has been touched). Whatever you think best evaluates how well the player is playing.

- New Game button 존재함
- Match : 3점, misMatch : -5점, deselection : -1점 부여함

```swift
    mutating func selectCard(_ card : Card) {
        /* ... */
        if selectedCardArr.contains(card){ // deselection
            let position = selectedCardArr.firstIndex(of: card)!
            selectedCardArr.remove(at: position)
            score -= 1
        } 
        /* ... */
        if isSet(selectedCardArr) { // matched
            matchedCardArr += selectedCardArr
            score += 3
        } else { // not matched
            score -= 5
        }
    }
```

### Extra Credit
3. If you do write an algorithm to detect Sets, you could also add a “cheat” button that a struggling user could use to find a Set!

<img>

- cheat button 구현함
