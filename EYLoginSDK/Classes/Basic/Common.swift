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
let buttonThemeColorNormol = UIColor(red: 255/255.0, green: 91/255.0, blue: 36/255.0, alpha: 1)
let buttonThemeColorDisabled = UIColor(red: 255/255.0, green: 140/255.0, blue: 89/255.0, alpha: 1)
