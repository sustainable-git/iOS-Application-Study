# Assignment 2 : Set
[Assignment2 Pdf๐](https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/Programming_Project_2_Set.pdf)

<img width=60% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/1.jpg?raw=true">
<img width=60% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/2.jpg?raw=true">
<img width=58% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/3.jpg?raw=true">

<br>
 <br>

## Set Game
<img width=100% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/demo.gif?raw=true">

<br>
 <br>

## Required Task
1. Implement a game of solo (i.e. one player) Set.
 - ์๋ฃ

<br>
 <br>

2. Have room on the screen for at least 24 Set cards. All cards are always face up in Set.

<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/4.jpg?raw=true">

 - ์ต๋ 24๊ฐ์ Set cards ์ฌ์ฉ๊ฐ๋ฅ

<br>
 <br>

3. Deal 12 cards only to start. They can appear anywhere on screen (i.e. they donโt have to be aligned at the top or bottom or anything; they can be scattered to start if you want), but should not overlap.

<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/5.jpg?raw=true">

 - ์์์ 12๊ฐ์ ์นด๋์์ ์์

<br>
 <br>

4. You will also need a โDeal 3 More Cardsโ button (as per the rules of Set).
 - `Deal 3 more` ๋ฒํผ ์ถ๊ฐ

<br>
 <br>

5. Allow the user to select cards to try to match as a Set by touching on the cards. It is up to you how you want to show โselectionโ in your UI. See Hints below for some ideas. Also support โdeselectionโ (but when only 1 or 2 (not 3) cards are currently selected).

- deselection ๊ฐ๋ฅ
- select์ ์นด๋ ์ฃผ์์ ํ๋์ ๊ฒฝ๊ณ๊ฐ ์๊น

```swift
    if set.selectedCardArr.contains(card) {
        button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) // blue color
    } else { button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        button.layer.borderWidth = 3.0
        button.layer.cornerRadius = 8.0
```

<br>
 <br>

6. After 3 cards have been selected, you must indicate whether those 3 cards are a match or a mismatch (per Set rules). You can do this with coloration or however you choose, but it should be clear to the user whether the 3 cards they selected match or not.

- ํ๋ฉด ์๋จ Notice ๋ถ๋ถ์์ ํ์ธ๊ฐ๋ฅ

```swift
    if set.selectedCardArr.count == 3 { // notice labeling
        if set.isSet(set.selectedCardArr){ noticeLabel.text = "Matched" }
        else { noticeLabel.text = "misMatched" }
    } else { noticeLabel.text = "" }
```

<br>
 <br>

7. When any card is chosen and there are already 3 non-matching Set cards selected, deselect those 3 non-matching cards and then select the chosen card.

- ์?ํ๋ ์นด๋๊ฐ 3๊ฐ ์ด์์ผ ๋, ์นด๋๋ฅผ ํฐ์นํ๋ฉด ํญ์ deselect๋๋๋ก ํจ

```swift
    if selectedCardArr.count >= 3 { selectedCardArr.removeAll() }
```

<br>
 <br>

8. As per the rules of Set, when any card is chosen and there are already 3 matching Set cards selected, replace those 3 matching Set cards with new ones from the deck of 81 Set cards (again, see Set rules for whatโs in a Set deck). If the deck is empty then matched cards canโt be replaced, but they should be hidden in the UI. If the card that was chosen was one of the 3 matching cards, then no card should be selected (since the selected card was either replaced or is no longer visible in the UI).

- touchCard ํ? ๋๋ง๋ค ๋ชจ๋? matched card๋ buttonCardDict์์ UIButton์ ํ?๋น๋ Card๊ฐ ๋ฐ๋๋ฉด์ replaced ๋๋ค
- deck์ card๊ฐ ๋จ์์์ง ์์ผ๋ฉด nil์ด ๋์ด UI์์ ์ฌ๋ผ์ง๋๋ก ํ์๋ค

```swift
    private lazy var cardIndexs = Array(0..<set.cards.count) // 81๊ฐ ์นด๋ ์?ํ
    private var buttonCardDict = [UIButton:Card]() // UI๋ฒํผ๋ง๋ค ์นด๋๋ฅผ ํ?๋น
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let card = buttonCardDict[sender] else { return } // UIButton์ Card๊ฐ ํ?๋น๋์ด ์์ง ์์ผ๋ฉด touchCard๊ฐ ์๋ตํ์ง ์์
        /* ... */    
    
        for (key, value) in buttonCardDict { // touchCard์ ๋ชจ๋? UIButton์ ํ์ธํ, matchedCard์ด๋ฉด buttonCardDict์์ ์?๊ฑฐ ๋ฐ ์๋ก์ด ์นด๋ ํ?๋น
            if set.matchedCardArr.contains(value) { // matched
                if cardIndexs.count > 0 { // deck์ด ๋ชจ๋ ์์ง๋๋ฉด replace๋์ง ์์
                    buttonCardDict.updateValue(set.cards[cardIndexs.removeFirst()], forKey: key) }
                else { buttonCardDict[key] = nil }
            }
        }
    }
```


