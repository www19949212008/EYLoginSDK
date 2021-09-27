//
//  EYAuthenticationView.swift
//  EYLoginSDK
//
//  Created by eric on 2021/9/22.
//

import UIKit

class FullScreenBaseView: UIView, UIGestureRecognizerDelegate {
    let whiteView = UIView()
    
    var enableTap: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        setupWhiteView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubview(whiteView)
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = UIColor(red: 0/255.0, green: 140/255.0, blue: 236/255.0, alpha: 1)
//        whiteView.backgroundColor = UIColor.white
        whiteView.layer.cornerRadius = 12
        
        if enableTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            tap.delegate = self
            self.addGestureRecognizer(tap)
        }
    }
    
    @objc func tapAction() {
        self.endEditing(true)
    }
    
    func setupWhiteView() {}
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view?.isDescendant(of: whiteView) ?? false)
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (_) in
            self.clear()
            self.removeFromSuperview()
        }
    }
    
    func clear() {}
    
    func show() {
        if self.superview != nil {
            return
        }
        var window = UIApplication.shared.keyWindow
        if window == nil {
            window = UIApplication.shared.windows.last
        }
        window?.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    override func layoutSubviews() {
        if self.superview != nil && EYLoginSDKManager.shared().showingVc == nil {
            UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        }
    }
}

class EYAuthenticationView: FullScreenBaseView {
    private var nameTextField: UITextField!
    private var idTextField: UITextField!
    private var commitButton: UIButton!
    private let hud = ProgressHud()

