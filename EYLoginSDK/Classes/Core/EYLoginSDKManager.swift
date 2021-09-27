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
    
    //1--有版号正式版   2--申请版号  3--无游戏版号
    var status = 3
    
    @objc open var loginState: Int {
        return UserDefaults.standard.integer(forKey: loginStateIdentifier)
    }
    
//    var tryPresentLoginVcCount = 0
    open var needShowAuthView = false
    
    var showingVc: UIViewController?
    private var showingView: FullScreenBaseView?
    
    @objc
    open var rootViewController: UIViewController? {
        didSet {
            if needShowAuthView {
                self.showLoginPage()
            }
        }
    }
    
    @objc
    open class func shared() -> EYLoginSDKManager {
        return instance
    }
    
    open private(set) var appkey = ""
    open private(set) var secretkey = ""
    
    @objc
    open private(set) var uid = ""
    
    private var thread: Thread?
    private var timer: Timer?
    
    @objc
    open private(set) var isAdult: Bool = true
    
    var holidayArr: [String]?
    
//    private lazy var authView = EYAuthenticationView()
    
    lazy var token = ""
    
    @objc
    open func initializeSDK(appkey: String, secretkey: String, status: Int = 3) {
        self.appkey = appkey
        self.secretkey = secretkey
        self.status = status
        UserDefaults.standard.register(defaults: [loginStateIdentifier: 0])
        isInit = true
//        EYLoginSDKManager.isTestMode = isTestMode
//        if isTestMode {
//            requestHost = "\(testHost)/formalUser"
//            self.unregistUserInfo()
//        }
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
        if isInit == false {
            return
        }
        var state = loginState
        let uid = UserDefaults.standard.string(forKey: userIdentifier)
        if uid?.count ?? 0 == 0 {
            UserDefaults.standard.setValue(EYLoginState.notLogin.rawValue, forKey: loginStateIdentifier)
            state = EYLoginState.notLogin.rawValue
        }
        let token = UserDefaults.standard.string(forKey: tokenIdentifier)
        if token?.count ?? 0 == 0 {
            UserDefaults.standard.setValue(EYLoginState.notLogin.rawValue, forKey: loginStateIdentifier)
            state = EYLoginState.notLogin.rawValue
        }
        delegate?.loginManagerDidGetLoginState(loginState: state)
        switch state {
        case EYLoginState.notLogin.rawValue:
            showLoginPage()
        case EYLoginState.logined.rawValue:
            self.uid = uid ?? ""
            self.token = token ?? ""
            self.isAdult = UserDefaults.standard.bool(forKey: isAdultIdentifier)
            startHeartbeat()
            delegate?.loginManagerDidLogin(loginState: loginState)
        case EYLoginState.registedNeedAuthentication.rawValue:
            self.uid = uid ?? ""
            self.token = token ?? ""
            showLoginPage()
        default:
            break
        }
    }
    
    open func showLoginPage() {
        if UIApplication.shared.keyWindow != nil || UIApplication.shared.windows.count != 0 {
            if loginState == EYLoginState.registedNeedAuthentication.rawValue {
                showingView = EYAuthenticationView()
                showingView?.show()
            } else {
                if status == 3 {
                    needShowAuthView = false
                    showingView = EYAuthenticationView()
                    showingView?.layoutIfNeeded()
                    showingView?.show()
                    let v = NotifyView()
                    v.frame = showingView!.whiteView.bounds
                    showingView!.whiteView.addSubview(v)
                    self.delegate?.loginManagerDidShowLoginPage()
                } else {
                    showingView = EYLoginView()
                    showingView?.layoutIfNeeded()
                    showingView?.show()
                    let v = NotifyView()
                    v.frame = showingView!.whiteView.bounds
                    showingView!.whiteView.addSubview(v)
                }
            }
        } else {
            needShowAuthView = true
        }
    }
    
    func loginSuccess(message: String? = nil) {
        showingView?.dismiss()
        showingView = nil
        self.token = UserDefaults.standard.string(forKey: tokenIdentifier) ?? ""
        self.uid = UserDefaults.standard.string(forKey: userIdentifier) ?? ""
        self.isAdult = UserDefaults.standard.bool(forKey: isAdultIdentifier)
        delegate?.loginManagerDidLogin(loginState: loginState)
        if message != nil {
            showExitAlert(message: message, needExit: true)
        } else {
            startHeartbeat()
        }
    }
    
    func registerSuccess() {
        self.token = UserDefaults.standard.string(forKey: tokenIdentifier) ?? ""
        self.uid = UserDefaults.standard.string(forKey: userIdentifier) ?? ""
    }
    
    func changeToRigister() {
        showingView?.dismiss()
        showingView = EYRegisterView()
        showingView?.show()
    }
    
    func changeToLogin() {
        showingView?.dismiss()
        showingView = EYLoginView()
        showingView?.show()
    }
    
    func changeToNoti() {
        showingVc = UINavigationController(rootViewController: EYNotificationController())
//        showingVc?.modalPresentationStyle = .fullScreen
        self.rootViewController?.present(showingVc!, animated: true, completion: nil)
    }
    
    func changeToAuthentication() {
        showingView?.dismiss()
        showingView = EYAuthenticationView()
        showingView?.show()
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
        timer = Timer(timeInterval: 60, repeats: true) { (_) in
            var url = ""
            let params: [String : Any]
            params = ["uid": self.uid, "v": "1.0", "second": "60", "token": self.token] as [String : Any]
            url = "\(requestHost)/heart"
            
            EYNetworkService.sendRequstWith(method: .post, urlString: url, params: params) { (isSuccess, data, error) in
                if isSuccess {
                    let code = data?["code"] as? Int
                    let message = data?["message"] as? String
                    let d = data?["data"] as? [String: Any]
                    let holidayArr = d?["holiday"] as? [String]
                    if let isAdult = d?["adult"] as? Int {
                        self.isAdult = isAdult == 0 ? false : true
                        UserDefaults.standard.set(isAdult, forKey: isAdultIdentifier)
                    }
                    self.holidayArr = holidayArr
                    switch code {
                    case 1010:
                        self.invalidBackgroundThread()
                        self.showExitAlert(message: message)
                    default:
                        break
                    }
                } else if (data == nil) {
                    if !self.checkIsValidOnline() {
                        self.showExitAlert()
                    }
                }
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
        timer?.fire()
        RunLoop.current.run()
    }
    
    @objc
    open func checkIsValidOnline() -> Bool {
        if self.isAdult {
            return true
        }
        if holidayArr == nil {
            holidayArr = UserDefaults.standard.object(forKey: holidayIdentifier) as? [String]
        }
        if holidayArr?.count ?? 0 == 0 {
            return true
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let d = Date()
        let lastH = formatter.date(from: holidayArr!.last!) ?? Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: d)
        if d.timeIntervalSince1970 > lastH.timeIntervalSince1970 {
            let weekDay = calendar.component(.weekday, from: d)
            if weekDay == 1 || weekDay == 6 || weekDay == 7 {
                if hour < 20 || hour > 21 {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        } else {
            let date = formatter.string(from: d)
            if holidayArr?.contains(date) ?? true {
                if hour < 20 || hour > 21 {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
    }
    
    func showExitAlert(message: String? = nil, needExit: Bool = true) {
        let vc = UIAlertController(title: nil, message: message ?? "根据国家防沉迷通知的相关要求，由于您是未成年人，仅能在周五、周六、周日及法定节假日20时至21时进入游戏", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            if needExit {
                exit(0)
            }
        }
        vc.addAction(action)
        rootViewController?.present(vc, animated: true, completion: nil)
    }
    
//    @objc
//    open func logOut() {
//        if loginState != 1 {
//            return
//        }
//        let params = ["uid": UserDefaults.standard.integer(forKey: userIdentifier), "appkey": EYLoginSDKManager.shared().appkey] as [String : Any]
//        EYNetworkService.sendRequstWith(method: .post, urlString: "\(requestHost)/offline", params: params) { (isSuccess, data, error) in
//            if isSuccess {
//                EYLoginSDKManager.isAnonymous = false
//                self.unregistUserInfo()
//                self.invalidBackgroundThread()
//                self.delegate?.loginManagerDidLogout(loginState: self.loginState)
//            } else {
//                debugLog(message: error.debugDescription)
//                self.delegate?.loginManagerLogoutWithError(error: error ?? NSError())
//            }
//        }
//    }
    
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
        CFRunLoopStop(RunLoop.current.getCFRunLoop())
        Thread.exit()
    }
    
    @objc
    open func queryUserRechage() {
        let params = ["uid": self.uid, "token": self.token] as [String : Any]
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(requestHost)/getMonthRecharge", params: params) { (isSuccess, data, error) in
            if isSuccess {
                let mapData = data?["data"] as? [String: Any]
                let single_recharge = mapData?["singleRechargeLimit"] as? Int ?? -1
                let month_recharge = mapData?["monthRechargeLimit"] as? Int ?? -1
                let month_recharge_total = mapData?["monthRecharged"] as? Int ?? -1
                let info = ["singleRecharge": single_recharge, "monthRecharge": month_recharge, "monthRechargeTotal": month_recharge_total] as [String: Any]
                self.rechagerDelegate?.loginManagerDidGetUserRechageInfo(rechargeInfo: info)
            } else {
                self.rechagerDelegate?.loginManagerGetUserRechageInfoWithError(error: error, message: data?["message"] as? String)
            }
        }
    }
    
    @objc
    open func uploadUserRechageInfo(rechargeMoney: Int) {
        let params = ["uid": self.uid, "token": self.token, "recharge_money": rechargeMoney] as [String : Any]
        EYNetworkService.sendRequstWith(method: .post, urlString: "\(requestHost)/recharge", params: params) { (isSuccess, data, error) in
            if isSuccess {
                let mapData = data?["data"] as? [String: Any]
                let single_recharge = mapData?["singleRechargeLimit"] as? Int ?? -1
                let month_recharge = mapData?["monthRechargeLimit"] as? Int ?? -1
                let month_recharge_total = mapData?["monthRecharged"] as? Int ?? -1
                let info = ["singleRecharge": single_recharge, "monthRecharge": month_recharge, "monthRechargeTotal": month_recharge_total] as [String: Any]
                self.rechagerDelegate?.loginManagerDidUploadUserRechageInfo(rechargeInfo: info)
            } else {
                self.rechagerDelegate?.loginManagerUploadUserRechageInfoWithError(error: error, message: data?["message"] as? String)
            }
        }
    }
}
