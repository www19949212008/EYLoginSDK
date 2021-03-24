//
//  EYLoginSDKConst.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/24.
//

enum EYLoginState: Int {
    case notLogin = 0
    case logined = 1
    case registedNeedAuthentication = 2
    case registed = 3
}

let loginStateIdentifier = "EYLoginSDK_loginstate"
let userIdentifier = "EYLoginSDK_userid"
