//
//  EYLoginDelegate.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/19.
//

@objc
public protocol EYLoginDelegate: AnyObject {
    func loginManagerDidGetLoginState(loginState: Int)
    func loginManagerWillShowLoginPage()
    func loginManagerDidShowLoginPage()
    func loginManagerDidLogin(loginState: Int)
    func loginManagerLoginWithError(error: Error)
    func loginManagerLogoutWithError(error: Error)
    func loginManagerDidLogout(loginState: Int)
}
