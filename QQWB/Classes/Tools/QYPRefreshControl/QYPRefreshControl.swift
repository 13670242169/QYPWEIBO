//
//  QYPRefreshControl.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/15.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
/// 刷新控件的临界点
fileprivate let QYPReshOffset:CGFloat = 80
/// 刷新状态
///
/// - Normal: 普通状态，什么都不做
/// - Pulling: 超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum QYPRefreshState{
    case Normal
    case Pulling
    case WillRefresh
}
/// 刷新控件 - 负责刷新相关的业务逻辑
class QYPRefreshControl: UIControl {

    // MARK ： - 属性
    /// 滚动视图的父视图，下拉刷新控件应该适用于UITableView、UICollectionView
    /// weak 父视图对他进行强引用，所以这里使用weak ，不然会造成循环引用
    private weak var scrollview:UIScrollView?
    
    fileprivate lazy var refreshView:QYPRefreshView = QYPRefreshView.refreshView()
    
    
    
    // MARK：- 构造函数
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    /*
     willMove addSubView 方法会调用
     -当添加到俯视图时候，newSuperView是父视图
     -当父视图被移除，newSuperView是nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // 判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else{
            return
        }
        // 记录父视图
        scrollview = sv
        
        /// KVO 监听父视图的contentoffset
   
        scrollview?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    /// 本视图从父视图上移除
    /// 提示：所有的下拉刷新框架都是监听父视图contentOffset
    /// 所有的款姐都是KVO监听实现思路都是这个
    override func removeFromSuperview() {
        // superView 还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        // superView 不存在
    }
    // 所有kvo方法会同意调用此方法
    /// 在程序中，通常指接听某一个对象的某几个属性，如果属性太多，方法会很乱
    /// 观察者模式，在不需要的时候，都需要释放
    /// - 通知中心：如果不释放，什么也不会发生，但是，会内存泄漏，会有多次注册的可能
    /// - KVO: 如果不释放，会奔溃
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /// contentOffset 的y 值和contentInset的top有关
        guard let sv = scrollview else {
            return
        }
        
        // 初始高度
        let height = -(sv.contentInset.top + sv.contentOffset.y + 20)
        
        /// 刷新控件往上面滚，直接return
        if height < 0{
            return
        }
        
        // 可以根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        /// ----- 传递父视图高度，如果正在刷新，不传递
        /// --  把代码放在最合适的地方！
        if refreshView.refreshState != .WillRefresh{
            refreshView.paraentViewHeight = height
        }
        
        
        /// 判断临界点 - 只需要判断一次
        if sv.isDragging{
            if height > QYPReshOffset && (refreshView.refreshState == .Normal){
                print("放手刷新")
                refreshView.refreshState = .Pulling
            }else if height <= QYPReshOffset && (refreshView.refreshState == .Pulling){
                print("继续使劲。。。")
                refreshView.refreshState = .Normal
            }
        }else{
            /// 放手 - 判断是否超过临界点
            if refreshView.refreshState == .Pulling{
                print("准备开始刷新")
               beginRefreshing()
                
                /// 发送刷新事件
                sendActions(for: .valueChanged)
            }
            
        }
        
    }
    
    //开始刷新
    func beginRefreshing(){
        print("开始刷新")
        /// 判断父视图
        guard let sv = scrollview else {
            return
        }
        /// 判断是否正在刷新，如果正在刷新，直接返回
        if refreshView.refreshState == .WillRefresh{
            return
        }
        /// 设置刷新视图状态
        refreshView.refreshState = .WillRefresh
        /// 调整表格的间距
        var inset = sv.contentInset
        inset.top += QYPReshOffset
        sv.contentInset = inset
        
        // 设置刷新控件俯视图高度
        refreshView.paraentViewHeight = QYPReshOffset
        
    }
    //结束刷新
    func endRefreshing(){
        print("结束刷新")
        guard let sv = scrollview else {
            return
        }
        ///判断是否正在刷新，如果不是，直接返回
        if refreshView.refreshState != .WillRefresh{
            return
        }
        
        /// 恢复刷新视图的状态
        refreshView.refreshState = .Normal
        /// 恢复表格视图的conteninset
        var inset = sv.contentInset
        inset.top -= QYPReshOffset
        sv.contentInset = inset
    }

}
extension QYPRefreshControl{
    func setupUI(){
//        backgroundColor = UIColor.orange
        /// 设置超出边界不显示
        //  clipsToBounds = true
        /// 添加刷新视图 - 从xib家中出来，默认是xib中指定的宽高
        addSubview(refreshView)
        /// 自动布局 --- 设置xib控件自动布局，需要指定xib的宽高约束
        /// 提示。。iOS程序员，一定要会用原色的写法，
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
    }
}
