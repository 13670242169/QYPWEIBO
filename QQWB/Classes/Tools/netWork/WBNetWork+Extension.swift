//
//  WBNetWork+Extension.swift
//  QQWB
//
//  Created by Apple on 2017/9/18.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import Foundation
// MARK: - 封装微博的网络请求
extension WBNetworkManager{
    func statusList( since_id:Int64 = 0,max_id:Int64 = 0,completionList:@escaping (_ list:[[String:AnyObject]]?,_ isSuccess:Bool)->()){
        //用网络工具加重微博数据
        let urlstring = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id":since_id,"max_id":max_id > 0 ? max_id - 1 : 0]

        tokenResquest(URLString: urlstring, parameters: params) { (json, isSuccess) in

            //冲json中获取到statuses字典数组
            let result = json["statuses"] as? [[String:AnyObject]]
            //回调
            completionList(result,true)
        }
    }
    ///返回微博的未读数量 -
    func unreadCount(completion:@escaping (_ count:Int)->()){
        guard let uid = userAccount.uid else {
            return
        }
        let urlStirng = "https://api.weibo.com/2/remind/unread_count.json"
        let params = ["uid":uid]
        tokenResquest(URLString: urlStirng, parameters: params) { (json, isSuccess) in
            
            let dict = json
            let count = dict["status"] as? Int

            completion(count ?? 0)

        }

    }


}
// MARK: - 发布微博
extension WBNetworkManager{
    /// 发布微博
    ///
    /// - Parameters:
    ///   - text: 要发布的文本
    ///   - image: 位nil时没发布的纯文本微博
    ///   - completion: 回调
    func postStatus(text:String,image:UIImage?,completion:@escaping (_ result:[String:AnyObject]?,_ isSuccess:Bool)->())->(){
        //1.url
        
        let urlString:String
        if image == nil{
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }else{
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        // 2.参数字典
        let params = ["status" :text]
        
        // 如果图像不为空
        var name:String?
        var data:Data?
        if image != nil{
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        //3.发起网络请求
        tokenResquest(Method: .POST, URLString: urlString, parameters: params, data: data, name: name) { (json, isSuccess) in
            completion(json as? [String:AnyObject],isSuccess)
        }
    }
}
// MARK: - oauth相关
extension WBNetworkManager{
    ///加载accseetoken登录
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调
    func loadAccessToken(code:String,completion:@escaping (_ isSuccess:Bool) ->()){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":WBAppKey,
                      "client_secret":WBAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WBRedirectUTI]

        //发起网络请求
        request(Method: .POST, URLString: urlString, parameters: params) { (json, isSuccess) in
            print(json)
            //直接拿json设置
            //如果强求失败,对用户账号数据不会有任何影响
            //使用yymodelset用字典设置模型
            self.userAccount.yy_modelSet(withJSON: json)
            //            self.userAccount.yy_modelSet(with: (json as? [String:AnyObject]) ?? [:])
            
            print(isSuccess)
            self.loadUserInfo(completion: { (dict) in
               
                //使用用户信息字典，设置账户信息
                self.userAccount.yy_modelSet(with: dict)
                print(self.userAccount)
                
                //保存模型
                self.userAccount.saveAccount()
                
                completion(isSuccess)
            })
        }
    }
}
// MARK: - 用户信息
extension WBNetworkManager{
    ///加载当前用户信息
    func loadUserInfo(completion:@escaping (_ dict:[String:AnyObject])->()){
        guard let uid = userAccount.uid else {
            return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        //发起网络请求
        tokenResquest(URLString: urlString, parameters: params) { (json, isSuccess) in
            
            completion((json as? [String:AnyObject]) ?? [:])
        }
    }
}
