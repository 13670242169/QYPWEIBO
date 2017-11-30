//
//  JYFarmNetWorkClass.swift
//  JYFarmSwift
//
//  Created by Apple on 2017/11/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import YYModel
// MARK: - 封装的程序网络请求的方法
extension JYNetWorking {
    /// 登录请求对应的网络请求方法
    func loginRequest(method: JYHTTPMethod = .POST , parameters: [String: Any]? , completion:@escaping (_ isSuccess:Bool,_ status:String)->()){
        request(URLString: "http://shop.jinyoufarm.com/api/user/login", parameters: parameters) { (dict, isSuccess) in
            
            
            guard let result = dict as? [String:AnyObject],
                let resultStatus = result["result"]
            else {
                return
            }
            // 登录账户错误
            if resultStatus as! Int64 == 3 {
                completion(false,"登录的账户错误")
            }else if resultStatus as! Int64 == 2{
                completion(false,"登录的密码错误")
            } else if resultStatus as! Int64 == 0 {
                completion(true,"登录成功")
            }
            // 由于上面需要判断拿到resultStatus的值,然而在 登录失败的时候data没有值,所以讲data的守护单独出来
            guard let data = result["data"] as? [String :AnyObject] else{
                return
            }
            
            self.userModel.token = data["token"] as? String
            self.userModel.userId = data["userId"] as? String
            self.userModel.createTime = data["createTime"] as? Int64
            
            var dict = [String:AnyObject]()
            dict["token"] = self.userModel.token as AnyObject
            dict["userId"] = self.userModel.userId as AnyObject
            dict["createTime"] = self.userModel.createTime as AnyObject
            self.userModel.saveAccount(dict: dict)
        }
    }
    // 获取商品种类请求
    func handlerCategoryData(method: JYHTTPMethod = .GET,parameters: [String: Any]? , completion:@escaping (_ isSuccess:Bool,_ JSON:AnyObject)->()){
        tokenRequest(method: .GET, URLString: "http://shop.jinyoufarm.com/api/goods/category/areaList", parameters: [:]) { (json, isSuccess) in
            print(json)
            completion(isSuccess, json)
        }
    }



}
