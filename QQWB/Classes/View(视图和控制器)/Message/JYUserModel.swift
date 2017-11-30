//
//  JYUserModel.swift
//  JYFarmSwift
//
//  Created by Apple on 2017/11/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import YYModel
private let accountFile: NSString = "useraccount.json"
class JYUserModel: NSObject {

    var token:String?
    var userId:String?
    var createTime:Int64?
    
    //这里是计算性属性,这句话必须
    override var description: String{
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        // 冲磁盘中加载保存的文件 --> 字典
        
        // 加载磁盘文件到二进制
        guard
        let path = accountFile.cz_appendDocumentDir() ,
        let data = NSData(contentsOfFile: path),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject]
        
            else {
                return
        }
        // 使用字典设置属性
        token = dict!["token"] as? String
        userId = dict!["userId"] as? String
        createTime = dict!["createTime"] as? Int64
        
        
    }
    
    func saveAccount(dict:[String:AnyObject]) {
        // 需要删除 expires_in 值
//        dict.removeValue(forKey: "createTime")

        // 2. 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = accountFile.cz_appendDocumentDir()
            else {
                return
        }
        // 3. 写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功 \(filePath)")
    }
    
}
