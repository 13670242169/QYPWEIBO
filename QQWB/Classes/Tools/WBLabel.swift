//
//  WBLabel.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/17.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

extension UILabel{
    /// uilabel穿件的遍历构造方法
    ///
    /// - Parameters:
    ///   - withText: withText description
    ///   - fontSize: fontSize description
    ///   - titleColor: titleColor description
    convenience init(withText:String, fontSize:CGFloat,titleColor:UIColor){
        self.init()
        font = UIFont.systemFont(ofSize: fontSize)
        textColor = titleColor
        text = withText
        numberOfLines = 0
    }
     /// uilabel类方法
     ///
     /// - Parameters:
     ///   - withText: withText description
     ///   - fontSize: fontSize description
     ///   - titleColor: titleColor description
     /// - Returns: return value description
     class func qqlabel(withText:String, fontSize:CGFloat,titleColor:UIColor) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = titleColor
        label.text = withText
        label.numberOfLines = 0
        return label
    }
}
