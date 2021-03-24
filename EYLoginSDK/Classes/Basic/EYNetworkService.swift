//
//  EYNetworkService.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/24.
//

import UIKit

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
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        if method == .get {
            var i = 0
            for (key, value) in (params ?? [:]) {
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
            request.httpBody = instance.buildParams(params ?? [:]).data(using: .utf8)
        }
        EYUrlRequestHandler.instance.sendRequest(request: request) { (data, error) in
            if error != nil {
                completeHandler(false, nil, error)
            } else {
                let dataMap = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String: Any]
                let code = dataMap?["code"] as? Int
                if code == 200 {
                    completeHandler(true, dataMap?["data"] as? [String: Any], nil)
                } else {
                    completeHandler(false, nil, NSError(domain: "requstErrorDomain", code: code ?? 0, userInfo: nil))
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
}
