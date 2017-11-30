//
//  boundle+Extension.swift
//  QQWB
//
//  Created by Apple on 2017/9/15.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import Foundation

extension Bundle{
    var nameSpace:String{
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
