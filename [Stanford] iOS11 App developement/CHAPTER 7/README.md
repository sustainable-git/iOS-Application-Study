# Chapter7 : 여러개의 MVC, 타이머, 애니메이션
<Img>

<br>
 <br>

## Playing Card
<demo>

<br>
 <br>

## Today i learned
[Multiple MVCs]
[Timer]
[Animation]

- MVCs working together
  - iOS provides some Controllers whose View is "other MVCs"
    - `UITabBarController`
    - `UISplitViewController`
    - `UINavigationController`
  - You could build your own Controller but not usual

- UITabBarController
  - It lets the user choose between different MVCs

<img>

- UISplitViewController
  - Puts two MVCs side-by-side

<img>

- UINavigationController
  - Pushes and pops MVCs off of a stack

<img>
<img>

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

<img>

-  - Split view can only do properly on iPad/iPhone+
      - Wrapping master in Navigation Controller, you can make it adapt

<img>

- Segues
  - We've built up our Controllers of Controllers
  - That MVC can cause another to appear is called a "segue"
  - Segues always create a `new instance` of an MVC
  - Identifier is needed preparing for a segue

<img>

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

<img>
<img>

- Segues

<img> // control + drag with button and view
<img> // Choose theme

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

- Split View Controller

<img> // master
<img> // Show Detail

- Tab Bar Controller

<img>

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

timer continues~








