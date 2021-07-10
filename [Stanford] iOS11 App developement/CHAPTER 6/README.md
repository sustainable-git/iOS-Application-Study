# Chapter6 : 멀티터치
<Img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/01.jpg?raw=true">

<br>
 <br>

## Playing Card
<img width=100% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/demo.gif?raw=true">

<br>
 <br>

## Today i learned
- [View](#View)
- [Gesture](#Gesture)

<br>
 <br>

### View
- Drawing
   - Befor draw, we need to add `Cocoa Touch Class`
   - After that, add a `View` in Storyboard
   - Change the class to `The class` you made
   - And use `func draw` to draw

<img width="480" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/02.jpg?raw=true">
<img width="480" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/03.jpg?raw=true">
<img width="240" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/04.jpg?raw=true">

<br>
 <br>
 
- Not to see background with transparent view
  - off the `Opaque` option

<img width="240" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/05.jpg?raw=true">

<br>
 <br>
 
- Font
  - For users with various font sizes, use `UIFontMetrics`
  - To center, use `NSMutableParagraphStyle()`

<img width="240" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/06.jpg?raw=true">
 
<br>
 <br>

- Redrawing in code
  - Use `setNeedsDisplay()`
    - The system automatically calls `draw()`
  - And `setNeedsLayout` to rearrange
    - The system automatically calls `layoutSubviews()`

- Creating subview
  - Creating
```swift
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // you can use lines however you wants
        addSubview(label)
        return label
    }
```

-  - Layout Configuring
```swift
    private func configureCornerLabel(_ label : UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero // clear out size before sizeToFit()
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
```

-  - Layout Positioning
```swift
    override func layoutSubviews() { // system automatically calls when arranges subviews
        super.layoutSubviews() // auto layout
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        // upperLeftCornerLabel is a UILabel 
    }
```

- Affine transform
  - It represents scale, translation, rotation
  - It's Bitwise translation

```swift
    lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
```
 
- View Constraints
  - Fixing ratio
    - Just `control + drag` itself
    - Then you can choose `Aspect Ratio`
  - Priority
    - Default value : 1000

<img width="240" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/07.jpg?raw=true">
 
<br>
 <br>

- View with Images
  - Use `UIImage` with `draw()`

```swift
    override func draw(_ rect: CGRect) {
        /* ... */
        if let faceCardImage = UIImage(named: rankString+suit) {
            faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
        }
    }
```

- Seeing and Changing in-code view directly on Storyboard
  - To see, `@IBDesignable` in front of the UIView class
  - If it is image, use `UIImage` with more factors

```swift
    if let faceCardImage = UIImage(named: rankString+suit ,in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
```

- To change, `@IBInspectable` in front of variables
- At this moment, no type inferring allowed

<img width="480" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/08.jpg?raw=true">

<br>
 <br>

### Gesture
<img width="480" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/09.jpg?raw=true">

- Gestures
    1. Adding a gesture recognizer to a UIView (Controller)
    2. Providing a method to "handle" that gesture (UIView or Controller)

- Adding a gesture recognizer to a UIView
    
```swift
    @IBOutlet weak var pannableView : UIView {
        didSet {
            let panGestureRecognizer = UIPanGestureRecognizer(
                target : self, action : #selector(ViewController.pan(recognizer: )
            )
            pannableView.addGestureRecognizer(panGestureRecognizer)
        }
    }
```

- A handler for a gesture needs gesture-specific information
- The abstract superclass also provides state information
  - `var state : UIGestureRecognizerState { get }`
    - `.possible`, `.began`, `.changed`, `.ended`, `.recognized`, `failed`, `cancelled`

```swift
    func pan(recognizer : UIPanGestureRecognizer) {
        switch recognizer.state {
            case .changed : fallthrough
            case .ended :
                let translation = recognizer.translation(in : pannableView)
                // updte depands on the pan gesture
                recognizer.setTranslation(CGPoint.zero, in : pannableView)
                default : break
        }
    }
```

- UIPinchGestureRecognizer
  - `var scale : CGFloat`
  - `var velocity : CGFloat { get }`
- UIRotationGestureRecognizer
  - `var rotation : CGFloat`
  - `car velocity : CGFloat { get }`
- UISwipeGestureRecognizer
  - `var direction : UISwipeGestureRecognizerDirection`
  - `var numberOfTouchsRequired : Int`
- UITapGestureRecognizer
  - `var numberOfTapsRequired : Int`
  - `var numberOfTouchesRequired : Int`
- UILongPressRecognizer
  - `var minimumPressDuration : TimeInterval`
  - `var numberOfTouchesRequired : Int`
  - `var allowableMovement : CGFloat`

- Implementing a gesture in storyboard

<img width="480" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/10.jpg?raw=true">
<img width="480" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%206/imageFiles/11.jpg?raw=true">

<br>
 <br>
 
- Dealing with gesture `state`
  - You need to use switch

```swift
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended : playingCardView.isFaceUp = !playingCardView.isFaceUp
        default : break
        }
    }
```

```swift
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer : UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended :
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default : break
        }
    }
```    








