//
//  WBMainViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/12.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import SVProgressHUD
///主控制器
class WBMainViewController: UITabBarController {
    lazy var composeButton:UIButton = UIButton()
    //定时器
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChileControllers()
        setuoComposeButton()
        setupTime()
        setupAnimat()
        setupNewFeatureViews()

        //设置背景颜色撰写按钮
        composeButton.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .normal)
        composeButton.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: .normal)

        //设置代理
        delegate = self

        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    deinit {
        //销毁时针
         timer?.invalidate()

        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    //使用代码控制设备的方向，可以在需要横屏的时候单独处理
    //设置支持的方向之后，当前的控制器，及子控制器都会遵守这个方向
    //如果播放视频都是model展现的
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    @objc func userLogin(n:NSNotification){

        var when = DispatchTime.now()
        if n.object != nil{
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.showInfo(withStatus: "用户登录超时,请重新登录")
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let vc = WBOAuthViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }


    }
    /// 撰写微博
    @objc func composeStatus(){
        // FIXME 0>判断是否登录
        
        // 2> 实例化视图
        let v = WBComposeType.composeView()
        
        // 2> 显示视图 !!!!! 注意闭包的循环引用
        v.show { [weak v](clsName) in
            print(clsName)
            // 展现撰写微博控制器
           
            guard let clsname = clsName ,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsname) as? UIViewController.Type else{
                v?.removeFromSuperview()
                return
            }
            let vc = cls.init()
            
            let nav = UINavigationController(rootViewController: vc)
            
            self.present(nav, animated: true){
                v?.removeFromSuperview()
            }
        }
    }
    //这里打算实现tabbar的动画效果转场
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupAnimat()
//    }
}

// MARK: - 新特性视图
extension WBMainViewController{
    fileprivate func setupNewFeatureViews(){
        //0.判断是否登录
        if !WBNetworkManager.shared.userLogon{
            return
        }
        //1.如果跟新显示新特性,否则显示欢迎
        let v = isNewVersion ? WBNerFeatureView.nerFeatureView(): WBWelComeView.welcomeView()
        //2.添加视图
        v.frame = view.bounds

        view.addSubview(v)
    }

    //extension中可以有计算型属性,不会占用存储空间
    //构造函数:给属性分配空间
    fileprivate var isNewVersion:Bool{
        //1.取到当前版本号

//        print(Bundle.main.infoDictionary)
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        //2.获取保存在"document"版本号
        let path:String = ("version" as NSString).cz_appendDocumentDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        print("沙盒版本" + sandboxVersion)
        //将版本号保存到沙盒
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)

        //返回两个版本号是否相同
        return currentVersion != sandboxVersion

//        return currentVersion == sandboxVersion
    }
}

// MARK: - UITabBarControllerDelegate
extension WBMainViewController:UITabBarControllerDelegate{

