# Chapter8 : 에니메이션

<img>



<br>

 <br>



## Playing Card

<img>



<br>

 <br>



## Today i learned

- [UIView Animation](#UIView-Animation)

- [Dynamic Animation](#Dynamic-Animation)
- [Memory Cycle Avoidance](#Memory-Cycle_Avoidance)



<br>

 <br>



### UIView Animation

<img>



- UIView Animation
  - Changes to certain UIView properties can animated over time
    - frame/center
    - bounds
    - transform
    - alpha
    - backgroundColor
  - Done with UIViewPropertyAnimator using closures



- UIViewPropertyAnimator

  ``` swift
  class func runningPropertyAnimator(
      withDuration: TimeInterval,
      delay: TimeInterval,
      options: UIViewAnimationOptions,
      animations: () -> Void,
      completion: ((position: UIViewAnimatingPosition) -> Void)? = nil
  )
  ```

- Example

  ```swift
  if myView.alpha == 1.0 {
    UIViewPropertyAnimator.runningPropertyAnimator(
      	withDuration: 3.0,
      	delay: 2.0
      	option: [.allowUserInteraction],
      	animations: { myView,alpha = 0.0 },
  	    completion: { if $0 == .end { myView.removeFromSuperview() } }
    )
    print("alpha = \(myView.alpha)") // alpha immediately become 0 when animation starts
  }
  ```



- UIViewAnimationOptions
  - beginFromCurrentState
  - allowUserInteraction
  - layoutSubviews
  - repeat
  - autoreverse
  - overrideInheritedDuration
  - overrideInheritedCurve
  - allowAnimatedContent
  - curveEaseInEaseOut
  - curveEaseIn
  - curveLinear



- Entire view modification at once

  - Flip : `UIViewAnimationOptions.transitionFlipForm{Left, Right, Top, Bottom}`
  - Dissolve : `.transitionCrossDissolve`
  - Curling up or down : `.transitionCurl{Up, Down}`

- Example for flipping a playing card over

  ```swift
  UIView.transition(with: myPlayingCardView,
  								duration: 0.75,
  								options: [.transitionFlipFromLeft],
  								animations: { cardIsFaceUp = !cardIsFaceUp }
  								completion: nil)
  ```



<br>

 <br>



### Dynamic Animation

<img>



- Dynamic Animation

  - Create a UIDynamicAnimator

    - `var animator = UIDynamicAnimator(referenceView: UIView)`

  - Create and add UIDynamicBehavior instances

    - e.g. `let gravity = UIGravityBehavior()`
    - `animator.addBehavior(gravity)`
    - e.g. `collider = UICollisionBehavior()`
    - `animator.addBehavior(collider)`

  - Add UIDynamicItems to a UIDynamicBehavior

    - `let item1: UIDynamicItem = ...`
    - `let item2: UIDynamicItem = ...`
    - `gravity.addItem(item1)`
    - `collider.addItem(item1)`
    - `gravity.addItem(item2)`

  - UIDynamicItem protocol

    ```swift
    protocol UIDynamicItem{
    	var bounds: CGRect { get }
      var center: CGPoint { get set }
      var transform: CGAffineTransform { get set }
      var collisionBoundsType: UIDynamicItemCollisionBoundsType { get set }
      var collisionBoundingPath: UIBezierPath { get set }
    }
    ```

    - If you change center of transform while the animation is running
    - `func updateItemUsingCurrentState(item: UIDynamicItem)`



- Behaviors
  - UIGravityBehavior
    - `var angle: CGFloat`
    - `var magnitude: CGFloat` // 1.0 = 1000 points/s/s which feels like 9.8 m/s<sup>2</sup>
    
  - UIAttachmentBehavior
    - `init(item: UIDynamicItem, attachedToAnchor: CGPoint)`
    - `init(item: UIDynamicItem, attachedTo: UIDynamicItem)`
    - `init(item: UIDynamicItem, offsetFromCenter: CGPoint, attachedTo[Anchor]...)`
    - `var length: CGFloat`
    - `var anchorPoint: CGPoint`
    
  - UICollisionBehavior
    - `var collisionMode: UICollisionBehaviorMode` // .items, .boundaries, or .everything
    - `func addBoundary(withIdentifier: NSCopying, for: UIBezierPath)`
    - `func addBoundary(withIdentifier: NSCopying, from: CGPoint, to: CGPoint)`
    - `func removeBoundary(withIdentifier: NSCopying)`
    - `var translateReferenceBoundsIntoBoundary: Bool`
    - `NSCopying` : NSString or NSNumber
    
  - UICollisionBehavior delegate
    - `var collisionDelegate: UICollisionBehaviorDelegate`
    
  - UISnapBehavior
    - `init(item: UIDynamicItem, snapTo: CGPoint)`
    
  - UIPushBehavior
    - `var mode: UIPushBehaviorMode`
    - `var pushDirection: CGVector`
    - `var angle: CGFloat`
    - `var magnitude: CGFloat`
    
  - UIDynamicItemBehavior
  
    - `var allowsRotation: Bool`
    - `var friction: CGFloat`
    - `var elasticity: CGFloat`
    - `func linearVelocity(for: UIDynamicItem) -> CGPoint`
    - `func addLinearVelocity(CGPoint, for: UIDynamicItem)`
    - `func angularVelocity(for: UIDynamicItem) -> CGFloat`
  
  - UIDynamicBehavior
  
    - Superclass of behaviors
  
    - You can collect other behaviors into one
  
    - `func addChildBehavior(UIDynamicBehavior)`
  
    - `var dynamicAnimator: UIDynamicAnimator? { get }`
  
    - `func willMove(to: UIDynamicAnimator?)`
  
    - `var action: (() -> Void)?` // executes everytime
  
      

- Stasis
  - UIDynamicAnimator's delegate tells you when animation pauses
    - `var delegate: UIDynamicAnimatorDelegate`
    - `func dynamicAnimatorDidPause(UIDynamicAnimator)`
    - `func dynamicAnimatorWillPause(UIDynamicAnimator)`



<br>

 <br>

### Memory Cycle Avoidance

<img>



- Memory Cycle Avoidance

  - Example of using `action` and avoiding memory cycle

    ```swift
    if let pushBehavior = UIPushBehavior(items: [...], mode: .instantaneous) {
    	pushBehavior.magnitude = ...
    	pushBehavior.anglie = ...
    	pushBehavior.action = {																				// memory cycle problem!!
    		pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)	// action closure and pushBehavior
    	}																															// can't ever leave the heap
    	animator.addBehavior(pushBehavior)
    }
    ```



- Closure Capturing

  - Local variables of a closure

    ```swift
    var foo = { [x = someInstanceOfaClass, y = "hello"] in
    	/* ... */
    }
    ```

  - Locals can be declared weak

    ```swift
    var foo = { [weak x = someInstanceOfaClass, y = "hello"] in
    	// x is Optional
    }
    ```

  - Or unowned

    ```swift
    var foo = { [unowned x = someInstanceOfaClass, y = "hello"] in
    	// if you use x and it is not in the heap, Crash!
    }
    ```



- Memory Cycle Avoidance

  - Example of using `action` and avoiding memory cycle

    ```swift
    if let pushBehavior = UIPushBehavior(items: [...], mode: .instantaneous) {
    	pushBehavior.magnitude = ...
    	pushBehavior.anglie = ...
    	pushBehavior.action = { [unowned pushBehavior] in							// memory cycle is broken
    		pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
    	}
    	animator.addBehavior(pushBehavior)
    }
    ```



