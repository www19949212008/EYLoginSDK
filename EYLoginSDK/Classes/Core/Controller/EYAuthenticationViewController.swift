//
//  EYAuthenticationViewController.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/22.
//

import UIKit

class EYAuthenticationViewController: EYLoginBaseViewController {

    private var nameTextField: UITextField!
    private var idTextField: UITextField!
    private var commitButton: UIButton!
    private let hud = ProgressHud()
    
    override var titleString: String {
        return "实名认证"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField = self.createTextField(placeHold: "请输入您的姓名")
        nameTextField.frame = CGRect(x: 15, y: UIApplication.shared.statusBarFrame.height + 200, width: screenWidth-30, height: 45)
        view.addSubview(nameTextField)
        
        idTextField = self.createTextField(placeHold: "请输入您的身份证号码")
        idTextField.frame = CGRect(x: 15, y: nameTextField.frame.maxY + 10, width: screenWidth-30, height: 45)
        view.addSubview(idTextField)
        
        commitButton = self.createOrangeButton(title: "提交")
        commitButton.backgroundColor = buttonThemeColorDisabled
        commitButton.isEnabled = false
        view.addSubview(commitButton)
        commitButton.frame = CGRect(x: 15, y: idTextField.frame.maxY + 20, width: screenWidth-30, height: 50)
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        commitButton.addTarget(self, action: #selector(self.commitAction), for: .touchUpInside)
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
        let params = ["appkey": EYLoginSDKManager.shared().appkey, "idcard": idTextField.text ?? "", "realname": nameTextField.text ?? "", "deviceid": NSUUID().uuidString] as [String : Any]
        hud.showAnimatedHud()
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(requestHost)/auth", params: params) { (isSuccess, data, error) in
            self.hud.stopAnimatedHud()
            if isSuccess {
                let d = data?["data"] as? [String: Any]
                let isAdult = d?["adult"] as? Int == 0 ? false : true
                let holidayArr = d?["holiday"] as? [String]
                let uid = d?["uid"] as? String
                EYLoginSDKManager.shared().holidayArr = holidayArr
                UserDefaults.standard.setValue(uid, forKey: userIdentifier)
                UserDefaults.standard.setValue(holidayArr, forKey: holidayIdentifier)
                UserDefaults.standard.set(isAdult, forKey: isAdultIdentifier)
                UserDefaults.standard.synchronize()
                EYLoginSDKManager.shared().loginSuccess()
            } else {
                if data?["code"] as? Int == 1010 {
                    EYLoginSDKManager.shared().showExitAlert(message: data?["message"] as? String ?? "实名认证成功，该时间段暂时无法登陆")
                    EYLoginSDKManager.shared().delegate?.loginManagerLoginWithError(error: NSError(domain: "AuthErrorDomain", code: 1010, userInfo: nil))
                } else {
                    EYLoginSDKManager.shared().delegate?.loginManagerLoginWithError(error: error ?? NSError(domain: "LoginErrorDomain", code: data?["code"] as? Int ?? -1, userInfo: nil))
                    ProgressHud.showTextHud(data?["message"] as? String ?? "身份信息验证失败，请稍后重试")
                }
                debugLog(message: error.debugDescription)
            }
        }
    }
}
