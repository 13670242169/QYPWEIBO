//
//  WBVisitorView.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/17.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    ///注册按钮，
    lazy var registerButton:UIButton = UIButton.qqButton(
        titleLabelText: "注册",

        BgimageStr:"common_button_white_disable" ,

        normalColor: UIColor.orange,

        hightlightedColor: UIColor.black
    )

    ///登录按钮
    lazy var loginButton:UIButton = UIButton.qqButton(
        titleLabelText: "登录",

        BgimageStr:"common_button_white_disable" ,

        normalColor: UIColor.darkGray,

        hightlightedColor: UIColor.black
    )

    //访客视图的信息字典【imageName/message】
    var visitorInfo:[String:String]?{
        didSet{
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            tipLabel.text = message
            if imageName == ""{
                houseIconView.isHidden = false
                startAnimation()
                return
            }
            iconView.image = UIImage(named:imageName)
            tipLabel.text = message
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-私有控件
    ///懒加载属性只有调用uikit控件指定的构造函数，其他的都需要适用类型
    ///图像视图，
    lazy var iconView:UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
    ///门板
    lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))
    
    ///小房子 
    lazy var houseIconView:UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_image_house"))
    ///提示标签
    lazy var tipLabel : UILabel = UILabel(withText: "我已经被重新赋值了", fontSize: 14, titleColor: UIColor.darkGray)

    //选择图标
    private func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI//旋转的角度
        anim.repeatCount = MAXFLOAT//一直旋转
        anim.duration = 15
        //完成不删除，如果iconView被释放，动画会一起被销毁
        //设置连续播放动画非常有用，在按了home键再进来还会继续转
        anim.isRemovedOnCompletion = false
        //将动画添加到图层
        iconView.layer.add(anim, forKey: nil)
    }
}
extension WBVisitorView{
    func setupUI(){
        backgroundColor = UIColor.white
        
        //添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //文字居中
        tipLabel.textAlignment = .center
        
        //2.取消autoresizing自动布局autolayout和他不能够共存
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        //3.自动布局
        ///1>图像视图
        /*
         item:视图
         attribute：约束属性
         relatedBy：约束关系
         toItem：参照视图
         attribute：参照属性
         multiplier：乘机
         constant：约束数值
         */
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        
        ///2>小房子
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        //3>提示标签
        let margin:CGFloat = 20
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 236))
        //4>注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        
        //5>注登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35))
        //6>
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .bottom, relatedBy: .equal, toItem: registerButton, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .top, multiplier: 1.0, constant: 0))
        backgroundColor = UIColor.init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
    }
}
