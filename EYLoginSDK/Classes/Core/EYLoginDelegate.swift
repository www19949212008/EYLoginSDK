//
//  EYLoginDelegate.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/19.
//

@objc
public protocol EYLoginDelegate: AnyObject {
    func loginManagerDidGetLoginState(loginState: Int)
//    func loginManagerWillShowLoginPage()
    func loginManagerDidShowLoginPage()
    func loginManagerDidLogin(loginState: Int)
    func loginManagerLoginWithError(error: Error)
//    func loginManagerLogoutWithError(error: Error)
//    func loginManagerDidLogout(loginState: Int)
}

@objc
public protocol EYRechagerDelegate: AnyObject {
    func loginManagerDidGetUserRechageInfo(rechargeInfo: [String: Any])
    func loginManagerGetUserRechageInfoWithError(error: Error?, message: String?)
    func loginManagerDidUploadUserRechageInfo(rechargeInfo: [String: Any])
    func loginManagerUploadUserRechageInfoWithError(error: Error?, message: String?)
}