    /// 将要选tabbar  ...利用代理方法解决+号按钮穿帮问题(容错点)
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController description
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到\(viewController)")
        //1.获取控制器在数组中的索引
        let index = (childViewControllers as NSArray).index(of: viewController)
        //2.获取当前索引
        if selectedIndex == 0 && index == selectedIndex{
            print("点击首页")
            //3让表格滚的那个到顶部
            //获取到控制器
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            //滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x:0,y: -64), animated: true)
            //4>刷新表格
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                vc.loadData()
                self.updataTimer()

            })
        }
        //判断目标控制器是否是viewcontroller....同时这里也可以解决掉容错点问题,w也就不要-1
        return !viewController.isMember(of: UIViewController.self)
    }
}
// MARK: - 时针相关方法
extension WBMainViewController{
    func setupTime(){
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(updataTimer), userInfo: nil, repeats: true)
    }
    //定时器触发方法
    @objc func updataTimer(){
        if !WBNetworkManager.shared.userLogon{
            return
        }
        WBNetworkManager.shared.unreadCount { (count) in
            //设置tabbar的bageNumer
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            //设置app的bageNumber
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}
// MARK: - 实现tabbar的动画效果转场
extension WBMainViewController{
    func setupAnimat(){
        for ctrl in self.tabBar.subviews {
            let ctr = ctrl as! UIControl
            if ctr.isKind(of: NSClassFromString("UITabBarButton")!) {
                ctr.addTarget(self, action: #selector(self.tabBarButtonClick(ctr:)), for: .touchUpInside)
            }
        }
    }
    func tabBarButtonClick(ctr:UIControl){
        let imageView = UIView()
        let label = UIView()
        self.addView(view: imageView, ctrl: ctr, classString: "UITabBarSwappableImageView")
        self.addView(view: label, ctrl: ctr, classString: "UITabBarButtonLabel")
    }
    /*
     　transform.rotation.x 围绕x轴翻转 参数：角度 angle2Radian(4)
     　transform.rotation.y 围绕y轴翻转 参数：同上
     　transform.rotation.z 围绕z轴翻转 参数：同上
     　transform.rotation 默认围绕z轴
     　transform.scale.x x方向缩放 参数：缩放比例 1.5
     　transform.scale.y y方向缩放 参数：同上
     　transform.scale.z z方向缩放 参数：同上
     　transform.scale 所有方向缩放 参数：同上
     　transform.translation.x x方向移动 参数：x轴上的坐标 100
     　transform.translation.y x方向移动 参数：y轴上的坐标
     　transform.translation.z x方向移动 参数：z轴上的坐标
     　transform.translation 移动 参数：移动到的点 （100，100）
     　opacity 透明度 参数：透明度 0.5
     　backgroundColor 背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
     　cornerRadius 圆角 参数：圆角半径 5
     　borderWidth 边框宽度 参数：边框宽度 5
     　bounds 大小 参数：CGRect
     　contents 内容 参数：CGImage
     　contentsRect 可视内容 参数：CGRect 值是0～1之间的小数
     　hidden 是否隐藏
     　position
     　shadowColor
     　shadowOffset
     　shadowOpacity
     　shadowRadius
     */
    func addView(view:UIView ,ctrl:UIControl,classString:String){
        for view in ctrl.subviews {
            if view.isKind(of: NSClassFromString(classString)!){
                //转场
                let anim:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")//放大path
                anim.values = [1.0,1.3,0.9,1.15,0.95,1.02,1.0]//放大倍数
//                let anim:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.y")//旋转path
//                anim.values = [0, M_PI_2,M_PI,M_PI * 2]//旋转倍数
                anim.duration = 0.4
                anim.calculationMode = kCAAnimationCubic
                view.layer.add(anim, forKey: "playTransitionAnimation")
            }
        }
    }
}
// MARK: - 设置自控制器
extension WBMainViewController {
    func setuoComposeButton(){
        tabBar.addSubview(composeButton)
        //计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count
        //CGRextInset 正数向内缩进，负数向外扩张
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0  )
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
     func setupChileControllers(){
        //获取沙河的路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        //加载 data
        var data = NSData(contentsOfFile: jsonPath)
        
        if data == nil{
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        
        //从本地bunds加载json
        guard let array = try? JSONSerialization.jsonObject(with: (data as Data?)!, options: []) as! [[String:Any]]
        else {
            return
        }
        
//        //设置tabbar的控制器和对用的imageName和title
//        let array:[[String:Any]] = [
//            ["clsName":"WBHomeViewController","title":"首页","imageName":"home","visitorInfo":["imageName":"","message":"我是一个小小小小小小鸟"]
//            ],
//            ["clsName":"WBMessageViewController","title":"消息","imageName":"message_center","visitorInfo":["imageName":"visitordiscover_image_message","message":"我要飞得更加的高"]
//            ],
//            ["clsName":"UIViewController"
//            ],
//            ["clsName":"WBDiscoverViewController","title":"发现","imageName":"discover","visitorInfo":["imageName":"visitordiscover_image_message","message":"你是傻逼吗"]
//            ],
//            ["clsName":"WBProfileViewController","title":"我","imageName":"profile","visitorInfo":["imageName":"visitordiscover_image_profile","message":"我在开心的开发学习"]
//            ],
//        ]
//        
        //数组-》json
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
//        (data as NSData).write(toFile: "/Users/gaojiioskaifa/Desktop/demo.json", atomically: true)
        
        
        //测试数据格式对不对
//        (array as NSArray).write(toFile: "/Users/gaojiioskaifa/Desktop/demo.plist", atomically: true)
        var arrayM = [UIViewController]()
        for dict in array {
            //调用方法，获取到每一个意见设置好了的nav并且将他添加到数组里面
            arrayM.append(controller(dict:dict as [String : AnyObject]))
        }
        // 设置所有的子控制器
        viewControllers = arrayM
    }
    private func controller(dict:[String:AnyObject]) -> UIViewController{
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String//获取命名空间
        //1.获取字典里面的内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(namespace + "." + clsName) as? WBBaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String:String]
            else {
            return UIViewController()
        }
        
        //将对应的控制器字符串通过获取到的命名空间，将其转化为控制器类型
        let vc = cls.init()
        vc.title = title
        //设置访客视图的信息
        vc.visitorInfo = visitorDict
        vc.tabBarItem.image = UIImage(named:"tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named:"tabbar_" + imageName + "_highlighted")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //设置tabbar的标题颜色（大小）
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .highlighted)
        //系统默认是12号字UIControlState(rawValue:0)就是等于normal
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: UIControlState(rawValue:0))
        let nvc = WBNavigationViewController.init(rootViewController: vc)
        return nvc
    }

}

