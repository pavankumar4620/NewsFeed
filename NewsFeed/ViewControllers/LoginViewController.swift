//
//  ViewController.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertViewShow(_ title : String,_ msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                print("=== some error ====")
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func cornerRadius(bgView : UIView) {
        bgView.layer.masksToBounds = false
        bgView.layer.cornerRadius = 5
    }
}
class LoginViewController: UIViewController {

    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var emailIdTxtField: UITextField!
    var serviceCall = Services()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var registrationBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        serviceCall.apiReponseProtocol = self
        self.cornerRadius(bgView: self.bgView)
        self.cornerRadius(bgView: loginBtn)
        self.cornerRadius(bgView: registrationBtn)
    }
    
    func spinnerAnimation() {
        DispatchQueue.main.async {
            (self.spinner.isAnimating) ? self.spinner.stopAnimating() : self.spinner.startAnimating()
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
       
        if emailIdTxtField.text!.isEmpty || pwdTxtField.text!.isEmpty {
            print("=== Please enter all the fields ===")
            self.alertViewShow("Alert", "Please Fill All The Fields")
            return
        }
        
      /* if emailIdTxtField.text!.count <= 1 || pwdTxtField.text!.count <= 1 {
            print("=== Please enter all the fields ===")
            self.alertViewShow("Alert", "Please Fill All The Fields")
            return
        }
 */
        if !self.isValidEmail(emailStr: emailIdTxtField.text!) {
            self.alertViewShow("Alert", "EmailId Format is wrong")
            return
        }
 
        let parameterDictionary = ["email" : emailIdTxtField.text, "password": pwdTxtField.text]
        self.spinnerAnimation()
        serviceCall.signupServiceCall(url: Constants.mainURL + "/login" , body: parameterDictionary as NSDictionary, requestStr: "POST")
        
    }

    
    @IBAction func registrationBtnClicked(_ sender: Any) {
      let signupVC =  self.storyboard?.instantiateViewController(withIdentifier:"SignupViewController") as! SignupViewController
      self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func clearData(){
        self.pwdTxtField.text = ""
        self.emailIdTxtField.text = ""
    }
}


// Mark : Instance Methods
extension LoginViewController {
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
}
// Pragma Mark : Textfield Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: APIResponse{
    func errorResponse(error : NSError) {
        print("=== Error Response ===", error)
        self.spinnerAnimation()
        self.alertViewShow("Failure", "Authentication Failed!")
    }
    func successResponse(response: Any) {
         self.spinnerAnimation()
        guard let response = response as? NSDictionary else {
            return
        }
        
        if response["message"] as! String == "Authentication Success"{
            guard let user = response["user"] as? NSDictionary  else {
                return
            }
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.emailIdTxtField.text, forKey: "emailID")
                UserDefaults.standard.set(user["api_token"] as! String, forKey: "api_token")
                let newsFeedVC =  self.storyboard?.instantiateViewController(withIdentifier:"NewsFeedListViewController") as! NewsFeedListViewController
                self.navigationController?.pushViewController(newsFeedVC, animated: true)
                
            }
        }else {
            self.alertViewShow("Failure", response["message"] as! String)
        }
    }
}
