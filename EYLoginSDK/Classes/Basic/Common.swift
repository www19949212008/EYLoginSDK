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

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let buttonThemeColorNormol = UIColor(red: 0/255.0, green: 62/255.0, blue: 187/255.0, alpha: 1)
let buttonThemeColorDisabled = UIColor.lightGray
