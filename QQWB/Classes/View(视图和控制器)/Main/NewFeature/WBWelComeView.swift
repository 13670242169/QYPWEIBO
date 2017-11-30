//
//  WBWelComeView.swift
//  QQWB
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import SDWebImage
class WBWelComeView: UIView {
    @IBOutlet weak var iconView: UIImageView!

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottonCons: NSLayoutConstraint!
    class func welcomeView() -> WBWelComeView{
        let nib = UINib(nibName: "WBWelComeView", bundle: nil)

        let v  = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelComeView

        v.frame = UIScreen.main.bounds

        return v
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //提示,initWithCoder只是刚刚从xib的二进制文件将试图数据加载完成
        //还没有和代码连线建立关系,所有开发是,千万不要在这个方法中处理UI
        print("initWithCoder + \(iconView)")  //initWithCoder + nil
    }

    override func awakeFromNib() {
        print("awakeFromNib + \(iconView)")

        //1.url
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string:urlString) else {
            return
        }
        //2设置头像 - 如果网络头像没有下载完成,先显示占位头像
        //2.如果不指定占位头像,之前设置的头像会被清空
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named:"avatar_default"))
        
    }




    //自动布局系统跟新完成约束后会自动调用此方法
    //纯代码开发中对子视图进行修改
//    override func awakeFromNib() {
//
//    }

    //视图被放到window上,表示被显示了,表示self这个view已经显示在视图上面,
    override func didMoveToWindow() {
        super.didMoveToWindow()


        //视图是使用自动布局设置的,只是设置了约束
        // - 当视图被添加到窗口上时,根据父视图的大小计算约束值,更新空间位置
        // - layoutIfNeeded会直接按照当前的约束直接更新控件位置
        // - 执行之后,控件所在的位置,就是xib中布局的位置
//        self.layoutIfNeeded()

        self.bottonCons.constant = self.bounds.size.height - 200

        UIView.animate(withDuration: 4.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            //更新约束
            self.layoutIfNeeded()
        }) { (_) in

            UIView.animate(withDuration: 1.0, animations: { 
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
}
