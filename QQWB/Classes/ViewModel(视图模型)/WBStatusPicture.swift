//
//  WBStatusPicture.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/11.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

/// 微博配图模型
class WBStatusPicture: NSObject {
    /// 缩里图
    var thumbnail_pic :String?
    override var description: String{
        return yy_modelDescription()
    }
}
