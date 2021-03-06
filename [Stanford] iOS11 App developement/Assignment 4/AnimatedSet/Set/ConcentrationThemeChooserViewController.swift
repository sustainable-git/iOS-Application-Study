//
//  ConcentrationThemeChooserViewController.swift
//  Set
//
//  Created by shin jae ung on 2021/12/25.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    let themes = [
        "Sports": "β½οΈππβΎοΈπΎπππ±πβ·π³β³οΈ",
        "Animals": "πΆπ¦πΉπΈππ¦ππ©π¦π¦ππ",
        "Faces": "ππππ€π π€π­π°π±π³ππ"
    ]
    
    @IBAction func changeTheme(_ sender: UIButton) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = sender.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = sender.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "Choose Theme", let cvc = segue.destination as? ConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
                lastSeguedToConcentrationViewController = cvc
            }
        }
        
    }
}

extension ConcentrationThemeChooserViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            return cvc.theme == nil
        }
        return false
    }
}
