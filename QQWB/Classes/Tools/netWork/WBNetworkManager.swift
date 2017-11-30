//
//  WBNetworkManager.swift
//  QQWB
//
//  Created by Apple on 2017/9/18.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import AFNetworking
//swift中枚举支持任意类型
//oc中枚举只支持整数
/*
 如果网络请求中,发现网络请求返回的转台吗是405,不支持的网络请求方法
 - 首先应该查找网络请求方法是否正确
 */
enum  WBHTTPMethod {
    case GET
    case POST
}
//网络编辑工具
class WBNetworkManager: AFHTTPSessionManager {
    //静态去(常量)/闭包,在第一次访问是执行闭包,并且加结果保存在shared中
    static let shared: WBNetworkManager = {
        //实例化对象
        let instance = WBNetworkManager()

        //设置响应的反序列化

        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")

        //返回对象
        return instance
    }()

    lazy var userAccount = WBUserAccount()
    //用户登录标记(计算型属性)
    var userLogon:Bool{
        return userAccount.access_token != nil
    }
    ///专门负责token请求,单独处理taken网络请求的方法
    /// - Parameters:
    ///   - Method: get/post
    ///   - URLString:
    ///   - parameters:
    ///   - data: data 为空的时候不上上传文件
    ///   - name: 位空的时候不是上传文件
    ///   - completion: <#completion description#>
    func tokenResquest(Method:WBHTTPMethod = .GET, URLString:String,parameters:[String:Any]?,data:Data? = nil,name:String? = nil,completion:@escaping (_ response:AnyObject,_ isSuccess:Bool)->()){
        //使用tolen字典
        guard let token = userAccount.access_token else {
            print("token没有  请登录")

            completion("" as AnyObject,false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: "backtoken")
            return
        }
        //判断参数是否有值
        var parameters = parameters
        if parameters == nil{
            parameters = [String:Any]()
        }
        
        // 判断是不是上传文件
        if let data = data,let name = name {
            // 是上传文件
            upload(URLString: URLString, parameters: parameters, data: data, name: name, completion: { (json, isSuccess) in
                completion(json as AnyObject,isSuccess)
            })
        }else{
            // 不是上传文件
            //代码再这里一定有值
            parameters!["access_token"] = token
            //调用request发起网方法络请求
            request(Method: Method, URLString: URLString, parameters: parameters, completion: completion)
        }
    }
    
    /// 上传文件 封装afn的上传文件请求
    /// 上传文件必须是post请求
    /// - Parameters:
    ///   - URLString: <#URLString description#>
    ///   - parameters: <#parameters description#>
    ///   - data: <#data description#>
    ///   - completion: <#completion description#>
    func upload(URLString:String,parameters:[String:Any]?,data:Data,name:String,completion:@escaping (_ response:Any,_ isSuccess:Bool)->()){
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            /*
             name :服务器接收到的数据的字段名
             mimeType 告诉服务器上传的文件类型,如果不想告诉,可以使用application/octet-stream
             */
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
        }, progress: nil, success: { (_, json) in
            completion(json as AnyObject , true)
        }) { (task, error) in
            let faitrue = {(task:URLSessionDataTask?,error:Any)->() in
                print(error)
                if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                    print("token过期了")
                    //发送通知(本方法不知道被谁调用，谁接受到通知，谁处理！)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
                }
                completion(error as AnyObject , false)
                print("服务器连接失败")
            }
        }
    }
    
    
    ///使用一个函数封装afn的get和post请求
    /// 封装afn的get 和post 请求
    ///
    ///   - Parameters:
    ///   - Method: get\\post
    ///   - URLString: URLString description
    ///   - parameters: parameters description
    ///   - completion: 完成回调
    func request(Method:WBHTTPMethod = .GET, URLString:String,parameters:[String:Any]?,completion:@escaping (_ response:AnyObject,_ isSuccess:Bool)->()){

        print(parameters ?? "查看params的值")
        let success = {(task:URLSessionDataTask,json:Any?) in
            let json  = json as AnyObject
            completion(json , true)
        }
        let faitrue = {(task:URLSessionDataTask?,error:Any)->() in
            print(error)
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("token过期了")
                //发送通知(本方法不知道被谁调用，谁接受到通知，谁处理！)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
            }
            completion(error as AnyObject , false)
            print("服务器连接失败")
        }
        if Method == .GET{
            print(URLString)
            get(URLString, parameters: parameters, progress: nil, success: success, failure: faitrue)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: faitrue)
        }

    }

}
