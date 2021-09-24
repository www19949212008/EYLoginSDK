//
//  EYLoginSDKConst.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/24.
//

enum EYLoginState: Int {
    case notLogin = 0
    case logined = 1
//    case registedNeedAuthentication = 2
    case registed = 3
//    case anonymousLogined = 4
}

let host = "http://data-center-qy.eyugame.com:8980"
let testHost = "http://data-center-qy.eyugame.com:8980"
var requestHost = "\(host)"

let loginStateIdentifier = "EYLoginSDK_loginstate"
let userIdentifier = "EYLoginSDK_userid"
let isAdultIdentifier = "EYLoginSDK_isadult"
let holidayIdentifier = "EYLoginSDK_holiday"
