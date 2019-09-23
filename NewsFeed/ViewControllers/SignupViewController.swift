//
//  SignupViewController.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailIdTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var genderPicker: UIPickerView!
    let genderPickerValues = ["Male", "Female"]
    var serviceCall = Services()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceCall.apiReponseProtocol = self
        self.title = "Signup"
        self.initializaPickerView()
        
        self.cornerRadius(bgView: self.bgView)
        self.cornerRadius(bgView: submitBtn)
        // Do any additional setup after loading the view.
    }
    func initializaPickerView() {
       genderPicker = UIPickerView()
       genderPicker.dataSource = self
       genderPicker.delegate = self
       genderTxtField.inputView = genderPicker
       genderTxtField.text = genderPickerValues[0]
    }
    
    func spinnerAnimation() {
        DispatchQueue.main.async {
            (self.spinner.isAnimating) ? self.spinner.stopAnimating() : self.spinner.startAnimating()
        }
    }
    
    func clearData(){
        self.pwdTxtField.text = ""
        self.emailIdTxtField.text = ""
        self.usernameTxtField.text = ""
        self.confirmPwdTxtField.text = ""
        self.mobileNumberTxtField.text = ""
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
       self.view.endEditing(true)
        if usernameTxtField.text!.count <= 1 || emailIdTxtField.text!.count <= 1 || pwdTxtField.text!.count <= 1  ||
           confirmPwdTxtField.text!.count <= 1 || mobileNumberTxtField.text!.count <= 1 || genderTxtField.text!.count <= 1 {
            print("=== Please enter all the fields ===")
            self.alertViewShow("Alert", "Please Fill All The Fields")
            return
        }
        if pwdTxtField.text != confirmPwdTxtField.text {
            self.alertViewShow("Alert", "Both Password and Confirm Password are not equal")
        }
       
        let parameterDictionary = ["name" : usernameTxtField.text, "email" : emailIdTxtField.text, "password": pwdTxtField.text,"password_confirmation":confirmPwdTxtField.text, "mobile":mobileNumberTxtField.text, "gender": genderTxtField.text]
        
        self.spinnerAnimation()
        serviceCall.signupServiceCall(url: Constants.mainURL + "/register", body: parameterDictionary as NSDictionary, requestStr: "POST")
    }
}

extension SignupViewController {
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignupViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genderPickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        genderTxtField.text = genderPickerValues[row]
        self.view.endEditing(true)
    }
}

extension SignupViewController: APIResponse {
    func errorResponse(error : NSError) {
        print("=== Error Response ===", error)
        self.spinnerAnimation()
        self.alertViewShow("Failure", "Registaration Process Failed!")
    }
    func successResponse(response: Any) {
        self.spinnerAnimation()
        print("=== response ===", response)
        guard let response = response as? NSDictionary else {
         return
        }
        if response["success"] as! Int == 1 {
            self.alertViewShow("Success","Please login with your new emailID and Password")
            self.clearData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
