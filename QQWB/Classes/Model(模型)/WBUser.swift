//
//  WBUser.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/25.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBUser: NSObject {
    //基本数据类型不能够设置可选 和 private不能够使用kvc设置
    var id :Int64 = 0
    //用户昵称
    var screen_name:String?
    //用户头像地址（中图）50*50
    var profile_image_url:String?
    //认证类型-1没有认证 0 认证用户，235企业认证，220达人
    var verified_type:Int = 0
    //会员等级
    var mbrank:Int = 0
    
    override var description: String{
        return yy_modelDescription()
    }
}
