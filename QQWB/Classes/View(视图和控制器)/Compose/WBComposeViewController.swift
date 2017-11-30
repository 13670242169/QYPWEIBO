//
//  WBComposeViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/25.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import SVProgressHUD
class WBComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolbar: UIToolbar!
    /// 标题标签-换行的热键,option + 回车
    /// 每行设置选中文本,并且设置属性
    /// 如果要想挑战行间距,可以增加一个空行,设置空行的字体,lineHeight
  
    @IBOutlet var titleLabel: UILabel!
    /// 工具栏底部约束
    @IBOutlet weak var toolbarBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        /// 监听键盘通知
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(keyboadrChanged),
                                       name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                       object: nil)
    }
    @objc func keyboadrChanged(n:Notification){
        print(n.userInfo)
        // 1.目标rect
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
         let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else{
            return
        }
        
        
        /// 2.设置底部约束
         let offset = view.bounds.height  - rect.origin.y

        print(offset)
        /// 3. 更新底部约束
        toolbarBottom.constant = offset
    
        // 4.动画更新约束
        UIView.animate(withDuration: duration) {
            self.view.layoutSubviews()
        }
    }
    // 提高用户体验一出来就显示键盘
    override func viewWillAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    // 退出就关闭键盘
    override func viewWillDisappear(_ animated: Bool) {
        textView.resignFirstResponder()
    }
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }
    
    lazy var sendButton:UIButton = {
        let btn = UIButton()

        btn.setTitle("发布", for: [])
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: [])
        btn.setTitleColor(UIColor.gray, for: .disabled)

        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: [])
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .disabled)

        btn.addTarget(self, action: #selector(postStatus), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 65, height: 35)

        return btn
    }()
    @objc func postStatus(){
        guard let text = textView.text else {
            return
        }
        // 纯文本微博
//        let image:UIImage? = nil
        
        // 有图片的微博
        let image = UIImage(named: "compose_toolbar_picture")
        // 发布微博
        WBNetworkManager.shared.postStatus(text: text, image: image) { (result, isSuccess) in
            print(result)
            // 提示用户
            let message = isSuccess ? "发布成功" : "发布失败"
            // xiu gai zhi shi qi yang shi
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: message)
            // 由于微博这个发布微博的接口出现了问题,这里设置央视而已
            if !isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                })
            }
        }
    }
    /// 切换表情键盘
    @objc func emoticonKeyboard(){
        // textView.inputView 就是文本框的输入视图
        // 如果使用默认的键盘,输入视图位nil
        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
        keyboardView.backgroundColor = UIColor.blue
        
        // 2. 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? keyboardView : nil
        
        // 3.刷新键盘视图
        textView.reloadInputViews()
    }
}

// MARK: - 通知一堆多,代理一对一,,最后设置的代理对象有效...
/// 苹果日常开发中,代理的监听方式最多的
// 代理是发生事件时直接监听方法
// 通知是发生事件时,将通知发送给通知中心!,通知中心在广播通知
// 代理的效率更高
// 如果层次嵌套的比较深就用通知传值
extension WBComposeViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}
fileprivate extension WBComposeViewController{
    func setupUI(){
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setuptoolbar()
    }
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        navigationItem.titleView = titleLabel
        
        sendButton.isEnabled = false
    }
    func setuptoolbar(){
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        // 遍历数组
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            guard let imageName = s["imageName"] else{
                continue
            }
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            // 判断actionName
            if let actionName = s["actionName"] {
                // 给按钮添加监听方法
                 btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            
            // 追加按钮
            items.append(UIBarButtonItem(customView: btn))
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )
        }
        // 删除最后一个堂皇
        items.removeLast()
        toolbar.items = items
        
        
    }
    
    
    
}
