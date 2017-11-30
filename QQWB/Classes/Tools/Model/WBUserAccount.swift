//
//  WBUserAccount.swift
//  QQWB
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
fileprivate let accountFile : NSString = "useraccount.json"
//用户账号信息
class WBUserAccount: NSObject {
    //访问令牌
    var access_token:String? //= "2.00h9LU7GUbhuMB5d3fca0e28L7x_SB"
    //用户代号
    var uid:String?
    //access_token的生命周期,单粒是秒杀
    //开发者5年
    //使用者3天
    var expires_in:TimeInterval = 0{
        didSet{
            expiresDate = Date.init(timeIntervalSinceNow: expires_in)
        }
    }
    var expiresDate:Date?

    ///用户昵称
    var screen_name:String?
    
    //用户头像
    var avatar_large:String?
    //这里是计算性属性,这句话必须
    override var description: String{
        return yy_modelDescription()
    }

    override init() {
        super.init()

        //从磁盘加载保存的文件 -->字典

        //加载磁盘文件到到二进制
        guard let path = accountFile.cz_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject]
        else{
                return
        }
        print(path)
        //使用字典设置属性值(如果想看到登录界面就把这局话注释掉)
        //用户是否登录的关键代码
        yy_modelSet(with: dict ?? [:])
        print("从沙盒加载用户信息")

        //判断token是否过期
        //测试过期日期
        //expiresDate = Date.init(timeIntervalSinceNow: -3600 * 24)
        if expiresDate?.compare(Date()) != .orderedDescending{

            //清空token
            access_token = nil
            uid = nil
            //删除用户文件
            _ = try? FileManager.default.removeItem(atPath: path)
            print("账户过期")

        }
        print("账户正常")
    }
    /*
     1.偏好设置(小) - xcode 8 beta 无效
     2.沙盒-归档/plist/json
     3.数据库(FMDB/CoreData)
     4.钥匙串访问(小/自动加密-需要使用框架SSKeyChain)
     */
    func saveAccount(){
        //1.模型转字典
        var dict = self.yy_modelToJSONObject() as? [String:AnyObject] ?? [:]

        //删除过期时间
        dict.removeValue(forKey: "expires_in")
        //2.字典序列化(字典 -> data)
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let fileName = accountFile.cz_appendDocumentDir()
        else{
            return
        }
        //3.写入磁盘("useraccount.json" as NSString)
        (data as NSData).write(toFile: fileName , atomically: true)

        print("保存成功 \(fileName)")
        //用户账号绑定
    }
}
