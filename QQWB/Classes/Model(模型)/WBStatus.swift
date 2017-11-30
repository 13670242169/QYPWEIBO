//
//  WBStatus.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/18.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import YYModel
class WBStatus: NSObject {
    //Int类型在64位的机器是64的在32位机器就是32位
    //如果不写Int64在5，5c，ipad2是32的
    var id: Int64 = 0
    //微博信息
    var text:String?
    /// 微博创建时间字符串
    var created_at:String?
    /// 微博来源 - 发布微博
    var source:String?
    
    //转发数
    var reposts_count:Int = 0
    //评论数
    var comment_count:Int = 0
    //点赞数
    var attitudes:Int = 0
    /// 微博用户
    var user:WBUser?
    
    /// 被转发的原创微博
    var retweeted_status:WBStatus?
    
    ///微博配图模型数组
    var pic_urls:[WBStatusPicture]?
    //重写description计算型属性
    override var description: String{
        return yy_modelDescription()
    }
    /// 类函数
    /// 告诉yy——model如果遇到数组类型的属性，数组中存放的对象是什么类？
    /// - Returns:
    /// NSArray中班车对象的类型通常是‘id’类型
    /// OC中泛型是swift退出后，苹果为了兼容给OC增加，从运行时的角度，仍然不知道数组中应该存放什么类型对象
    class func modelContainerPropertyGenericClass() ->[String:AnyClass]{
        return ["pic_urls":WBStatusPicture.self]
    }
}
