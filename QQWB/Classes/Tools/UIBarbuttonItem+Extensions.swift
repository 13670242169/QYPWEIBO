//
//  UIBarbuttonItem+Extensions.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/14.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /// uibarbutton的自定义遍历构造方法
    ///
    /// - Parameters:
    ///   - title: 按钮的文字显示内容
    ///   - fontSize: 字体大小
    ///   - target: target description
    ///   - action: action description
    convenience init(title:String,fontSize:CGFloat = 16,target:AnyObject?,action:Selector) {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitle(title, for: .highlighted)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.sizeToFit()
        self.init(customView: btn)
    }
}
