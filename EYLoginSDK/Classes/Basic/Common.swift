//
//  Common.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/24.
//

//Debug模式下打印
func debugLog<T>(message: T..., fileName: String = #file, funcName: String = #function, lineNum : Int = #line) {
    #if DEBUG
        let file = (fileName as NSString).lastPathComponent
        print("EYLoginSDK: [\(file)]]-->[\(funcName)]-->第\(lineNum)行\("\n")", message)
    #endif
}

var screenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
var screenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}
var isPortrait: Bool {
    return screenWidth < screenHeight
}
let buttonThemeColorNormol = UIColor(red: 0/255.0, green: 62/255.0, blue: 187/255.0, alpha: 1)
let buttonThemeColorDisabled = UIColor.lightGray
let deviceId = UIDevice.current.identifierForVendor?.uuidString
