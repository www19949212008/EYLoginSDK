//
//  ViewController.swift
//  EYLoginDemo
//
//  Created by eric on 2021/3/19.
//

import UIKit
import EYLoginSDK
class ViewController: UIViewController, EYRechagerDelegate, EYLoginDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        EYLoginSDKManager.shared().rootViewController = self
        EYLoginSDKManager.shared().delegate = self
        EYLoginSDKManager.shared().rechagerDelegate = self
        
        let logoutBtn = UIButton()
        logoutBtn.setTitle("logout", for: .normal)
        logoutBtn.setTitleColor(.black, for: .normal)
        view.addSubview(logoutBtn)
        logoutBtn.frame = CGRect(x: 20, y: 100, width: 50, height: 70)
        logoutBtn.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        
        let chaxuntBtn = UIButton()
        chaxuntBtn.setTitle("chaxun", for: .normal)
        chaxuntBtn.setTitleColor(.black, for: .normal)
        view.addSubview(chaxuntBtn)
        chaxuntBtn.frame = CGRect(x: 120, y: 100, width: 50, height: 70)
        chaxuntBtn.addTarget(self, action: #selector(self.chaxun), for: .touchUpInside)
        
        let uploadBtn = UIButton()
        uploadBtn.setTitle("upload", for: .normal)
        uploadBtn.setTitleColor(.black, for: .normal)
        view.addSubview(uploadBtn)
        uploadBtn.frame = CGRect(x: 20, y: 220, width: 50, height: 70)
        uploadBtn.addTarget(self, action: #selector(self.upload), for: .touchUpInside)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        EYLoginSDKManager.shared().showExitAlert(needExit: false)
    }
    
    @objc func logout() {
//        EYLoginSDKManager.shared().logOut()
    }
    
    @objc func chaxun() {
        EYLoginSDKManager.shared().queryUserRechage()
    }
    
    @objc func upload() {
        EYLoginSDKManager.shared().uploadUserRechageInfo(rechargeMoney: 10)
    }
    
    func loginManagerDidGetUserRechageInfo(rechargeInfo: [String : Any]) {
        print("查询成功：", rechargeInfo)
    }
    
    func loginManagerGetUserRechageInfoWithError(error: Error?, message: String?) {
        print("查询失败：", error.debugDescription, message)
    }
    
    func loginManagerDidUploadUserRechageInfo() {
        print("上传成功")
    }
    
    func loginManagerUploadUserRechageInfoWithError(error: Error?, message: String?) {
        print("上传失败：", error.debugDescription, message)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func loginManagerDidGetLoginState(loginState: Int) {
        
    }
    
    func loginManagerWillShowLoginPage() {
        
    }
    
    func loginManagerDidShowLoginPage() {
        
    }
    
    func loginManagerDidLogin(loginState: Int) {
        
    }
    
    func loginManagerLoginWithError(error: Error) {
        
    }
    
    func loginManagerLogoutWithError(error: Error) {
        
    }
    
    func loginManagerDidLogout(loginState: Int) {
        
    }
}

