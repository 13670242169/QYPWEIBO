//
//  JYNetWorking.swift
//  JYFarmSwift
//
//  Created by Apple on 2017/11/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
enum JYHTTPMethod {
    case GET
    case POST
}
class JYNetWorking: AFHTTPSessionManager {
    static let shared: JYNetWorking = {
        let instance = JYNetWorking()
        instance.responseSerializer = AFJSONResponseSerializer()
        instance.requestSerializer = AFJSONRequestSerializer()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    lazy var userModel = JYUserModel()
    /// 判断是否登录
    var islogin:Bool{
        print(userModel.token)
        return userModel.token != nil
    }

    
    /// POST请求
    ///
    /// - Parameters:
    ///   - method: <#method description#>
    ///   - URLString: <#URLString description#>
    ///   - parameters: <#parameters description#>
    ///   - completion: <#completion description#>
    func request(method: JYHTTPMethod = .POST, URLString: String, parameters: [String: Any]?,completion: @escaping (_ result: AnyObject, _ isSuccess: Bool)->()) {
        post(URLString, parameters: parameters, progress: nil, success: { (_ , responseObject) in
            print(responseObject)
            // 返回成功
            completion(responseObject as AnyObject, true)
        }) { (task, error) in
            // 返回失败
            completion(  error as AnyObject, false)
            print(error)
        }
    }
    func tokenRequest(method: JYHTTPMethod = .GET, URLString: String, parameters: [String: Any]?,completion: @escaping (_ result: AnyObject, _ isSuccess: Bool)->()) {

        requestSerializer.setValue("12fd95ae83bf464c9bb4ae837735717a", forHTTPHeaderField: "token")
      
        let success = {(task:URLSessionDataTask,json:Any?) in
            let json  = json as AnyObject
            completion(json , true)
        }
        let faitrue = {(task:URLSessionDataTask?,error:Any)->() in
            print(error)
            
            completion(error as AnyObject , false)
            print("服务器连接失败")
        }
        if method == .POST{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: faitrue)
        }else {
             get(URLString, parameters: parameters, progress: nil, success: success, failure: faitrue)
        }
        
        
        
    }
}
