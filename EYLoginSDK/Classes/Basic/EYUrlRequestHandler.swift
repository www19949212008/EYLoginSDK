//
//  EYUrlRequestHandler.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/24.
//

import UIKit

class EYUrlRequestHandler: NSObject {
    static var instance = EYUrlRequestHandler()
    var session: URLSession?
    
    func sendRequest(request: NSMutableURLRequest, completeHandler: @escaping ( _ data: Data?, _ error: Error?)->Void) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        if session == nil {
            session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        }
        session?.dataTask(with: request as URLRequest) { (data, response, error) in
            debugLog(message: response)
            completeHandler(data, error)
        }.resume()
    }
}

extension EYUrlRequestHandler: URLSessionDelegate {
    
}
