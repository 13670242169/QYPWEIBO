//
//  WBComposeType.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/19.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import pop
/// 撰写微博类型视图
class WBComposeType: UIView {
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    // 按钮数据数组
    fileprivate let buttonsInfo =   [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                                     ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                                     ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                                     ["imageName": "tabbar_compose_lbs", "title": "签到"],
                                     ["imageName": "tabbar_compose_review", "title": "点评"],
                                     ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                                     ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                                     ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                                     ["imageName": "tabbar_compose_music", "title": "音乐"],
                                     ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    fileprivate var completionBlock:((_ clsName:String?) ->())?
    // MARK: - 实例化方法
    class func composeView() -> WBComposeType{
        let nib = UINib(nibName: "WBComposeType", bundle: nil)
        // 从xib加载完成视图，就会调用awakeFromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeType
        // xib默认600 * 600
        v.frame = UIScreen.main.bounds
        v.setupUI()
        return v
    }
    /// 显示当前视图
    ///   ----------- OC 中block如果当前方法，不能执行，通常使用属性记录，在需要的时候执行
    func show(completion:@escaping (_ clsName:String?)->()){
        // 0.记录闭包
        completionBlock = completion
        /// 1>将当前视图添加到，根视图控制器的view
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        // 2 >添加视图
        vc.view.addSubview(self)
        showCurrentView()
        showButtons()
    }
    @objc func clickButton(){
        print("点击")
    }
    @objc func clickMore(){
        print("点击更多")
        let offset = CGPoint(x: scrollview.bounds.width, y: 0)
        scrollview.setContentOffset(offset, animated: true)
        // 2> 处理两个按钮封开
        returnButton.isHidden = false
        closeButtonCenterXCons.constant += 50
        returnButtonCenterXCons.constant -= 50
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    // 返回按钮
    @IBAction func returnButton(_ sender: Any) {
        let offset = CGPoint(x: 0, y: 0)
        scrollview.setContentOffset(offset, animated: true)
        // returnbutton隐藏
        returnButton.isHidden = true
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    // 关闭按钮
    @IBAction func close(_ sender: Any) {
       // removeFromSuperview()
        cancelButton()
    }
    @objc fileprivate func clickButton(button:WBComposeTypeButton){
        // 1.判断当前显示视图
        let page = Int(scrollview.contentOffset.x / scrollview.bounds.width)
        let v = scrollview.subviews[page]
        // 2.遍历当前的视图
        // -选中的按钮放大
        // -为选中的按钮输小
        for (i,btn) in v.subviews.enumerated(){
            // 1. 缩放动画
            let scaleAnim = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scal = (button == btn) ? 2 : 0.2
            scaleAnim?.toValue = NSValue(cgPoint:CGPoint(x: scal, y: scal))
            scaleAnim?.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            // 2.渐变动画
            let alphaAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            // 3.添加动画监听
            if i == 0{
                alphaAnim.completionBlock = {_ , _ in
                    // 需要执行回调
                    print("完成糊掉展现控制器")
                    // 执行完成闭包
                    print(button.clsName)
                    self.completionBlock!(button.clsName)
                }
            }
        }
    }
}
fileprivate extension WBComposeType{
    fileprivate func showCurrentView(){
        // 1>动画显示当前视图
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.5
        // 添加到视图
        pop_add(anim, forKey: nil)
    }
    // 消失动画
    /// 隐藏按钮动画
    fileprivate func cancelButton(){
        // 1.根据contentOffset判断当前的子视图
        let page = Int(scrollview.contentOffset.x / scrollview.bounds.width)
        let v = scrollview.subviews[page]
        // 2. 遍历v中的所有按钮
        for (i,btn) in v.subviews.enumerated().reversed() {
            // 1.创建动画
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //2.设置动画属性
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 400
            // 设置时间
            // 设置动画启动时间(一个一个的进来) 0.025时间间隔
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            // 3。添加动画
            btn.layer.pop_add(anim, forKey: nil)
            //4》 监听第0个按钮的动画，是最后一个执行的
            if i == 0{
                anim.completionBlock = {_ ,_ in
                    self.hideCurrentView()
                }
            }
        }
    }
    // 隐藏当前视图
    fileprivate func hideCurrentView(){
        // 1. 创建动画
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim?.fromValue = 1
        anim?.toValue = 0
        anim?.duration = 0.5
        pop_add(anim, forKey: nil)
        //3添加完成监听方法
        anim?.completionBlock = {_ ,_ in
            self.removeFromSuperview()
        }
    }
    // MARK: -显示部分的动画
    // 弹力线是按钮
    fileprivate func showButtons(){
        // 1. 获取scrollview的自视图的第0个视图
        let v = scrollview.subviews[0]
        // 2. 遍历v中的所有anniu
        for (i,btn) in v.subviews.enumerated(){
            // 1. 创建动画
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            // 2.设置动画属性
            anim.fromValue = btn.center.y + 400
            anim.toValue = btn.center.y
            // 弹的动画（弹力系数）0~20
            anim.springBounciness = 8
            // 弹力速度 0~20
            anim.springSpeed = 18
            // 设置动画启动时间(一个一个的进来) 0.025时间间隔
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval( i) * 0.025
            // 3 添加动画
            btn.pop_add(anim, forKey: nil)
        }
    }
}
fileprivate extension WBComposeType{
    func setupUI(){
        //0.强行更新布局
        layoutIfNeeded()
        //1.向scrollview添加视图
        let rect = scrollview.bounds
        for i in 0..<2 {
             let v = UIView(frame:rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0))
            //2.向视图添加按钮
            addButtons(v: v, idx: i * 6)
            // 3.将试图添加到scrollview
            scrollview.addSubview(v)
        }
        // 4.设置scrollview
        scrollview.contentSize = CGSize(width: 2 * rect.width, height: 0)
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.bounces = false
        // 禁用滚动
        scrollview.isScrollEnabled = false
    }
    func addButtons(v:UIView,idx:Int){
        let count = 6
        // 从idx开始，添加6个按钮
        for i in idx..<(idx + count) {
            if i >= buttonsInfo.count{
                break
            }
            // 0> 从数组中获取图像和title
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"] ,
                let title = dict["title"] else {
                    continue
            }
            // 1> 创建按钮
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            // 2> 将btn添加到v里面
            v.addSubview(btn)
            // 添加监听方法
            if let actionName = dict["actionName"]{
                // OC中使用NSSelectiorFromString(@"clickMore")
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else{
                btn.addTarget(self, action: #selector(self.clickButton(button:)), for: .touchUpInside)
            }
            // 设置要展现的类名
            btn.clsName = dict["clsName"]
            print(dict["clsName"])
            print(btn.clsName)
        }
        // 布局按钮 遍历视图的子视图
        // 准备常量
        let btnSize = CGSize(width:100,height:100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        for (i,btn) in v.subviews.enumerated() {
            let y:CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
}
