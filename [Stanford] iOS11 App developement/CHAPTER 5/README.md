# Chapter5 : 뷰에 나타내기
<img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/1.jpg?raw=true">

<br>
 <br>

## Playing Card
<img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/demo.jpg?raw=true">

<br>
 <br>

## Today i learned
- [Error Handling](#Error-Handling)
- [Any](#Any)
- [Other Interesting Classes](#Other-Interesting-Classes)
- [Views](#Views)
- [Drawing](#Drawing)
- [CustomStringConvertible](#CustomStringConvertible)

<br>
 <br>

### Error Handling
<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/2.jpg?raw=true">

- Thrown Errors
  - Swift methods can throw errors

```swift
    func save() throws  

    do {
        try context.save()
    } catch let error {
        /* ... */
        throw error // this would re-throw the error
                    // (only ok if the method we are in throws)
    }

    try! context.save() // this will crash if save() throws an error

    let x = try? errorFunctionReturnsAnInt()    // if errors, ignores error and returns nil
                                                // else, returns an Int
```

<br>
 <br>

### Any
<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/3.jpg?raw=true">

- Any & AnyObject
  - These types are for old Objective-C APIs
  - AnyObject holds classes only
  - `func prepare(for segue: UIStoryboardSegue, sender: Any?)`
    - The sender might be a UIButton or some custom thing in your code
    - It's an Optional because it's okay for a segue to happen without a sender being specified


- How do we use a variable of type Any?
  - we can't use it directly
  - Instead, we must convert it to another known type
  - Conversion is done with the `as?` (Optional)
  - You can check to see if something can be converted with the `is` keyword

```swift
    let unknown: Any = ...
    if let foo = unknown as? MyType {
        // foo is of type MyType in here
        // so we can invoke MyType methods or access MyType vars in foo
        // if unknown was not of type MyType, then we'll never get here
    }
```

- Casting
  - you can cast any type with `as?` into any other type that makes sense
  - "downcasting" also possible

```swift
    let vc : UIViewController = ConcentrationViewController()
    vc.flipCard() // errors, since vc is typed as a UIViewController

    if let cvc = vc as? ConcentrationViewController {
        cvc.flipCard() // this is okay
    }
```

<br>
 <br>

### Other Interesting Classes
<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/4.jpg?raw=true">

- Other Interesting Classes
  - NSObject
      - Base class for all Objective-C classes
  - NSNumber
    - Generic number-hoding class

``` swift
    let n = NSNumber(35.5) or let n : NSNumber = 35.5
    let intified : Int = n.intValue // also doubleValue, boolValue
```

- - Date
    - Value type used to find out the date and time
    - See also Calendar, DateFomatter, DateComponents // because of the variety of data systems
  - Data
    - A value type  "bag o' bits"

<br>
 <br>

### Views
<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/5.jpg?raw=true">

- Views
    - A view (i.e. `UIView` subclass) represents a rectangular area
    - Defines a coordinate space
    - For drawing
    - And for handling touch events


- Hierarchical
    - A view has only one superview ... `var superview: UIView?`
    - But it can have many subviews ... `var subviews: [UIView]`
    - The order in the subvies array matters : Later on top


- Initializing a UIView
    - A UIView's initializer is different if it comes out of a storyboard
        - `init(frame: CGRect)` // initializer if the UIView is created in code
        - `init(coder: NSCoder)` // initializer if the UIView comes out of a storyboard
    - If you need an initializer, implement them both

```swift
    func setup() { ... }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
```

- Another alternative to initializer in UIView
  - `awakeFromNib()` // only called if the UIView comes out of a storyboard
  - This is not an initializer
 
- Coordinate System Data Structures
  - CGFloat
    - `let cgf = CGFloat(aDouble)`
  - CGPoint
    - `var point = CGPoint(x: 37.0, y: 55.2)`
  - CGSize
    - `var size = CGSize(width: 100.0, height: 50.0)`
  - CGRect
    - `var rect = CGRect(origin: CGPoint, size: CGSize)`

- View Coordinate System
  - Origin is upper left
  - Units are `points`, not pixels
    - pixels per point? UIView's `var contentScaleFactor: CGFloat`
  - The boundaries of where drawing happens
    - `var bounds: CGRect`
  - Where is the UIView?
    - `var center: CGPoint`
    - `var frame: CGRect`


- Creating Views
  - Storyboard
    - Generic UIView with `Identity Inspector`
  - Code
    - frame initializer `let newView = UIView(freme: myViewFrame)`
    - or `let newView = UIView()` (frame will be CGRect.zero)

```swift
    // this codes are in a UIViewController
    let labelRect = CGRect(x: 20, y: 20, width: 100, height: 50)
    let label = UILabel(frame: labelRect) // UILabel is a subclass of UIView
    label.text = "Hello"
    view.addSubview(label)
```

- Custom Views
  - To draw, just create a UIView subclass and override draw(CGRect)
    - `override func draw(_ rect: CGRect)`
  - Never call draw(CGRect)
    - Instead, if your view needs to be redrawn
    - `setNeedsDisplay()` or `setNeedsDisplay(_ rect: CGRect)`
  - How to implement draw(CGRect)
    - using `UIBezierPath` class
  - Core Graphics Concept
    1. Function `UIGraphicsGetCurrentContext()` gives a context you can use in draw
    2. Create path
    3. Set drawing attributes like colors, fonts, etc
    4. Stroke or fill the paths

<br>
 <br>

<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/6.jpg?raw=true">

- Defining a Path
  - Create a UIBezierPath
```swift
    // this codes are in draw(_ rect: )
    let path = UIBezierPath()
    path.move(to: CGPoint(80, 50))
    path.addLine(to: CGPoint(140, 150))
    path.addLine(to: CGPoint(10, 150))
    path.close()
    
    UIColor.green.setFill()
    UIColor.red.setStroke()
    path.linewidth = 3.0
    path.fill()
    path.stroke()
```

<br>
 <br>
 
### Drawing
<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/7.jpg?raw=true">

- Drawing
  - Clipping
    - `addClip()`
  - Hit detection
    - `func contains(_ point: CGPoint) -> Bool` // returns if the point is inside the path


- UIColor
  - Background Color
    - `var backgroundColor: UIColor`
  - Transparency(alpha)
    - `let semitransparentYeloow = UIColor.yellow.withAlphaComponent(0.5)`
  - With transparency
    - you must let system know by setting the UIView `var opaque = false`
  - To make entire UIView transparent
    - `var alpha: CGFloat`


- View Transparency
  - Completely hiding a view without removing it from hierarchy
    - `var isHidden: Bool`


- Drawing Text
```swift
    let text = NSAttributedString(string: "hello")
    text.draw(at: CGPoint)
    let textSize: CGSize = text.size
```


- Accessing a range of characters in a NSAttributedString
```swift
    let pizzaJoint = "café pesto"
    var attrString = NSMutableAttributedString(string: pizzaJoint)
    let firstWordRange = pizzaJopint.startIndex..<pizzaJoint.firstIndex(of: " ")!
    let nsrange = NSRange(firstWordRange, in: pizzaJoint) // convert Range<String.Index>
    attrString.addAttribute(.strokeColor, value: UIColor.orange, range: nsrange)
```

<br>
 <br>

<img width=50% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/8.jpg?raw=true">

- Fonts
  - Be sure to choose a `preferred font`
  - Simple way to get a font in code
    -  `static func preferredFont(forTextStyle: UIFontTextStyle) -> UIFont`
    -  `UIFontTextStyle.headline`
  - More advanced way // custom font
    - `let font = UIFont(name: "Helvetica", size: 36.0)`
    - To scale font to the user's desired size, don't skip below
    - `let metrics = UIFontMetrics(forTextStyle: .body)`
    - `let fontToUse = metrics.scaledFont(for: font)`


- Drwaing Images
  -`UIImageView`
  - Creating a UIIMage object
    - `let image: UIImage? = UIImage(named: "foo")
    - you should add foo.jpg in `Assets.xcassets`
  - Getting from file system
    - `let image: UIImage? = UIImage(contentsOfFile: pathString)`
    - `let image: UIImage? = UIImage(data: Data)`
  - Once you have a UIImage, you can blast its bits on screen
 
 ```swift
    let image: UIImage = ...
    image.draw(at Point: CGPoint)
    image.draw(in rect: CGPoint)
    image.drawAsPattern(in rect: CGPoint)
```


- Redraw on bounds change?
  - when UIView's bounds changes, thest is `no redraw`
    - if you want to redraw, use `var contentMode: UIViewContentMode`
    - `.left`/`.right`/`.bottom`/`.center` ...
    - `.scaleToFill`/`.scaleAspectFill` ...
    - `.redraw`


- Layout on bounds change?
  - If your bounds change, you may want to reposition some of your subviews

```swift
    override func layoutSubviews() { // when you don't use Autolayout
        super.layoutSubviews()
    }
```

<br>
 <br>

### CustomStringConvertible
- It can provide their own representation 
- `var description: String` is necessary
<img width=40% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%205/imageFiles/9.jpg?raw=true">





