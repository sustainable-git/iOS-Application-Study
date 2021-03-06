# Assignment 2 : More Memorize

[Programming Assignment 2 Pdfπ](./Assignment%202.pdf)

<br>
 <br>

<img width=600 src="./imageFiles/01.jpg">
<img width=600 src="./imageFiles/02.jpg">

<br>
 <br>

## Memorize

<img width=100% src="./imageFiles/Demo.gif">

<br>
 <br>


## Required Tasks


1. Get the Memorize game working as demonstrated in lectures 1 through 4. Type in all the code. Do not copy/paste from anywhere.

    - lecture 4λ₯Ό ν λλ‘ μμ±


2. If youβre starting with your assignment 1 code, remove your theme-choosing buttons and (optionally) the title of your game.

    - theme-choosing buttons μ­μ 


3. Add the formal concept of a βThemeβ to your Model. A Theme consists of a name for the theme, a set of emoji to use, a number of pairs of cards to show, and an appropriate color to use to draw the cards.

    - themeμ μ’λ₯μ λ°λΌ titleκ³Ό card μμ΄ λ³κ²½λ¨

    - <img width=400 src="./imageFiles/03.jpg">

<br>

4. At least one Theme in your game should show fewer pairs of cards than the number of emoji available in that theme.

    - λͺ¨λ  emojiλ κ° 10κ° μ©μ΄λ©°, μ΄ μ€ 6κ°μ pairsλ§ νν λ¨

    - ```swift
      var emojis: [String] {
            switch self {
            case .animals: return "πΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨".map{ String($0) }
            case .vehicles: return  "ππ³ππππππβοΈπ".map{ String($0) }
            case .fruits: return "ππππππ₯ππ₯ππ«".map{ String($0) }
            case .activities: return "β½οΈπππΎβ·π₯π₯πͺπΉβ³οΈ".map{ String($0) }
            case .foods: return "π₯π€π‘π­πͺπ«ππ­ππ₯¨".map{ String($0) }
            case .faces: return "π‘π€―π₯Άπ±π€’ππΉπ€‘ππ½".map{ String($0) }
            }
        }
        ```

5. If the number of pairs of emoji to show in a Theme is fewer than the number of emojis that are available in that theme, then it should not just always use the first few emoji in the theme. It must use any of the emoji in the theme. In other words, do not have any βdead emojiβ in your code that can never appear in a game.

    - themeμμ emojisκ° μ νλλ©΄, μ΄λ₯Ό `shuffled()`ν ν, `removeFirst()`λ‘ emojiλ₯Ό μ ννμμ

    - ```swift
        private func createMemoryGame() -> MemoryGame<String> {
            let emojiCollection = EmojiCollection.random
            var emojis = emojiCollection.emojis.shuffled()
            /* ... */
            return MemoryGame<String>(numberOfPairsOfCards: 6) { _ in
                return emojis.removeFirst()
            }
        }
        ```
    
6. Never allow more than one pair of cards in a game to have the same emoji on it.

    - λμΌν emojiλ₯Ό μ¬μ©νμ§ μμ μ€λ³΅ λ―Έλ°μ


7. If a Theme mistakenly specifies to show more pairs of cards than there are emoji available, then automatically reduce the count of cards to show to match the count of available emoji.

    - 6κ° λ³΄λ€ μ μκ²½μ°, emojisμ κ°―μ λ§νΌ μ¬μ©νλλ‘ ν¨

    - ```swift
       let numberOfPairs = emojis.count >= 6 ? 6 : emojis.count
       ```

8. Support at least 6 different themes in your game.

    - themesλ μ΄ 6κ°

    - ```swift
        enum EmojiCollection: String, CaseIterable {
            case animals = "Animals", vehicles = "Vehicles", fruits = "Fruits",
            activities = "Activities", foods = "Foods", faces = "Faces"
        /* ... */
        }   
       ```

9. A new theme should be able to be added to your game with a single line of code.

    - ν μ€μ codeλ‘ theme μΆκ° κ°λ₯

    - ```swift
      var emojis: [String] {
            switch self {
            case .animals: return "πΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨".map{ String($0) }
            case .vehicles: return  "ππ³ππππππβοΈπ".map{ String($0) }
            case .fruits: return "ππππππ₯ππ₯ππ«".map{ String($0) }
            case .activities: return "β½οΈπππΎβ·π₯π₯πͺπΉβ³οΈ".map{ String($0) }
            case .foods: return "π₯π€π‘π­πͺπ«ππ­ππ₯¨".map{ String($0) }
            case .faces: return "π‘π€―π₯Άπ±π€’ππΉπ€‘ππ½".map{ String($0) }
            }
        }
        ```

10. Add a βNew Gameβ button to your UI (anywhere you think is best) which begins a brand new game.

    - νλ¨μ λ°°μΉ

    - <img width=320 src="./imageFiles/04.jpg">

<br>

11. A new game should use a randomly chosen theme and touching the New Game button should repeatedly keep choosing a new random theme.

    - new game button touchμ μλ‘μ΄ memory gameμ λ§λ€λλ‘ ν¨
    
    - ```swift
        func newGame() {
            self.model = self.createMemoryGame()
        }
      ```


12. The cards in a new game should all start face down.

    - μ¬μμμ ν­μ face downμΌλ‘ μμ

    - ```swift
        struct Card: Identifiable {
            var isFaceUp: Bool = false
            var isMatched: Bool = false
            var content: CardContent
            var id: Int
        }
        ```

13. The cards in a new game should be fully shuffled. This means that they are not in any predictable order, that they are selected from any of the emojis in the theme (i.e. Required Task 5), and also that the matching pairs are not all side-by-side like they were in lecture (though they can accidentally still appear side-by-side at random).

    - MemoryGame model μ΄κΈ°νμ `shuffle()`μΌλ‘ μμΉλ₯Ό λ¬΄μμλ‘ λλλ‘ ν¨
    
    - ```swift
        init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
            cards = Array<Card>()
            for pairIndex in 0..<numberOfPairsOfCards {
                let content = createCardContent(pairIndex)
                cards.append(Card(content: content, id: pairIndex * 2))
                cards.append(Card(content: content, id: pairIndex * 2 + 1))
            }
            cards.shuffle()
        }
        ```

14. Show the themeβs name in your UI. You can do this in whatever way you think looks best.

    - νλ©΄ μλ¨μ μ΄λ¦ νμ


15. Keep score in your game by penalizing 1 point for every previously seen card that is involved in a mismatch and giving 2 points for every match (whether or not the cards involved have been βpreviously seenβ). See Hints below for a more detailed explanation. The score is allowed to be negative if the user is bad at Memorize.

    - userκ° card 2κ°λ₯Ό μ ν ν
        - λ§μ·μ κ²½μ° : 2μ  νλ
        - λͺ»λ§μ·μ κ²½μ°
            - κ° cardκ° checkedCardμ μνλ©΄ -1μ 
            - κ° cardλ₯Ό checkedCardμ update

16. Display the score in your UI. You can do this in whatever way you think looks best.

    - New Game button μμ λ°°μΉν¨

    - <img width=320 src="./imageFiles/04.jpg">
