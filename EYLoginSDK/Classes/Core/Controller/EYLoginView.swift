//
//  EYLoginView.swift
//  EYLoginSDK
//
//  Created by eric on 2021/9/24.
//

import UIKit

class EYLoginView: FullScreenBaseView {
    private var nameTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private let hud = ProgressHud()

    override func setupWhiteView() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.text = "登陆"
        whiteView.addSubview(titleLabel)
        let tc1 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: whiteView, attribute: .top, multiplier: 1, constant: 15)
        let tc2 = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: whiteView, attribute: .centerX, multiplier: 1, constant: 0)
        whiteView.addConstraints([tc1, tc2])
        
        let cornerView = UIView()
        cornerView.backgroundColor = UIColor.white
        cornerView.clipsToBounds = true
        cornerView.translatesAutoresizingMaskIntoConstraints = false
        cornerView.layer.cornerRadius = 5
        whiteView.addSubview(cornerView)
        let cnc1 = NSLayoutConstraint(item: cornerView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15)
        let cnc2 = NSLayoutConstraint(item: cornerView, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let cnc3 = NSLayoutConstraint(item: cornerView, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        let cnc4 = NSLayoutConstraint(item: cornerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100+1/UIScreen.main.scale)
        whiteView.addConstraints([cnc1, cnc2, cnc3, cnc4])
        
        nameTextField = createTextField(placeHold: "账号：6-15位数字，字母和下划线")
        nameTextField.textColor = UIColor.black
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        cornerView.addSubview(nameTextField)
        let nc1 = NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: cornerView, attribute: .top, multiplier: 1, constant: 0)
        let nc2 = NSLayoutConstraint(item: nameTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let nc3 = NSLayoutConstraint(item: nameTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let nc4 = NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        cornerView.addConstraints([nc1, nc2, nc3, nc4])
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.lightGray
        cornerView.addSubview(lineView)
        let lc1 = NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom, multiplier: 1, constant: 0)
        let lc2 = NSLayoutConstraint(item: lineView, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let lc3 = NSLayoutConstraint(item: lineView, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let lc4 = NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1/UIScreen.main.scale)
        cornerView.addConstraints([lc1, lc2, lc3, lc4])

        passwordTextField = createTextField(placeHold: "密码：6-15位数字，字母和下划线")
        passwordTextField.textColor = UIColor.black
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .asciiCapable
        cornerView.addSubview(passwordTextField)
        let pc1 = NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: lineView, attribute: .bottom, multiplier: 1, constant: 0)
        let pc2 = NSLayoutConstraint(item: passwordTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let pc3 = NSLayoutConstraint(item: passwordTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let pc4 = NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        cornerView.addConstraints([pc1, pc2, pc3, pc4])
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        whiteView.addSubview(loginButton)
        loginButton.backgroundColor = buttonThemeColorDisabled
        loginButton.isEnabled = false
        loginButton.setTitle("登陆", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        let cc1 = NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: cornerView, attribute: .bottom, multiplier: 1, constant: 15)
        let cc2 = NSLayoutConstraint(item: loginButton, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let cc3 = NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        let cc4 = NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        whiteView.addConstraints([cc1, cc2, cc3, cc4])
        
        let toRegisterButton = UIButton()
        whiteView.addSubview(toRegisterButton)
        toRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        toRegisterButton.backgroundColor = buttonThemeColorNormol
        toRegisterButton.setTitle("没有账号，去注册", for: .normal)
        toRegisterButton.layer.cornerRadius = 5
        toRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        let trc1 = NSLayoutConstraint(item: toRegisterButton, attribute: .top, relatedBy: .equal, toItem: loginButton, attribute: .bottom, multiplier: 1, constant: 15)
        let trc2 = NSLayoutConstraint(item: toRegisterButton, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let trc3 = NSLayoutConstraint(item: toRegisterButton, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        let trc4 = NSLayoutConstraint(item: toRegisterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        let tpc5 = NSLayoutConstraint(item: toRegisterButton, attribute: .bottom, relatedBy: .equal, toItem: whiteView, attribute: .bottom, multiplier: 1, constant: -15)
        whiteView.addConstraints([trc1, trc2, trc3, trc4, tpc5])
        
        let wc1 = NSLayoutConstraint(item: whiteView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let wc2 = NSLayoutConstraint(item: whiteView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let wc3 = NSLayoutConstraint(item: whiteView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: min(screenWidth-30, screenHeight-30))
        self.addConstraints([wc1, wc2, wc3])
        
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        toRegisterButton.addTarget(self, action: #selector(self.toRegisterButtonAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.loginButtonAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    func createTextField(placeHold: String) -> UITextField {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 45))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = placeHold
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = .none
        textField.tintColor = UIColor.black
        textField.backgroundColor = UIColor.white
        return textField
    }
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        if nameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 {
            loginButton.isEnabled = true
            loginButton.backgroundColor = buttonThemeColorNormol
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = buttonThemeColorDisabled
        }
    }
    
    @objc
    func loginButtonAction() {
//        let params = ["username": nameTextField.text ?? "", "password": passwordTextField.text ?? "", "appkey": EYLoginSDKManager.shared().appkey, "deviceType": "ios", "deviceId": NSUUID().uuidString] as [String : Any]
//        hud.showAnimatedHud()
//        var url = ""
//        if EYLoginSDKManager.isTestMode {
//            url = "\(testHost)/login"
//        } else {
//            url = "\(host)/login"
//        }
//        EYNetworkService.sendRequstWith(method: .post, urlString: url, params: params) { (isSuccess, data, error) in
//            self.hud.stopAnimatedHud()
//            if isSuccess {
//                EYLoginSDKManager.isAnonymous = false
//                let d = data?["data"] as? [String: Any]
//                let uid = d?["uid"] as? String
//                let holidayArr = d?["holiday"] as? [String]
//                UserDefaults.standard.setValue(holidayArr, forKey: holidayIdentifier)
//                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
//                    let isAdult = d?["adult"] as? Int == 0 ? false : true
//                    UserDefaults.standard.set(isAdult, forKey: isAdultIdentifier)
//                    UserDefaults.standard.synchronize()
//                    EYLoginSDKManager.shared().loginSuccess()
//            } else {
//                ProgressHud.showTextHud(data?["message"] as? String ?? "登陆失败，请稍后重试")
//                debugLog(message: "login error:", error.debugDescription)
//            }
//        }
    }
    
    @objc
    func toRegisterButtonAction() {
        EYLoginSDKManager.shared().changeToRigister()
    }
}
