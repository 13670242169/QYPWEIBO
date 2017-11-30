//
//  String+Extensions.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/22.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import Foundation

extension String{
    // 从当前字符串中，提取链接和文本
    // swift 提供了“元组” ，同时返回了多个值
    // 如果是OC，可以返回字典，、自定义对象、指针的指针
    func qyp_href()->(link:String,text:String)?{
        // 0.匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        // 1.创建正则表达式，并且匹配第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location:0,length:characters.count))
        else{
            return nil
        }
        // 2.获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        print(link + "----" + text)
        return (link,text)
    }
}