    override func setupWhiteView() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.numberOfLines = 2
        titleLabel.text = "根据国家规定，玩家需实名认证，否则后续无法正常游戏"
        whiteView.addSubview(titleLabel)
        let tc1 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: whiteView, attribute: .top, multiplier: 1, constant: 15)
        let tc2 = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let tc3 = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        whiteView.addConstraints([tc1, tc2, tc3])
        
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

        nameTextField = createTextField(placeHold: "真实姓名")
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

        idTextField = createTextField(placeHold: "身份证号码")
        idTextField.textColor = UIColor.black
        idTextField.keyboardType = .asciiCapable
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        cornerView.addSubview(idTextField)
        let pc1 = NSLayoutConstraint(item: idTextField, attribute: .top, relatedBy: .equal, toItem: lineView, attribute: .bottom, multiplier: 1, constant: 0)
        let pc2 = NSLayoutConstraint(item: idTextField, attribute: .left, relatedBy: .equal, toItem: cornerView, attribute: .left, multiplier: 1, constant: 0)
        let pc3 = NSLayoutConstraint(item: idTextField, attribute: .right, relatedBy: .equal, toItem: cornerView, attribute: .right, multiplier: 1, constant: 0)
        let pc4 = NSLayoutConstraint(item: idTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        cornerView.addConstraints([pc1, pc2, pc3, pc4])

        commitButton = UIButton()
        commitButton.translatesAutoresizingMaskIntoConstraints = false
        whiteView.addSubview(commitButton)
        commitButton.backgroundColor = buttonThemeColorDisabled
        commitButton.isEnabled = false
        commitButton.setTitle("提交认证", for: .normal)
        commitButton.layer.cornerRadius = 5
        commitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        let cc1 = NSLayoutConstraint(item: commitButton, attribute: .top, relatedBy: .equal, toItem: cornerView, attribute: .bottom, multiplier: 1, constant: 15)
        let cc2 = NSLayoutConstraint(item: commitButton, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let cc3 = NSLayoutConstraint(item: commitButton, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        let cc4 = NSLayoutConstraint(item: commitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        whiteView.addConstraints([cc1, cc2, cc3, cc4])

        let tipLabel = UILabel()
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteView.addSubview(tipLabel)
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.numberOfLines = 0
        tipLabel.text = "根据《关于防止未成年人沉迷网络游戏的通知》，游戏用户应使用有效身份证件实名注册，我们承诺将依法保护您的个人信息安全"
        let tpc1 = NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: commitButton, attribute: .bottom, multiplier: 1, constant: 15)
        let tpc2 = NSLayoutConstraint(item: tipLabel, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let tpc3 = NSLayoutConstraint(item: tipLabel, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        let tpc4 = NSLayoutConstraint(item: tipLabel, attribute: .bottom, relatedBy: .equal, toItem: whiteView, attribute: .bottom, multiplier: 1, constant: -15)
        whiteView.addConstraints([tpc1, tpc2, tpc3, tpc4])
        
        let wc1 = NSLayoutConstraint(item: whiteView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let wc2 = NSLayoutConstraint(item: whiteView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let wc3 = NSLayoutConstraint(item: whiteView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: min(screenWidth-30, screenHeight-30))
        self.addConstraints([wc1, wc2, wc3])

        tipLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tipAction))
        tipLabel.addGestureRecognizer(tap)
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        commitButton.addTarget(self, action: #selector(self.commitAction), for: .touchUpInside)
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
    
    override func clear() {
        nameTextField.text = nil
        idTextField.text = nil
    }
    
    @objc
    func tipAction() {
        self.endEditing(false)
        EYLoginSDKManager.shared().changeToNoti()
    }
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        if nameTextField.text?.count ?? 0 > 0 && idTextField.text?.count ?? 0 > 0 {
            commitButton.isEnabled = true
            commitButton.backgroundColor = buttonThemeColorNormol
        } else {
            commitButton.isEnabled = false
            commitButton.backgroundColor = buttonThemeColorDisabled
        }
    }
    
    @objc func commitAction() {
        self.endEditing(false)
        if EYLoginSDKManager.shared().status == 3 {
            authLoginAction()
        } else {
            authAction()
        }
    }
    
    func authLoginAction() {
        let params = ["idcard": idTextField.text ?? "", "realname": nameTextField.text ?? ""] as [String : Any]
        hud.showAnimatedHud()
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(requestHost)/register", params: params) { (isSuccess, data, error) in
            self.hud.stopAnimatedHud()
            if isSuccess || data?["code"] as? Int == 1010  {
                let d = data?["data"] as? [String: Any]
                let isAdult = d?["adult"] as? Int == 0 ? false : true
                let holidayArr = d?["holiday"] as? [String]
                let uid = d?["uid"] as? String
                let token = d?["token"] as? String
                EYLoginSDKManager.shared().holidayArr = holidayArr
                UserDefaults.standard.setValue(EYLoginState.logined.rawValue, forKey: loginStateIdentifier)
                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
                UserDefaults.standard.setValue(token, forKey: tokenIdentifier)
                UserDefaults.standard.setValue(holidayArr, forKey: holidayIdentifier)
                UserDefaults.standard.set(isAdult, forKey: isAdultIdentifier)
                UserDefaults.standard.synchronize()
                if data?["code"] as? Int == 1010 {
                    EYLoginSDKManager.shared().loginSuccess(message: data?["message"] as? String ?? "根据国家防沉迷通知的相关要求，由于您是未成年人，仅能在周五、周六、周日及法定节假日20时至21时进入游戏")
                } else {
                    EYLoginSDKManager.shared().loginSuccess()
                }
            } else {
                EYLoginSDKManager.shared().delegate?.loginManagerLoginWithError(error: error ?? NSError(domain: "LoginErrorDomain", code: data?["code"] as? Int ?? -1, userInfo: nil))
                ProgressHud.showTextHud(data?["message"] as? String ?? "身份信息验证失败，请稍后重试")
                debugLog(message: error.debugDescription)
            }
        }
    }
    
    func authAction() {
        let params = ["idcard": idTextField.text ?? "", "realname": nameTextField.text ?? "", "uid": EYLoginSDKManager.shared().uid, "token": EYLoginSDKManager.shared().token] as [String : Any]
        hud.showAnimatedHud()
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(requestHost)/auth", params: params) { (isSuccess, data, error) in
            self.hud.stopAnimatedHud()
            if isSuccess || data?["code"] as? Int == 1010  {
                let d = data?["data"] as? [String: Any]
                let isAdult = d?["adult"] as? Int == 0 ? false : true
                let holidayArr = d?["holiday"] as? [String]
                EYLoginSDKManager.shared().holidayArr = holidayArr
                UserDefaults.standard.setValue(EYLoginState.logined.rawValue, forKey: loginStateIdentifier)
                UserDefaults.standard.setValue(holidayArr, forKey: holidayIdentifier)
                UserDefaults.standard.set(isAdult, forKey: isAdultIdentifier)
                UserDefaults.standard.synchronize()
                if data?["code"] as? Int == 1010 {
                    EYLoginSDKManager.shared().loginSuccess(message: data?["message"] as? String ?? "根据国家防沉迷通知的相关要求，由于您是未成年人，仅能在周五、周六、周日及法定节假日20时至21时进入游戏")
                } else {
                    EYLoginSDKManager.shared().loginSuccess()
                }
            } else {
                EYLoginSDKManager.shared().delegate?.loginManagerLoginWithError(error: error ?? NSError(domain: "LoginErrorDomain", code: data?["code"] as? Int ?? -1, userInfo: nil))
                ProgressHud.showTextHud(data?["message"] as? String ?? "身份信息验证失败，请稍后重试")
                debugLog(message: error.debugDescription)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown  {
//            self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        } else {
            self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        }
    }
}
