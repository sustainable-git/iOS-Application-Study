# Assignment 3 : Graphical Set

[Assignment3 Pdf๐](https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/Programming_Project%203_Graphical_Set.pdf)

<br>
<br>

<img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/imageFiles/1.jpg?raw=true">
<img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/imageFiles/2.jpg?raw=true">

<br>
 <br>

## Graphical Set Game

<img width=100% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/imageFiles/demo.gif?raw=true">

<br>
 <br>

## Required Tasks

1. Your application should continue to play a solo game of Set as required by Assignment 2

   - ๊ณผ์  2์ ์ฝ๋๋ฅผ ์์ ํ์ฌ ์์ฑํจ

<br>
 <br>

2. In this version, however, you are not to limit the user-interface to a fixed number of cards. You should always be prepared to Deal 3 More Cards. The only time the Deal 3 More Cards button will be disabled is if there are no more cards left in the deck.

   - ์ต๋ 81์ฅ์ ์นด๋๋ฅผ ๋์์ ํ๋ฉด์ ๋ณด์ด๋๋ก ํจ

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/imageFiles/3.jpg?raw=true">

<br>
 <br>

3. Do not โpre-allocateโ space for all 81 possible cards. At any given time, cards should be as large as possible given the screen real estate available to cards and the number of cards currently in play. In other words, when the game starts (with only 12 cards), the cards will be pretty big, but as more and more cards appear on screen (due to Deal 3 More Cards), they will have to get smaller and smaller to fit.

   - 12๊ฐ์ ์นด๋๋ฅผ ๊ฐ์ง๊ณ  ์์ํจ
   - Deal 3 more ๋ฒํผ์ ๋๋ฅด๋ฉด ์นด๋๊ฐ ๋ง์์ง๋ฉด์, ๋ชจ๋  ์นด๋๊ฐ ํ๋ฉด์ ๊ฝ ์ฐฐ ๋งํผ ์์์ง

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/imageFiles/4.jpg?raw=true">

<br>
 <br>

4. Towards the end of the game, when 3 cards are matched and there are no more cards in the Set deck, the matching cards should be removed from the screen entirely and the remaining cards should โre-form upโ to use the space freed up by these departing cards (i.e. getting a bit larger again if space allows).

   - re-form up ๋จ

<br>
 <br>

5. Cards must have a โstandardโ look and feel (i.e. 1, 2 or 3 squiggles, diamonds or ovals that are solid, striped or unfilled and are either green, red or purple). You must draw them using UIBezierPath and/or CoreGraphics functions. You may not use attributed strings nor UIImages to draw your cards.

   - squiggle ํํ ์ฝ๋

```swift
	private func shapeSquiggle(rect : CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let p1 = CGPoint(x: rect.minX + rect.size.width/6, y: rect.minY + rect.size.height/6)
        let p2 = CGPoint(x: rect.maxX - rect.size.width/6, y: rect.minY + rect.size.height/6)
        let p3 = CGPoint(x: rect.maxX - rect.size.width/6, y: rect.maxY - rect.size.height/6)
        let p4 = CGPoint(x: rect.minX + rect.size.width/6, y: rect.maxY - rect.size.height/6)
        
        path.move(to: p1)
        path.addCurve(to: p2, controlPoint1: CGPoint(x: rect.minX + rect.width/2, y: rect.minY - rect.height/2), controlPoint2: CGPoint(x: rect.maxX - rect.width/2, y: rect.midY + rect.height/5))
        path.addQuadCurve(to: p3, controlPoint: CGPoint(x: rect.maxX - rect.width/20, y: rect.midY))
        path.addCurve(to: p4, controlPoint1: CGPoint(x: rect.maxX - rect.width/2, y: rect.maxY + rect.height/2), controlPoint2: CGPoint(x: rect.minX + rect.width/2, y: rect.midY - rect.height/5))
        path.addQuadCurve(to: p1, controlPoint: CGPoint(x: rect.minX + rect.width/20, y: rect.midY))
        
        return path
    }
```

-  - unfilled, striped, solid ํํ ์ฝ๋

