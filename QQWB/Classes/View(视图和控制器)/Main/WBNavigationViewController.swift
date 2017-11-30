//
//  WBNavigationViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/12.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏默认的navigationbar
        navigationBar.isHidden = true
    }
    //重写push方法以后所有的只要是push的方法都会走这个方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print(viewController)
        //如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if self.childViewControllers.count > 0{
            //隐藏底部的tabbar
            viewController.hidesBottomBarWhenPushed = true
            var title = "返回"
            if childViewControllers.count == 1 {
                title = childViewControllers.first?.title ?? "返回"
            }
            let vc = viewController as! WBBaseViewController
            vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(back))
        }  
        super.pushViewController(viewController, animated: true)
    }
    @objc func back(){
        popViewController(animated: true)
    }
}
