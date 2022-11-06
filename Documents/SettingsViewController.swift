

import UIKit

let userDefaults = UserDefaults()


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switcher: UISwitch!
    
    
    @IBAction func sortSwitch(_ sender: Any) {
        if switcher.isOn {
            userDefaults.set(true, forKey: "sort")
        } else {
            userDefaults.set(false, forKey: "sort")
        }
    }
    
    @IBAction func changePassTap(_ sender: Any) {
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
        let nc = UINavigationController(rootViewController: loginVC)
        self.navigationController?.present(nc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