```swift
	switch shade {
        case Shade.none : break
        case Shade.stripe :
            path.fill()
            for n in 0..<20 {
                guard n % 2 == 1 else { continue }
                let clipPath = UIBezierPath(rect: CGRect(x: rect.minX + rect.width*CGFloat(n)/20, y: rect.minY, width: rect.width/20, height: rect.height))
                UIColor.white.setFill()
                clipPath.fill()
            }
        case Shade.full : path.fill()
        }
```

<br>
 <br>

6. Whatever way you draw your cards must scale with the size of the card (obviously, to support Required Task 3).

   - Size Ratio ์ฌ์ฉ

```swift
       private struct SizeRatio {
           static var cornerRadiusToBoundsHeight : CGFloat = 0.06
           static var lineWidth : CGFloat = 0.02
           static var margin : CGFloat = 0.15
           static var contentsHeightRatio : CGFloat = 0.2
       }
```

<br>
 <br>

7. On cards that have more than one symbol, you are allowed to draw the symbols on horizontally across or vertically down (or even have that depend on the aspect ratio of the card at the time it is being drawn).

   - vertically down์ผ๋ก ์ค์ ํจ

<br>
 <br>

8. A tap gesture on a card should select/deselect it.

   - select, deselect ๊ฐ๋ฅ
   - select๋ ํ๋์, unselect๋ ๊ฒ์์

```swift
	if set.selectedCardArr.contains(card) { cardView.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)}
	else { cardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
 	cardView.layer.borderWidth = 3.0
  	cardView.layer.cornerRadius = 8.0
```

<br>
 <br>

9. A swipe down gesture in your game should Deal 3 More Cards.

   - ์ ์ค์ณ ์ถ๊ฐํ์ฌ ๊ธฐ์กด์ Deal 3 More ๋ฒํผ๊ณผ ๋์ผํ๊ฒ ๋์ํ๋๋ก ํจ

```swift
	@IBOutlet private weak var buttonCollection: CardCollectionView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(touchDeal3MoreButton(_:)))
            swipe.direction = [.down]
            buttonCollection.addGestureRecognizer(swipe)            
          	/* ... */
        }
    }
```

<br>
 <br>

10. Add a rotation gesture (two fingers rotating like turning a knob) to cause all of your cards to randomly reshuffle (itโs useful when the user is โstuckโ and canโt find a Set). This might require a modification to your Model.

    - Deck์ ์นด๋๊ฐ ๋จ์ ์์ ๋์๋ง ๋์ํจ
    - ์์์๋ ์นด๋๋ฅผ ์ ๋ถ ๋ฑ์ผ๋ก ๋ฃ๊ณ , ์นด๋๋ฅผ ๋ค์ ๋ฝ๋๋ก ํจ

```swift
        @IBOutlet private weak var buttonCollection: CardCollectionView! {
            didSet {
						/* ... */
                let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reShuffle(_:)))
                buttonCollection.addGestureRecognizer(rotate)
            }
        }

        @objc private func reShuffle(_ sender: UIRotationGestureRecognizer) {
            switch sender.state {
            case .ended :
            	guard cardIndexs.count > 0 else { return } // error guard
            
            	buttonCardDict.forEach{ set.cards.append($0.1); cardIndexs.append((cardIndexs.last ?? -1) + 1) }
         	buttonCardDict.removeAll()
            	buttonCollection.cardCollection.removeAll()
            
            	for _ in 0..<numberOfShowingCards {
                    let card = set.cards[cardIndexs.first!]
                    let cardView = CardView()
                    let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
                    cardView.addGestureRecognizer(tap)
                    cardView.initialize(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
                    buttonCollection.cardCollection.append(cardView)
                
                    buttonCardDict[cardView] = set.cards[cardIndexs.removeFirst()]
                }
                updateViewFromModel()
            default : break
            }
        }
```

<br>
 <br>

11. Your game must work properly and look good in both Landscape and Portrait orientations on all iPhones and iPads. It should efficiently use all the space available to it in all circumstances.

    - ๊ฐ๋ก ๋ฐ ์ธ๋ก๋ชจ๋ ์ ์ ์๋
    - iPhone ๋ฐ iPad ์ ์ ์๋

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/Assignment%203/imageFiles/5.jpg?raw=true">
