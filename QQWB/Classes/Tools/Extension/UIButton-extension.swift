//
//  UIButton-extension.swift
//  QQWB
//
//  Created by Apple on 2017/9/15.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
extension UIButton{
    //只有一张图片组合起来的
    convenience init(imageName:String){
        self.init()
        setImage(UIImage(named:imageName), for: .normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    convenience init(title:String,bgColor:UIColor,fontSize:CGFloat = 14){
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    //由两张图片组织起来的前后两张图片
    convenience init (imageName : String, bgImageName : String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    class func qqButton(fontSize:CGFloat=16, titleLabelText:String,BgimageStr:String,normalColor:UIColor,hightlightedColor:UIColor)->UIButton {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.setTitle(titleLabelText, for: UIControlState.normal)
        btn.setBackgroundImage(UIImage(named: BgimageStr), for: UIControlState.normal)
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(hightlightedColor, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return btn
    }
}
