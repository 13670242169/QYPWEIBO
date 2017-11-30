//
//  QYPEmoticonInputView.swift
//  表情键盘
//
//  Created by 高级iOS开发 on 2017/11/8.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
// 表情输入视图
class QYPEmoticonInputView: UIView {
    /// 加载并且返回输入视图
    ///
    /// - Returns: <#return value description#>
    class func inputView() -> QYPEmoticonInputView{
        let nib = UINib(nibName: "QYPEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! QYPEmoticonInputView
        return v
    }
  

}
