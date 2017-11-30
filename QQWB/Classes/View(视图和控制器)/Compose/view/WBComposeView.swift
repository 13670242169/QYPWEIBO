
//
//  WBComposeView.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/11/7.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBComposeView: UITextView {
    lazy var placeholderLabel = UILabel()
    override func awakeFromNib() {
        setupUI()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func textChanged(n:Notification){
        // 如果有文本
        self.placeholderLabel.isHidden = self.hasText
    }
}
extension WBComposeView:UITextViewDelegate{
    // 测试代理后设置的有效,代理的原理是一对一,后设置的代理覆盖前面的代理
//    func textViewDidChange(_ textView: UITextView) {
//        print("哈哈")
//    }
}
extension WBComposeView{
    func setupUI(){
        // 0.通知
        // 通知一堆多,如果其他空间监听当前文本视图,不会影响
        // 但是如果使用代理,其他控件无法使用代理监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        //1.设置占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        // MARK:- 测试代理
//        self.delegate = self
    }
}
