//
//  EYNetworkService.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/24.
//

import UIKit
import CommonCrypto

enum EYNetworkRequstMethod {
    case post
    case get
}

class EYNetworkService {
    class func sendRequstWith(method: EYNetworkRequstMethod, urlString: String, params:[String: Any]?, completeHandler: @escaping (_: Bool, _ data: [String: Any]?, _ error: Error?)->Void) {
        var urlS = urlString
        let instance = EYNetworkService()
        guard let url = URL(string: urlS) else {
            completeHandler(false, nil, NSError(domain: "NetworkUrlErrorDoamin", code: -1000, userInfo: nil))
            return
        }
        var p = params
        p?["deviceid"] = deviceId
        p?["t"] = EYLoginSDKManager.shared().status
        p?["appkey"] = EYLoginSDKManager.shared().appkey
        p?["v"] = "1.0"
        let result = instance.getSecretkey(params: p ?? [:])
        p?["s"] = result
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        if method == .get {
            var i = 0
            for (key, value) in (p ?? [:]) {
                let v = instance.escape("\(value)")
                if i == 0 {
                    urlS += "?\(key)=\(v)"
                }else{
                    urlS += "&\(key)=\(v)"
                }
                i += 1
            }
            request.url = URL(string: urlS)
            request.httpMethod = "GET"
        } else {
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: p ?? [:], options: .fragmentsAllowed)
        }
        EYUrlRequestHandler.instance.sendRequest(request: request) { (data, error) in
            if error != nil {
                completeHandler(false, nil, error)
            } else {
                let dataMap = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String: Any]
                let code = dataMap?["code"] as? Int
                if code == 0 {
                    completeHandler(true, dataMap, nil)
                } else {
                    completeHandler(false, dataMap, NSError(domain: "requstErrorDomain", code: code ?? -1, userInfo: nil))
                }
            }
        }
    }
    
    //请求体,并处理特殊字符串 !$&'()*+,;= :#[]@
    private func buildParams(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.boolValue {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }

    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    func getSecretkey(params: [String: Any]) -> String {
        var secretkey = ""
        for key in params.keys.sorted(by: {$0 < $1}) {
            let value = params[key] ?? ""
            secretkey = "\(secretkey)\(key)=\(value)&"
        }
        secretkey = secretkey + EYLoginSDKManager.shared().secretkey
        secretkey = md5(string: secretkey)
        return secretkey
    }
    
    func md5(string: String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return hash as String
    }
}
