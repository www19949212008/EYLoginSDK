//
//  EYLoginSDKManager.swift
//  Pods-EYLoginDemo
//
//  Created by eric on 2021/3/19.
//

import UIKit

@objc
open class EYLoginSDKManager: NSObject {
    private static var instance = EYLoginSDKManager()
    
    @objc
    open weak var delegate: EYLoginDelegate?
    
    @objc
    public static var autoLogin = true
    
    var isInit = false
    @objc open var loginState: Int {
        return UserDefaults.standard.integer(forKey: loginStateIdentifier)
    }
    
    var tryPresentLoginVcCount = 0
    
    private var showingVc: UIViewController?
    
    @objc
    open var rootViewController: UIViewController?
    
    @objc
    open class func shared() -> EYLoginSDKManager {
        return instance
    }
    
    private(set) var appkey = ""
    
    private(set) var uid = ""
    
    private var thread: Thread?
    private var timer: Timer?
    
    @objc
    open func initializeSDK(appkey: String) {
        self.appkey = appkey
        UserDefaults.standard.register(defaults: [loginStateIdentifier: 0])
        isInit = true
        if EYLoginSDKManager.autoLogin {
            login()
        }
    }
    
    @objc
    open func login() {
        var state = loginState
        let uid = UserDefaults.standard.string(forKey: userIdentifier)
        if uid?.count == 0 && state == EYLoginState.logined.rawValue {
            UserDefaults.standard.setValue(EYLoginState.notLogin.rawValue, forKey: loginStateIdentifier)
            state = EYLoginState.notLogin.rawValue
        }
        delegate?.loginManagerDidGetLoginState(loginState: state)
        switch state {
        case EYLoginState.notLogin.rawValue:
            showLoginPage()
        case EYLoginState.logined.rawValue:
            self.uid = uid ?? ""
            delegate?.loginManagerDidLogin(loginState: loginState)
        case EYLoginState.registed.rawValue:
            showLoginPage()
        case EYLoginState.registedNeedAuthentication.rawValue:
            showLoginPage()
        default:
            break
        }
    }
    
    func showLoginPage() {
        delegate?.loginManagerWillShowLoginPage()
        if let vc =  rootViewController ?? UIApplication.shared.keyWindow?.rootViewController, vc.presentedViewController == nil {
            rootViewController = vc
            var loginVc: UIViewController
            if loginState == EYLoginState.registedNeedAuthentication.rawValue {
                loginVc = EYAuthenticationViewController()
            } else {
                loginVc = EYLoginViewController()
            }
            loginVc.modalPresentationStyle = .fullScreen
            showingVc = loginVc
            vc.present(loginVc, animated: true) {
                self.delegate?.loginManagerDidShowLoginPage()
            }
        } else {
            if tryPresentLoginVcCount < 5 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.tryPresentLoginVcCount += 1
                    self.showLoginPage()
                }
            } else {
                debugLog(message: "no root vc")
            }
        }
    }
    
    func loginSuccess() {
        showingVc?.dismiss(animated: true, completion: nil)
        showingVc = nil
        UserDefaults.standard.setValue(1, forKey: loginStateIdentifier)
        UserDefaults.standard.synchronize()
        delegate?.loginManagerDidLogin(loginState: loginState)
        self.uid = UserDefaults.standard.string(forKey: userIdentifier) ?? ""
        startHeartbeat()
    }
    
    func changeToRigister() {
        showingVc?.dismiss(animated: false, completion: nil)
        showingVc = EYRegisterViewController()
        showingVc?.modalPresentationStyle = .fullScreen
        rootViewController?.present(showingVc!, animated: false, completion: nil)
    }
    
    func changeToLogin() {
        showingVc?.dismiss(animated: false, completion: nil)
        showingVc = EYLoginViewController()
        showingVc?.modalPresentationStyle = .fullScreen
        rootViewController?.present(showingVc!, animated: false, completion: nil)
    }
    
    func changeToAuthentication() {
        showingVc?.dismiss(animated: false, completion: nil)
        showingVc = EYAuthenticationViewController()
        showingVc?.modalPresentationStyle = .fullScreen
        rootViewController?.present(showingVc!, animated: false, completion: nil)
    }
    
    func startHeartbeat() {
        thread = Thread(target: self, selector: #selector(self.heartBeatThreadAction), object: nil)
        thread?.start()
    }
    
    @objc
    func heartBeatThreadAction() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer(timeInterval: 10, repeats: true) { (_) in
            let params = ["uid": self.uid, "appkey": EYLoginSDKManager.shared().appkey] as [String : Any]
            EYNetworkService.sendRequstWith(method: .post, urlString: "\(host)/user/heartbeat", params: params) { (_, _, _) in }
        }
        RunLoop.current.add(timer!, forMode: .default)
        timer?.fire()
    }
    
    @objc
    open func logOut() {
        let params = ["uid": UserDefaults.standard.integer(forKey: userIdentifier), "appkey": EYLoginSDKManager.shared().appkey] as [String : Any]
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(host)/user/offline", params: params) { (isSuccess, data, error) in
            if isSuccess {
                self.unregistUserInfo()
                self.invalidBackgroundThread()
                self.delegate?.loginManagerDidLogout(loginState: self.loginState)
            } else {
                debugLog(message: error.debugDescription)
                self.delegate?.loginManagerLogoutWithError(error: error ?? NSError())
            }
        }
    }
    
    func unregistUserInfo() {
        self.uid = ""
        UserDefaults.standard.setValue(0, forKey: loginStateIdentifier)
        UserDefaults.standard.setValue(nil, forKey: userIdentifier)
        UserDefaults.standard.synchronize()
    }
    
    func invalidBackgroundThread() {
        if let t = thread {
            self.perform(#selector(self.exitThread), on: t, with: nil, waitUntilDone: true)
            thread = nil
        }
        timer?.invalidate()
        timer = nil
    }
    
    @objc func exitThread() {
        Thread.exit()
    }
}
