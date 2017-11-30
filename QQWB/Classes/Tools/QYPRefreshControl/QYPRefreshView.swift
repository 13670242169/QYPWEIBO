//
//  QYPRefreshView.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/16.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
/// 刷新视图 - 负责刷新相关UI显示动画
class QYPRefreshView: UIView {
    
    /// 刷新状态
    /*
     ios 系统中。UIView封装的旋转动画
     -默认顺时针旋转
     -就近原则
     - 要想实现同方向旋转。需要调整一个，非常小的数值
     - 如果想实现360旋转，需要核心动画。CABaseAnimation
     */
    var refreshState:QYPRefreshState = .Normal{
        didSet{
            switch refreshState {
            case .Normal:
                /// 恢复状态
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                tipLabel?.text = "继续使劲拉。。。"
                UIView.animate(withDuration: 0.25){
                    
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel?.text = "放手就刷新。。。"
                UIView.animate(withDuration: 0.25){
                    
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: .pi - 0.01)
                }
            case .WillRefresh:
                tipLabel?.text = "正在刷新中。。。"
                
                /// 隐藏提示图标
                tipIcon?.isHidden = true
                /// 显示菊花
                indicator?.startAnimating()
            }
            
        }
    }
    /// 俯视图的高度 --- 为了刷新控件不需要关心具体的刷新视图是谁！
    var paraentViewHeight:CGFloat = 0
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    
    /// 提示文字
    @IBOutlet weak var tipLabel: UILabel?
    
    class func refreshView() -> QYPRefreshView{
        
//        let nib = UINib(nibName: "QYPRefreshView", bundle: nil)
        
        let nib = UINib(nibName: "QYPManRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! QYPRefreshView
    }
}
