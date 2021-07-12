# Chapter7 : 여러개의 MVC, 타이머, 애니메이션
<Img src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/1.jpg?raw=true">

<br>
 <br>

## Playing Card
<Img width=100% src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/demo.gif?raw=true">

<br>
 <br>

## Today i learned
- [Multiple MVCs](#Multiple-MVCs)
- [Timer](#Timer)
- [Animation](#Animation)

<br>
 <br>

### Multiple MVCs

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/2.jpg?raw=true">

- MVCs working together
  - iOS provides some Controllers whose View is "other MVCs"
    - `UITabBarController`
    - `UISplitViewController`
    - `UINavigationController`
  - You could build your own Controller but not usual

- UITabBarController
  - It lets the user choose between different MVCs

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/3.jpg?raw=true">

<br>
 <br>
	
- UISplitViewController
  - Puts two MVCs side-by-side

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/4.jpg?raw=true">

<br>
 <br>
	
- UINavigationController
  - Pushes and pops MVCs off of a stack

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/5.jpg?raw=true"> <img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/6.jpg?raw=true">

<br>
 <br>

- Accessing the sub-MVCs
  - You can get the sub-MVCs via the `viewControllers` property
    - `var viewControllers : [UIViewController]? { get set }`
  - But how do you get ahold of the SVC, TBC NC itself?
    - `var tapBarController : UITabBarController? { get }`
    - `var splitViewController : UISplitViewController? { get }`
    - `var navigationController : UINavigationController? { get }`

- Pushing/Popping
  - Adding(or removing) MVCs from a UINavigationController
    - `func pushViewController(_ vc : UIViewController, animated : Bool)`
    - `func popViewController(animated : Bool)`
    - But we usually don't do this

- Wiring up MVCs

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/7.jpg?raw=true">

-  - Split view can only do properly on iPad/iPhone+
      - Wrapping master in Navigation Controller, you can make it adapt

<br>
 <br>

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/8.jpg?raw=true">

- Segues
  - We've built up our Controllers of Controllers
  - That MVC can cause another to appear is called a "segue"
  - Segues always create a `new instance` of an MVC
  - Identifier is needed preparing for a segue

- Preparing for a Segue
  - Preparation is happening `BEFORE` outlet get set

```swift
    func prepare(for segue : UIStoryboardSegue, sender : Any?) {
        if let identifier = segue.identifier { // identifier should not be a nil
            switch identifier {
                case "Show Graph" :
                    if let vc = segue.destination as? GraphController { // down casting
                        vc.property1 = ...
                        vc.callMethodToSetItUp(...)
                    }
                default : break
            }
        }
    }
```

- Preventing Segues
  - `func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool`
  - If it returns false, you can prevent happening

- Creating View Controller on Storyboard
  - Arrow means the first view to show

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/9.jpg?raw=true">
<img width=240 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/10.jpg?raw=true">

<br>
 <br>	
	
- Segues
  - To add segue between two views, just Control + drag
  - If you want to call, use identifier

<img width=240 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/11.jpg?raw=true">
<img width=240 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/12.jpg?raw=true" >

<br>
 <br>

- Segue preparation
  - Because that preparation happens before outlet, errors can occur

```swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" { // never follow below (The part comparing currentTitle)
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentraionViewController {
                    cvc.theme = theme // at this part, you can modify theme
                }
            }
        }
    }
```

<br>
 <br>
	
- Split View Controller

<img width=240 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/13.jpg?raw=true"> <img width=240 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/14.jpg?raw=true">

<br>
 <br>
	
- Tab Bar Controller

<img width=480 src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%207/imageFiles/15.jpg?raw=true">

<br>
 <br>
	
- Segue in code
  - Make segue between two views

```swift
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
```

- Changing theme without using segue
  - Below works with splitView divies(iPad)

```swift
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    } // .last means detail
    
    @IBAction func changeTheme(_ sender: UIButton) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            /* ... */
        }
    }
```

- - To work with iPhone, we need a pointer
```swift
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let identifier = segue.identifier, identifier == "Choose Theme", let cvc = segue.destination as? ConcentrationViewController {
        //    if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
        //        cvc.theme = theme
                lastSeguedToConcentrationViewController = cvc
            }
        }
    }
    
    @IBAction func changeTheme(_ sender: UIButton) {
        if { /* ... */ }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        /* ... */
    }
```

- Delegate

```swift
    class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController
        ) -> Bool
    {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            return cvc.theme == nil
        }
        return false
    } // putting detail on top of master
```

<br>
 <br>	

### Timer

- Timer
  - Used to execute code periodically

```swift
class func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: (Timer) -> Void) -> Timer

	private weak var timer: Timer?
	timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeat: true){ /* closure */ }
	// every single 2 seconds, closure executes
```

- Stopping timer
  - `timer.invalidate` // this makes timer nil ( reason of `weak` )

- Tolerance : 오차
  - Tolerance can make your battery efficiency better
  - `timer.tolerance = 10` // in 10 seconds

<br>  <br>



### Animation

- Kinds of Animation
  - Animating UIView properties
  - Animating Controller transitions
  - Core Animation
  - OpenGL and Metal
  - SpriteKit
  - Dynamic Animation



- UIView Animation
  - Changes to certain UIView properties can be animated over time
    - frame/center
    - bounds
    - transform
    - alpha
    - backgroundColor
