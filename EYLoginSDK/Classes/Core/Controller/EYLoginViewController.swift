//
//  ViewController.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/19.
//

import UIKit

class EYLoginViewController: EYLoginBaseViewController {
    private var accountTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private var toRegisterButton: UIButton!
    private let hud = ProgressHud()
    
    override var titleString: String {
        return "账号登陆"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHud.showTextHud("暂时无法登陆")
        accountTextField = self.createTextField(placeHold: " 请输入您的账号")
        accountTextField.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 200, width: screenWidth-30, height: 45)
        view.addSubview(accountTextField)
        
        passwordTextField = self.createTextField(placeHold: " 请输入您的密码")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.frame = CGRect(x: 15, y: accountTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
        view.addSubview(passwordTextField)
        
        loginButton = self.createOrangeButton(title: "登陆")
        loginButton.backgroundColor = buttonThemeColorDisabled
        loginButton.isEnabled = false
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 15, y: passwordTextField.frame.maxY + 20, width: screenWidth-30, height: 50)
        
        toRegisterButton = self.createOrangeButton(title: "没有账号，去注册")
        view.addSubview(toRegisterButton)
        toRegisterButton.frame = CGRect(x: 15, y: loginButton.frame.maxY + 10, width: screenWidth-30, height: 50)
        
        accountTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        toRegisterButton.addTarget(self, action: #selector(self.toRegisterButtonAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.loginButtonAction), for: .touchUpInside)
    }
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        if accountTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 {
            loginButton.isEnabled = true
            loginButton.backgroundColor = buttonThemeColorNormol
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = buttonThemeColorDisabled
        }
    }
    
    @objc
    func loginButtonAction() {
        let params = ["username": accountTextField.text ?? "", "password": passwordTextField.text ?? "", "appkey": EYLoginSDKManager.shared().appkey] as [String : Any]
        hud.showAnimatedHud()
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(host)/user/login", params: params) { (isSuccess, data, error) in
            self.hud.stopAnimatedHud()
            if isSuccess || data?["code"] as? Int == 1004  {
                let d = data?["data"] as? [String: Any]
                let uid = d?["uid"] as? Int
                let status = d?["status"] as? Int
                let auth = d?["auth"] as? Int
                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
                if auth == 0 {
                    UserDefaults.standard.setValue(EYLoginState.registedNeedAuthentication.rawValue, forKey: loginStateIdentifier)
                    UserDefaults.standard.synchronize()
                    EYLoginSDKManager.shared().changeToAuthentication()
                } else if status == 1 {
                    EYLoginSDKManager.shared().loginSuccess()
                } else {
                    ProgressHud.showTextHud("暂时无法登陆，请稍后重试")
                }
            } else {
                if let e = error {
                    ProgressHud.showTextHud("登陆失败，请稍后重试 error code:\((e as NSError).code)")
                } else {
                    ProgressHud.showTextHud("登陆失败，请稍后重试")
                }
                debugLog(message: "login error:", error.debugDescription)
            }
        }
    }
    
    @objc
    func toRegisterButtonAction() {
        EYLoginSDKManager.shared().changeToRigister()
    }
}
