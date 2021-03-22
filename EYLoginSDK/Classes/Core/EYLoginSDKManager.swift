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
    
    open weak var delegate: EYLoginDelegate?
    
    public static var autoLogin = true
    
    var isInit = false
    open var loginState = 0
    
    var tryPresentLoginVcCount = 0
    
    private var showingVc: UIViewController?
    open var rootViewController: UIViewController?
    
    open class func shared() -> EYLoginSDKManager {
        return instance
    }
    
    open func initializeSDK() {
        isInit = true
        if EYLoginSDKManager.autoLogin {
            login()
        }
    }
    
    open func login() {
        delegate?.loginMangaerStartCheckLoginState()
        //checking
        
        delegate?.loginManagerDidFinishCheckLoginState(loginState: loginState)
        if loginState == 0 {
            delegate?.loginManagerWillShowLoginPage()
            showLoginPage()
        } else {
            
        }
    }
    
    func showLoginPage() {
        if let vc =  rootViewController ?? UIApplication.shared.keyWindow?.rootViewController, vc.presentedViewController == nil {
            rootViewController = vc
            let loginVc = EYLoginViewController()
            loginVc.modalPresentationStyle = .fullScreen
            showingVc = loginVc
            vc.present(loginVc, animated: true) {
                self.delegate?.loginManagerDidShowLoginPage()
            }
        } else {
            if tryPresentLoginVcCount < 10 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.tryPresentLoginVcCount += 1
                    self.showLoginPage()
                }
            }
        }
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
}
