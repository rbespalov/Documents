
import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    
    let keyChain = KeychainSwift()
    
    var passInputCount: Int = 0
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var passButton: UIButton!
    
    @IBAction func tapLoginButton(_ sender: Any) {
                
//        keyChain.delete("UserPass")
        if passInputCount == 0 {
            if passTextField.text!.count >= 4 && passTextField.text != nil {
                
                keyChain.set(passTextField.text!, forKey: "UserPass")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
                vc.passInputCount = 1
                vc.loadViewIfNeeded()
                vc.passButton.setTitle("Repeat password", for: .normal)
                self.navigationController?.pushViewController(vc, animated: false)
            } else {
                let alert = UIAlertController(title: "Ooops", message: "Password should contain 4 sympols or more", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(action)
                self.navigationController?.present(alert, animated: true)
            }
        }
        
        if passInputCount == 1 {
            if passTextField.text! == keyChain.get("UserPass") {
                let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
                self.navigationController?.pushViewController(tabBar, animated: true)
            } else {
                let alert = UIAlertController(title: "Ooops", message: "Incorrect password, please try again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
                    vc.passInputCount = 0
                    vc.loadViewIfNeeded()
                    vc.passButton.setTitle("Create password", for: .normal)
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                alert.addAction(action)
                self.navigationController?.present(alert, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