- ์๋์ ์ฝ๋์ ๊ฐ์ด 81๊ฐ์ Card ์ด์ธ์๋ ์กด์ฌํ์ง ์์

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

<br>
 <br>

9. When the Deal 3 More Cards button is pressed either a) replace the selected cards if they are a match or b) add 3 cards to the game.

- matched ์ํ์ธ ๊ฒฝ์ฐ์๋ ์นด๋๋ฅผ ์ง์ฐ๋ ์ญํ?๋ง ํ๋ค
- matched๊ฐ ์๋ ๋์๋ 24๊ฐ์ ์นด๋ ๋ด์์ 3๊ฐ์ ์นด๋๋ฅผ ์ถ๊ฐํ๋ค

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

<br>
 <br>

10. The Deal 3 More Cards button should be disabled if there are a) no more cards in the Set deck or b) no more room in the UI to fit 3 more cards (note that there is always room for 3 more cards if the 3 currently-selected cards are a match since you replace them).

- ํ์ฌ ๋์ธ ์นด๋๊ฐ 24๊ฐ์ด๊ฑฐ๋ deck์ ์นด๋๊ฐ ์กด์ฌํ์ง ์์ผ๋ฉด Deal 3 more ๋ฒํผ์ด ์ฌ๋ผ์ง๋ค
- Deal 3 more ๋ฒํผ์ matched ์ํ์์๋ ์นด๋๋ฅผ ์ง์ฐ๋ ์ญํ?์ ํ๋ฏ๋ก ํญ์ ์กด์ฌํ๋ค

```swift
    if set.isMatched || (numberOfShowingCards < 24 && cardIndexs.count != 0) { // deal 3 more button showing
        deal3MoreButton.setTitle("Deal 3 more", for: UIControl.State.normal)
        deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    } else {
        deal3MoreButton.setTitle("", for: UIControl.State.normal)
        deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
```

<br>
 <br>

11. Instead of drawing the Set cards in the classic form (weโll do that next week), weโll use these three characters โฒ โ โ? and use attributes in NSAttributedString to draw them appropriately (i.e. colors and shading). That way your cards can just be UIButtons. See the Hints for some suggestions for how to show the various Set cards.

- card์ ์์ฑ์ NSAttributedString์ผ๋ก returnํ์ฌ ์ฌ์ฉํจ
- ๋ชจ์์ โฒ โ โ? ๋ง ์ฌ์ฉ

```swift
    private func cardShape(ofCard card: Card) -> NSAttributedString {
    /* ... */
        switch card.shape {
            case .triangle : string = "โฒ"
            case .square : string = "โ?"
            case .circle : string = "โ"
        }
    }
```

<br>
 <br>

12. Use a method that takes a closure as an argument as a meaningful part of your solution. You cannot use one that was shown in lecture.

- 3๊ฐ์ ์นด๋๋ฅผ ์?ํํ์ ๋์ Set์ ๊ตฌ๋ถํ๋ ๋ฐ์ ์ฌ์ฉ

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

<br>
 <br>

13. Use an enum as a meaningful part of your solution.

- Card ๋ชจ๋ธ์ ๊ตฌํํ๋ ๋ฐ์ ์ฌ์ฉ

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

<br>
 <br>

14. Add a sensible extension to some data structure as a meaningful part of your
solution. You cannot use one that was shown in lecture.

- Model์ ๋ถํ์ํ ๊ฐ๋์ Controller ๋ถ๋ถ์์ extension์ ์ด์ฉํด ๊ตฌํํจ

```swift
    extension SetGame {
        var isMatched : Bool {
            if selectedCardArr.count == 3 && isSet(selectedCardArr) { return true }
            else { return false }
        }
    }
```

<br>
 <br>

15. Your UI should be nicely laid out and look good (at least in portrait mode, preferably in landscape as well, though not required) on any iPhone 7 or later device. This means youโll need to do some simple Autolayout with stack views.

<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/6.jpg?raw=true">

- ์ธ๋ก ๋ฐ ๊ฐ๋ก๋ชจ๋ ์?์๋์
- iPhone 12์ ์?ํฉํ๋๋ก ํจ, iPhone SE 2์ธ๋๋ถํฐ ์?์์๋

<br>
 <br>

16. Like you did for Concentration, you must have a New Game button and show the Score in the UI. It is up to you how you want to score your Set game. For example, you could give 3 points for a match and -5 for a mismatch and maybe even -1 for a deselection. Perhaps fewer points are scored depending on how many cards are on the table (i.e. how many times Deal 3 More Cards has been touched). Whatever you think best evaluates how well the player is playing.

- New Game button ์กด์ฌํจ
- Match : 3์?, misMatch : -5์?, deselection : -1์? ๋ถ์ฌํจ

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

<br>
 <br>

### Extra Credit
3. If you do write an algorithm to detect Sets, you could also add a โcheatโ button that a struggling user could use to find a Set!

<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%202/imageFiles/7.jpg?raw=true">

- cheat button ๊ตฌํํจ
