//
//  EYRegisterView.swift
//  EYLoginSDK
//
//  Created by eric on 2021/9/24.
//

import UIKit

class EYRegisterView: FullScreenBaseView {
    private var accountTextField: UITextField!
    private var passwordTextField: UITextField!
    private var re_passwordTextField: UITextField!
    private var nameTextField: UITextField!
    private var idTextField: UITextField!
    private var registerButton: UIButton!
    private var toLoginButton: UIButton!
    private let hud = ProgressHud()
    private let scrollView = UIScrollView()
    private let tipLabel = UILabel()
    
    private var centerYConstraint: NSLayoutConstraint?
    private var heightYConstraint: NSLayoutConstraint?
    
    override func setupWhiteView() {
        let w = min(screenWidth-30, screenHeight-30)
        
        whiteView.addSubview(scrollView)
        whiteView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(red: 0/255.0, green: 140/255.0, blue: 236/255.0, alpha: 1)
        let sc1 = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: whiteView, attribute: .top, multiplier: 1, constant: 0)
        let sc2 = NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 0)
        let sc3 = NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: 0)
        let sc4 = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: whiteView, attribute: .bottom, multiplier: 1, constant: 0)
        whiteView.addConstraints([sc1, sc2, sc3, sc4])
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.numberOfLines = 2
        titleLabel.text = "根据国家规定，玩家需实名认证，否则后续无法正常游戏"
        scrollView.addSubview(titleLabel)
        let tc1 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 15)
        let tc2 = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let tc3 = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w-30)
        scrollView.addConstraints([tc1, tc2, tc3])
        
        let num: CGFloat = EYLoginSDKManager.shared().status == 1 ? 3 : 5
        
        let cornerView = UIView()
        cornerView.backgroundColor = UIColor.white
        cornerView.clipsToBounds = true
        cornerView.translatesAutoresizingMaskIntoConstraints = false
        cornerView.layer.cornerRadius = 5
        scrollView.addSubview(cornerView)
        let cnc1 = NSLayoutConstraint(item: cornerView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15)
        let cnc2 = NSLayoutConstraint(item: cornerView, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let cnc3 = NSLayoutConstraint(item: cornerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w-30)
        let cnc4 = NSLayoutConstraint(item: cornerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50*num+(num-1)/UIScreen.main.scale)
        scrollView.addConstraints([cnc1, cnc2, cnc3, cnc4])
       
        accountTextField = createTextField(placeHold: "账号：6-15位数字，字母和下划线")
        accountTextField.keyboardType = .asciiCapable
        cornerView.addSubview(accountTextField)
        let nc1 = NSLayoutConstraint(item: accountTextField, attribute: .top, relatedBy: .equal, toItem: cornerView, attribute: .top, multiplier: 1, constant: 0)
        let nc2 = NSLayoutConstraint(item: accountTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let nc3 = NSLayoutConstraint(item: accountTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let nc4 = NSLayoutConstraint(item: accountTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        cornerView.addConstraints([nc1, nc2, nc3, nc4])
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.lightGray
        cornerView.addSubview(lineView)
        let lc1 = NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: accountTextField, attribute: .bottom, multiplier: 1, constant: 0)
        let lc2 = NSLayoutConstraint(item: lineView, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let lc3 = NSLayoutConstraint(item: lineView, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let lc4 = NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1/UIScreen.main.scale)
        cornerView.addConstraints([lc1, lc2, lc3, lc4])

        passwordTextField = createTextField(placeHold: "密码：6-15位数字，字母和下划线")
        passwordTextField.isSecureTextEntry = true
//        passwordTextField.keyboardType = .asciiCapable
        cornerView.addSubview(passwordTextField)
        let pc1 = NSLayoutConstraint(item: passwordTextField, attribute: .top, relatedBy: .equal, toItem: lineView, attribute: .bottom, multiplier: 1, constant: 0)
        let pc2 = NSLayoutConstraint(item: passwordTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let pc3 = NSLayoutConstraint(item: passwordTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let pc4 = NSLayoutConstraint(item: passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        cornerView.addConstraints([pc1, pc2, pc3, pc4])
        
        let lineView2 = UIView()
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        lineView2.backgroundColor = UIColor.lightGray
        cornerView.addSubview(lineView2)
        let lc21 = NSLayoutConstraint(item: lineView2, attribute: .top, relatedBy: .equal, toItem: passwordTextField, attribute: .bottom, multiplier: 1, constant: 0)
        let lc22 = NSLayoutConstraint(item: lineView2, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let lc23 = NSLayoutConstraint(item: lineView2, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let lc24 = NSLayoutConstraint(item: lineView2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1/UIScreen.main.scale)
        cornerView.addConstraints([lc21, lc22, lc23, lc24])
        
        re_passwordTextField = createTextField(placeHold: "请再次输入您的密码")
        re_passwordTextField.isSecureTextEntry = true
//        re_passwordTextField.keyboardType = .asciiCapable
        cornerView.addSubview(re_passwordTextField)
        let rc1 = NSLayoutConstraint(item: re_passwordTextField, attribute: .top, relatedBy: .equal, toItem: lineView2, attribute: .bottom, multiplier: 1, constant: 0)
        let rc2 = NSLayoutConstraint(item: re_passwordTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let rc3 = NSLayoutConstraint(item: re_passwordTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let rc4 = NSLayoutConstraint(item: re_passwordTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        cornerView.addConstraints([rc1, rc2, rc3, rc4])
        
        if EYLoginSDKManager.shared().status == 2 {
            let lineView3 = UIView()
            lineView3.translatesAutoresizingMaskIntoConstraints = false
            lineView3.backgroundColor = UIColor.lightGray
            cornerView.addSubview(lineView3)
            let lc31 = NSLayoutConstraint(item: lineView3, attribute: .top, relatedBy: .equal, toItem: re_passwordTextField, attribute: .bottom, multiplier: 1, constant: 0)
            let lc32 = NSLayoutConstraint(item: lineView3, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
            let lc33 = NSLayoutConstraint(item: lineView3, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
            let lc34 = NSLayoutConstraint(item: lineView3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1/UIScreen.main.scale)
            cornerView.addConstraints([lc31, lc32, lc33, lc34])
            
            nameTextField = createTextField(placeHold: "真实姓名")
            cornerView.addSubview(nameTextField)
            let ntc1 = NSLayoutConstraint(item: nameTextField, attribute: .top, relatedBy: .equal, toItem: lineView3, attribute: .bottom, multiplier: 1, constant: 0)
            let ntc2 = NSLayoutConstraint(item: nameTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
            let ntc3 = NSLayoutConstraint(item: nameTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
            let ntc4 = NSLayoutConstraint(item: nameTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            cornerView.addConstraints([ntc1, ntc2, ntc3, ntc4])
            
            let lineView4 = UIView()
            lineView4.translatesAutoresizingMaskIntoConstraints = false
            lineView4.backgroundColor = UIColor.lightGray
            cornerView.addSubview(lineView4)
            let lc41 = NSLayoutConstraint(item: lineView4, attribute: .top, relatedBy: .equal, toItem: nameTextField, attribute: .bottom, multiplier: 1, constant: 0)
            let lc42 = NSLayoutConstraint(item: lineView4, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
            let lc43 = NSLayoutConstraint(item: lineView4, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
            let lc44 = NSLayoutConstraint(item: lineView4, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1/UIScreen.main.scale)
            cornerView.addConstraints([lc41, lc42, lc43, lc44])
            
            idTextField = createTextField(placeHold: "身份证号码")
            idTextField.keyboardType = .asciiCapable
            cornerView.addSubview(idTextField)
            let ic1 = NSLayoutConstraint(item: idTextField, attribute: .top, relatedBy: .equal, toItem: lineView4, attribute: .bottom, multiplier: 1, constant: 0)
            let ic2 = NSLayoutConstraint(item: idTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
            let ic3 = NSLayoutConstraint(item: idTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
            let ic4 = NSLayoutConstraint(item: idTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            cornerView.addConstraints([ic1, ic2, ic3, ic4])
        }
        
        registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(registerButton)
        registerButton.backgroundColor = buttonThemeColorDisabled
//        registerButton.isEnabled = false
        registerButton.setTitle("注册", for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        let cc1 = NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: cornerView, attribute: .bottom, multiplier: 1, constant: 15)
        let cc2 = NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let cc3 = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w-30)
        let cc4 = NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        scrollView.addConstraints([cc1, cc2, cc3, cc4])
        
        toLoginButton = UIButton()
        scrollView.addSubview(toLoginButton)
        toLoginButton.translatesAutoresizingMaskIntoConstraints = false
        toLoginButton.backgroundColor = buttonThemeColorNormol
        toLoginButton.setTitle("已有账号，去登陆", for: .normal)
        toLoginButton.layer.cornerRadius = 5
        toLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        let trc1 = NSLayoutConstraint(item: toLoginButton, attribute: .top, relatedBy: .equal, toItem: registerButton, attribute: .bottom, multiplier: 1, constant: 15)
        let trc2 = NSLayoutConstraint(item: toLoginButton, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let trc3 = NSLayoutConstraint(item: toLoginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w-30)
        let trc4 = NSLayoutConstraint(item: toLoginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        whiteView.addConstraints([trc1, trc2, trc3, trc4])
        
        tipLabel.isUserInteractionEnabled = true
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tipLabel)
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.numberOfLines = 0
        tipLabel.text = "根据《关于防止未成年人沉迷网络游戏的通知》，游戏用户应使用有效身份证件实名注册，我们承诺将依法保护您的个人信息安全"
        let tpc1 = NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: toLoginButton, attribute: .bottom, multiplier: 1, constant: 15)
        let tpc2 = NSLayoutConstraint(item: tipLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let tpc3 = NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w-30)
//        let tpc4 = NSLayoutConstraint(item: tipLabel, attribute: .bottom, relatedBy: .equal, toItem: whiteView, attribute: .bottom, multiplier: 1, constant: -15)
        whiteView.addConstraints([tpc1, tpc2, tpc3])
        
        let wc1 = NSLayoutConstraint(item: whiteView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let wc2 = NSLayoutConstraint(item: whiteView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let wc3 = NSLayoutConstraint(item: whiteView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: w)
        let wc4 = NSLayoutConstraint(item: whiteView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 450)
        self.addConstraints([wc1, wc2, wc3, wc4])
        centerYConstraint = wc2
        heightYConstraint = wc4
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tipAction))
        tipLabel.addGestureRecognizer(tap)
        accountTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        re_passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        if EYLoginSDKManager.shared().status == 2 {
            idTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
            nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        }
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        toLoginButton.addTarget(self, action: #selector(self.toLoginAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(self.registerAction), for: .touchUpInside)
    }
    
    @objc
    func tipAction() {
        self.endEditing(false)
        EYLoginSDKManager.shared().changeToNoti()
    }
    
    func createTextField(placeHold: String) -> UITextField {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 45))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.textColor = UIColor.black
        textField.attributedPlaceholder = NSAttributedString(string: placeHold, attributes: [.foregroundColor: UIColor.gray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = .none
        textField.tintColor = UIColor.black
        textField.backgroundColor = UIColor.white
        return textField
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        whiteView.layoutIfNeeded()
        if isPortrait {
            centerYConstraint?.constant = 0
            heightYConstraint?.constant = tipLabel.frame.maxY + 15
        } else {
            heightYConstraint?.constant = screenHeight
            centerYConstraint?.constant = -(screenHeight/2 - whiteView.bounds.size.height/2)
        }
        scrollView.contentSize = CGSize(width: 0, height: tipLabel.frame.maxY + 15)
    }
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        var isEnable = true
        if EYLoginSDKManager.shared().status == 2 {
            isEnable = accountTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && re_passwordTextField.text == passwordTextField.text && self.nameTextField.text?.count ?? 0 > 0 && self.idTextField.text?.count ?? 0 > 0
        } else {
            isEnable = accountTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && re_passwordTextField.text == passwordTextField.text
        }
        if isEnable {
            registerButton.isEnabled = true
            registerButton.backgroundColor = buttonThemeColorNormol
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = buttonThemeColorDisabled
        }
    }
    
    @objc
    func toLoginAction() {
        self.endEditing(false)
        EYLoginSDKManager.shared().changeToLogin()
    }
    
    @objc
    func registerAction() {
        self.endEditing(false)
        var params: [String : Any]
        let url = "\(requestHost)/register"
        if EYLoginSDKManager.shared().status == 2 {
            params = ["username": accountTextField.text ?? "", "password": passwordTextField.text ?? "", "idcard": idTextField?.text ?? "", "realname": nameTextField?.text ?? ""]
        } else {
            params = ["username": accountTextField.text ?? "", "password": passwordTextField.text ?? ""]
        }
        hud.showAnimatedHud()
        EYNetworkService.sendRequstWith(method: .post, urlString: url, params: params) { (isSuccess, data, error) in
            self.hud.stopAnimatedHud()
            if isSuccess {
                let d = data?["data"] as? [String: Any]
                let uid = d?["uid"] as? String
                let token = d?["token"] as? String
                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
                UserDefaults.standard.setValue(token, forKey: tokenIdentifier)
                if EYLoginSDKManager.shared().status == 2 {
                    let holidayArr = d?["holiday"] as? [String]
                    let isAdult = d?["adult"] as? Int == 0 ? false : true
                    EYLoginSDKManager.shared().holidayArr = holidayArr
                    UserDefaults.standard.setValue(EYLoginState.logined.rawValue, forKey: loginStateIdentifier)
                    UserDefaults.standard.setValue(holidayArr, forKey: holidayIdentifier)
                    UserDefaults.standard.set(isAdult, forKey: isAdultIdentifier)
                    UserDefaults.standard.synchronize()
                    EYLoginSDKManager.shared().loginSuccess()
                } else {
                    UserDefaults.standard.setValue(EYLoginState.registedNeedAuthentication.rawValue, forKey: loginStateIdentifier)
                    UserDefaults.standard.synchronize()
                    EYLoginSDKManager.shared().registerSuccess()
                    EYLoginSDKManager.shared().changeToAuthentication()
                }
            } else {
                ProgressHud.showTextHud(data?["message"] as? String ?? "注册失败，请稍后重试")
                debugLog(message: "register error:", error.debugDescription)
            }
        }
    }
}

class NotifyView: UIView {
//    var callBack: ((_ isAgree: Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.layer.cornerRadius = 5
        backgroundColor = UIColor.white
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "根据国家《关于防止未成年人沉迷网络游戏的通知》相关规定：\n1、网络游戏用户均须使用有效身份信息方可进行游戏账号注册。\n2、仅可在周五、周六、周日和法定节假日每日20时至21时向未成年人提供1小时网络游戏服务。\n3、不得为未满8周岁的用户提供游戏付费服务。同一网络游戏企业所提供的游戏付费服务，8周岁以上未满16周岁的用户，单次充值金额不得超过50元人民币，每月充值金额累计不得超过200元人民币；16周岁以上未满18周岁的用户，单次充值金额不得超过100元人民币，每月充值金额累计不得超过400元人民币。"
        addSubview(label)
        let sc1 = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15)
        let sc2 = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15)
        let sc3 = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15)
        self.addConstraints([sc1, sc2, sc3])
        
        let confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(buttonThemeColorNormol, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addSubview(confirmButton)
        let cc1 = NSLayoutConstraint(item: confirmButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        let cc2 = NSLayoutConstraint(item: confirmButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15)
//        let cc3 = NSLayoutConstraint(item: confirmButton, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 15)
        self.addConstraints([cc1, cc2])
        
//        let cacelButton = UIButton()
//        cacelButton.translatesAutoresizingMaskIntoConstraints = false
//        cacelButton.setTitle("取消", for: .normal)
//        cacelButton.setTitleColor(UIColor.black, for: .normal)
//        cacelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        addSubview(cacelButton)
//        let cac1 = NSLayoutConstraint(item: cacelButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
//        let cac2 = NSLayoutConstraint(item: cacelButton, attribute: .right, relatedBy: .equal, toItem: confirmButton, attribute: .left, multiplier: 1, constant: -15)
//        self.addConstraints([cac1, cac2])
        
        confirmButton.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
//        cacelButton.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
    }
    
    @objc func confirmAction() {
        self.removeFromSuperview()
//        self.callBack?(true)
    }
    
//    @objc func cancelAction() {
//        self.removeFromSuperview()
//        self.callBack?(false)
//    }
}
