//
//  WBBaseViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/12.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
//面试题：OC中支持多继承嘛？？不支持，，解决方案使用代理方法
//class WBBaseViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
// 注意
// 1.extension。中不能有属性
// 2.extension.中不能重写父类 本类 的方法！重新父类的方法是子类的职责，，扩展是对类的扩展
class WBBaseViewController: UIViewController {
    
    //访客视图信息字典
    var visitorInfo:[String:String]?
    //用户登录标记
//    var userLogon = false
    ///表格试图。如果用户没有登陆就不创建
    var tableView:UITableView?
    ///刷新控件
    var refreshControl:QYPRefreshControl?
    ///上拉刷新标记
    var isPullup = false
    lazy var navigationBar = UINavigationBar(frame:CGRect(x:0,y:20,width:UIScreen.main.bounds.size.width,height:44))
    
    //自定义的导航条目 --以后设置导航栏内容统一使用navItem
    lazy var navItem = UINavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        WBNetworkManager.shared.userLogon ? loadData() : ()
        //注册登录成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 遮住
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        v.backgroundColor = UIColor.red
        self.view.addSubview(v)
    }
    override var title: String?{
        didSet{
            navItem.title = title
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //加载数据,具体的实现在子类中
    func loadData(){
        refreshControl?.endRefreshing()
    }
}
// MARK: - 监听访客视图的监听方法
extension WBBaseViewController{

    /// 登录成功
    @objc fileprivate func loginSuccess(){

        print("登录成功")

        //登录前左边的注册按钮,右边的登录按钮
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil

        //更新UI > 将访客视图替换为表格视图
        //需要重新设置view
        //在访问view 的get方法时 view == nil 会调用loadView方法时 -> viewDidload
        view = nil
        //注销通知 -> 重新执行viewDidLoad会再次注册,避免通知会重复注册
        NotificationCenter.default.removeObserver(self)

    }
    @objc func register(){
        print("用户注册")
    }
    @objc func login(){
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: WBUserShouldLoginNotification) , object: nil)
        print("用户登录")
    }
}
// MARK: - 设置界面
extension WBBaseViewController{
    func setupUI(){
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        //取消自动缩进-如果隐藏了导航栏，会缩进20个掉
        automaticallyAdjustsScrollViewInsets = false
        setupNavgationBar()
        WBNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
       
    }
     func setupTableView(){
        tableView = UITableView(frame:view.frame,style:.plain)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        //设置数据源和代理
        tableView?.delegate = self
        tableView?.dataSource = self
        //设置内容缩进
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height , 0, tabBarController?.tabBar.bounds.height ?? 49, 0)

        //修改指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        //设置刷新控件

        ///1.实例化刷新控件
        refreshControl = QYPRefreshControl()
        
        ///2.添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        ///3.添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    // 设置访客视图
    private func setupVisitorView(){
        let visitor = WBVisitorView(frame:view.bounds)
        view.insertSubview(visitor, belowSubview: navigationBar)
        //设置凡客视图信息
        visitor.visitorInfo = visitorInfo
        visitor.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        visitor.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", fontSize: 14, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", fontSize: 14, target: self, action: #selector(login))
    }
    //设置导航条         
    func setupNavgationBar(){
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        //设置navBar的背景颜色
        navigationBar.barTintColor = UIColor.white
        
        //设置文本的颜色
        navigationBar.tintColor = UIColor.red
        //设置标题颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.red]
    }
}
extension WBBaseViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //基类知只是准备方法，子类负责具体的实现
    //子类的数据源方法不需要super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //知识保证没有语法错误
        return UITableViewCell()
    }
    /// cell即将出现代理方法
    ///
    /// - Parameters:
    ///   - tableView:
    ///   - cell:
    ///   - indexPath: 即将出现的cell的indexPath的值
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1.先判断indepath 是否是最后一行
        //indexPath.section最大/indexPath.row最后一行
        //1>row
        let row = indexPath.row
        //2>section
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0{
            return
        }
        //3>最大一section的行数
        let count = tableView.numberOfRows(inSection: section)
        // 如果是最后一行。同时没有开始上拉刷新
        if row == (count - 1) && !isPullup{
            print("开始上拉刷新")
            isPullup = true
            //开始刷新
            loadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
}
