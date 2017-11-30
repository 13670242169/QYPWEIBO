//
//  AppDelegate.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/13.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import UserNotifications //iOS10 出来的
import SVProgressHUD
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupAddiyions()

        window = UIWindow()
        window?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        window?.rootViewController = WBMainViewController()
        window?.makeKeyAndVisible()
        //这里放到最后只是去模拟，改到json里面的内容前面主控制器还是加载的上一次的修改后的json，然后淡当代吗运行到这里以后再去服务器加载最新的，，如果有服务器的话这里的调用还是要放在最前面，不然加载的是上一次请求的数据
        loadAppIndo()
        
        return true
    }

}
extension AppDelegate{
    func loadAppIndo(){

        //模拟异步
        DispatchQueue.global().async {
            //1》url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            //2》data
            let data = NSData(contentsOf: url!)
            
            //3>写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
            print(jsonPath)

        }
    }
}
//设置程序额外设置
extension AppDelegate{
    fileprivate func setupAddiyions(){
        //1.设置SVProgressHUD最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        //2.设置网络加载指示器(工具栏里面的小菊花)
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        // #available 是检查设备版本,如果是10.以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound,.carPlay], completionHandler: { (success, error) in
                print("授权成功" + (success ? "成功" : "失败"))
            })
        } else {
            //取得用户显示授权,显示通知[上方的提示条,声音,badgeNumber]
            let notifySettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)

            UIApplication.shared.registerUserNotificationSettings(notifySettings)
        }

    }
}
