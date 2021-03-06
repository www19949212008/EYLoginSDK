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
    open weak var rechagerDelegate: EYRechagerDelegate?
    
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
//        addObserver()
        if EYLoginSDKManager.autoLogin {
            login()
        }
    }
    
//    func addObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//    }
    
//    @objc func didEnterBackground() {
//        if self.loginState != 1 {
//            return
//        }
//
//    }
//
//    @objc func willEnterForeground() {
//        if self.loginState != 1 {
//            return
//        }
//
//    }
    
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
            startHeartbeat()
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
            EYNetworkService.sendRequstWith(method: .post, urlString: "\(host)/user/heartbeat", params: params) { (isSuccess, data, error) in
                let code = data?["code"] as? Int
                switch code {
                case 1002,1003,1006:
                    self.invalidBackgroundThread()
                    self.showLoginAlert()
                case 1004,1007:
                    self.invalidBackgroundThread()
                    self.showAuthAlert()
                case 1005:
                    self.invalidBackgroundThread()
                    self.showExitAlert()
                default:
                    break
                }
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
        RunLoop.current.run()
        timer?.fire()
    }
    
    func showExitAlert() {
        let vc = UIAlertController(title: nil, message: "??????????????????????????????????????????????????????", preferredStyle: .alert)
        let action = UIAlertAction(title: "??????", style: .default) { (_) in
            abort()
        }
        vc.addAction(action)
        rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func showAuthAlert() {
        let vc = UIAlertController(title: nil, message: "??????????????????????????????????????????????????????", preferredStyle: .alert)
        let action = UIAlertAction(title: "??????", style: .default) { (_) in
            self.changeToAuthentication()
        }
        vc.addAction(action)
        rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func showLoginAlert() {
        let vc = UIAlertController(title: nil, message: "??????????????????????????????????????????", preferredStyle: .alert)
        let action = UIAlertAction(title: "??????", style: .default) { (_) in
            self.changeToLogin()
        }
        vc.addAction(action)
        rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    @objc
    open func logOut() {
        if loginState != 1 {
            return
        }
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
    
    @objc
    func stopTimer() {
        CFRunLoopStop(RunLoop.current.getCFRunLoop())
    }

    @objc
    func reStartTimer() {
//        RunLoop.current.run()
    }
    
    @objc func exitThread() {
//        CFRunLoopStop(RunLoop.current.getCFRunLoop())
//        Thread.exit()
    }
    
    @objc
    open func queryUserRechage() {
        let params = ["uid": UserDefaults.standard.integer(forKey: userIdentifier), "appkey": EYLoginSDKManager.shared().appkey] as [String : Any]
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(host)/user/get_user_rechager", params: params) { (isSuccess, data, error) in
            if isSuccess {
                let mapData = data?["data"] as? [String: Any]
                let single_recharge = mapData?["single_recharge"] as? Int ?? -1
                let month_recharge = mapData?["month_recharge"] as? Int ?? -1
                let month_recharge_total = mapData?["month_recharge_total"] as? Int ?? -1
                let info = ["singleRecharge": single_recharge, "monthRecharge": month_recharge, "monthRechargeTotal": month_recharge_total] as [String: Any]
                self.rechagerDelegate?.loginManagerDidGetUserRechageInfo(rechargeInfo: info)
            } else {
                self.rechagerDelegate?.loginManagerGetUserRechageInfoWithError(error: error, message: data?["message"] as? String)
            }
        }
    }
    
    @objc
    open func uploadUserRechageInfo(rechargeMoney: Int) {
        let params = ["uid": UserDefaults.standard.integer(forKey: userIdentifier), "appkey": EYLoginSDKManager.shared().appkey, "recharge_money": rechargeMoney] as [String : Any]
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(host)/user/rechager", params: params) { (isSuccess, data, error) in
            if isSuccess {
                self.rechagerDelegate?.loginManagerDidUploadUserRechageInfo()
            } else {
                self.rechagerDelegate?.loginManagerUploadUserRechageInfoWithError(error: error, message: data?["message"] as? String)
            }
        }
    }
}
