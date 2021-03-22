//
//  EYRegisterViewController.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/20.
//

import UIKit

class EYRegisterViewController: EYLoginBaseViewController {
    private var accountTextField: UITextField!
    private var passwordTextField: UITextField!
    private var re_passwordTextField: UITextField!
    private var registerButton: UIButton!
    private var toLoginButton: UIButton!
    
    override var titleString: String {
        return "注册"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTextField = self.createTextField(placeHold: " 请输入您的账号")
        accountTextField.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 200, width: screenWidth-30, height: 45)
        view.addSubview(accountTextField)
        
        passwordTextField = self.createTextField(placeHold: " 请输入您的密码")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.frame = CGRect(x: 15, y: accountTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
        view.addSubview(passwordTextField)
        
        re_passwordTextField = self.createTextField(placeHold: " 请输入您的密码")
        re_passwordTextField.isSecureTextEntry = true
        re_passwordTextField.frame = CGRect(x: 15, y: passwordTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
        view.addSubview(re_passwordTextField)
        
        registerButton = self.createOrangeButton(title: "注册")
        registerButton.backgroundColor = buttonThemeColorDisabled
        registerButton.isEnabled = false
        view.addSubview(registerButton)
        registerButton.frame = CGRect(x: 15, y: re_passwordTextField.frame.maxY + 20, width: screenWidth-30, height: 50)
        
        toLoginButton = self.createOrangeButton(title: "已有账号，去登陆")
        view.addSubview(toLoginButton)
        toLoginButton.frame = CGRect(x: 15, y: registerButton.frame.maxY + 10, width: screenWidth-30, height: 50)
        
        accountTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        re_passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        toLoginButton.addTarget(self, action: #selector(self.toLoginAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(self.registerAction), for: .touchUpInside)
    }
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        if accountTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && re_passwordTextField.text == passwordTextField.text {
            registerButton.isEnabled = true
            registerButton.backgroundColor = buttonThemeColorNormol
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = buttonThemeColorDisabled
        }
    }
    
    @objc
    func toLoginAction() {
        EYLoginSDKManager.shared().changeToLogin()
    }
    
    @objc
    func registerAction() {
        EYLoginSDKManager.shared().changeToAuthentication()
    }
}
