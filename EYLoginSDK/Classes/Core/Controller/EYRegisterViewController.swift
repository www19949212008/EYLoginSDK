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
    private let hud = ProgressHud()
    
    private var nameTextField: UITextField?
    private var idTextField: UITextField?
    
    override var titleString: String {
        return "注册"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTextField = self.createTextField(placeHold: "请输入您的账号")
        if EYLoginSDKManager.isTestMode {
            accountTextField.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 120, width: screenWidth-30, height: 45)
        } else {
            accountTextField.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 200, width: screenWidth-30, height: 45)
        }
        
        view.addSubview(accountTextField)
        
        passwordTextField = self.createTextField(placeHold: "请输入您的密码")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.frame = CGRect(x: 15, y: accountTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
        view.addSubview(passwordTextField)
        
        re_passwordTextField = self.createTextField(placeHold: "请输入您的密码")
        re_passwordTextField.isSecureTextEntry = true
        re_passwordTextField.keyboardType = .asciiCapable
        re_passwordTextField.frame = CGRect(x: 15, y: passwordTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
        view.addSubview(re_passwordTextField)
        
        
        if EYLoginSDKManager.isTestMode {
            nameTextField = self.createTextField(placeHold: "请输入您的姓名")
            nameTextField?.frame = CGRect(x: 15, y: re_passwordTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
            view.addSubview(nameTextField!)
            
            idTextField = self.createTextField(placeHold: "请输入您的身份证号码")
            idTextField?.frame = CGRect(x: 15, y: nameTextField!.frame.maxY + 10, width: screenWidth-30, height: 45)
            view.addSubview(idTextField!)
        }
        
        registerButton = self.createOrangeButton(title: "注册")
        registerButton.backgroundColor = buttonThemeColorDisabled
        registerButton.isEnabled = false
        view.addSubview(registerButton)
        if EYLoginSDKManager.isTestMode {
            registerButton.frame = CGRect(x: 15, y: idTextField!.frame.maxY + 20, width: screenWidth-30, height: 50)
        } else {
            registerButton.frame = CGRect(x: 15, y: re_passwordTextField.frame.maxY + 20, width: screenWidth-30, height: 50)
        }
        
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
        var params: [String : Any]
        var url = ""
        if EYLoginSDKManager.isTestMode {
            url = "\(testHost)/user_edition/register"
            params = ["username": accountTextField.text ?? "", "password": passwordTextField.text ?? "", "appkey": EYLoginSDKManager.shared().appkey, "id_card": idTextField?.text ?? "", "realname": nameTextField?.text ?? "", "deviceType": "ios", "deviceId": NSUUID().uuidString]
        } else {
            url = "\(host)/user/register"
            params = ["username": accountTextField.text ?? "", "password": passwordTextField.text ?? "", "appkey": EYLoginSDKManager.shared().appkey, "deviceType": "ios", "deviceId": NSUUID().uuidString]
        }
        hud.showAnimatedHud()
        EYNetworkService.sendRequstWith(method: .post, urlString: url, params: params) { (isSuccess, data, error) in
            self.hud.stopAnimatedHud()
            if isSuccess {
                let d = data?["data"] as? [String: Any]
                let uid = d?["uid"] as? Int
                let status = d?["status"] as? Int
                let auth = d?["needauth"] as? Int
                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
                if auth == 1 {
                    UserDefaults.standard.setValue(EYLoginState.registedNeedAuthentication.rawValue, forKey: loginStateIdentifier)
                    UserDefaults.standard.synchronize()
                    EYLoginSDKManager.shared().changeToAuthentication()
                } else if status == 1 {
                    EYLoginSDKManager.shared().loginSuccess()
                } else {
                    UserDefaults.standard.setValue(EYLoginState.registed.rawValue, forKey: loginStateIdentifier)
                    UserDefaults.standard.synchronize()
                    EYLoginSDKManager.shared().changeToLogin()
                }
            } else {
                ProgressHud.showTextHud(data?["message"] as? String ?? "注册失败，请稍后重试")
                debugLog(message: "register error:", error.debugDescription)
            }
        }
    }
}
