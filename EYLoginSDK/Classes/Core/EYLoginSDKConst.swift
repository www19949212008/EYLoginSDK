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

let host = "http://192.168.184.97:8080"

let loginStateIdentifier = "EYLoginSDK_loginstate"
let userIdentifier = "EYLoginSDK_userid"
