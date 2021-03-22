//
//  EYLoginDelegate.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/19.
//

@objc
public protocol EYLoginDelegate: AnyObject {
    func loginMangaerStartCheckLoginState()
    func loginManagerDidFinishCheckLoginState(loginState: Int)
    func loginManagerDidFinishCheckLoginStateWithError(error: Error)
    func loginManagerWillShowLoginPage()
    func loginManagerDidShowLoginPage()
    func loginManagerDidLogin(loginState: Int)
    func loginManagerLoginWithError(error: Error)
}
