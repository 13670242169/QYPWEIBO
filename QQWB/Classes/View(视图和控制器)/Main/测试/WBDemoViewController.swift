//
//  WBDemoViewController.swift
//  QQWB
//
//  Created by 花花 on 2017/9/13.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//  项目好像已经提交上去了

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //这里用一个？？ 0 的作用就是去掉了可选的option
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"

    }
    @objc func showNext(){
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension WBDemoViewController{
    override func setupUI() {
        super.setupUI()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
