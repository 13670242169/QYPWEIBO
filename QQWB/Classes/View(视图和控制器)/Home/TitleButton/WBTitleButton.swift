//
//  WBTitleButton.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/20.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    ///重载构造函数
    ///-title如果是nil，就显示“首页”
    ///-如果不是nil，显示title和箭头
    init(title:String?) {
        super.init(frame: CGRect())
        //判断title是否nil
        if title == nil{
            setTitle("首页", for: [])
        }else{
            setTitle(title! + " " , for: [])
            setImage(UIImage(named:"navigationbar_arrow_down"), for: [])
            setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
        //2设置字体颜色
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel,let imageView = imageView else {
            return
        }
//        //将label的x向左移动image的宽度
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
//        //将imageView的x向右移动lable 的宽度
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.frame.size.width
    }
}
