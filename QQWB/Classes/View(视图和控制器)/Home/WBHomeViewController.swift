//
//  WBHomeViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/12.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
//原创id
private let originalcellId = "originalcellId"
//被转发微博id
private let retweetedcellId = "retweetedcellId"
class WBHomeViewController: WBBaseViewController {
    lazy var listViewModel = WBStatusListModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadData() {
        //print("准备刷新最后一条数据\(String(describing: self.listViewModel.statusList.last?.text))")
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess,shouldRefresh) in
            print("请求数据成功\(isSuccess)，是否需要刷新\(shouldRefresh)")
            print("发生网络请求,已经刷新表格")
            self.isPullup = false
            //结束刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                self.refreshControl?.endRefreshing()
            })
            //刷新
            self.tableView?.reloadData()
        }
    }
    @objc func showFriends(){
        let demo = WBDemoViewController()
        //push的动作是nav
        navigationController?.pushViewController(demo, animated: true)
    }
}
//MARK: - 表格数据源方法,具体的数据源方法 ／*实现*／，不需要super
extension WBHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /// 1.取出视图模型，根据视图模型判断可重用cell
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellId = (viewModel.status.retweeted_status != nil) ? retweetedcellId : originalcellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        cell.viewModel = viewModel
        return cell
    }
    // 这里是用到的缓存行高，需要将xib里面的底部约束设置为equle
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1. 根据indexPath获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        // 2.返回计算好的行高
        return vm.rowHeight
    }
}
// MARK: - 设置界面
extension WBHomeViewController{
    override func setupTableView() {
        super.setupTableView()
        //设置导航栏无法高亮
        //navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        //自定义可以高亮的导航栏方法在uibarbutton的extensions里面
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalcellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedcellId)
        //设置行高(自定行高)
//        tableView?.rowHeight = UITableViewAutomaticDimension
        //设置预估行高
        tableView?.estimatedRowHeight = 300
        //去掉分割线
        tableView?.separatorStyle = .none
        setuptitle()
    }
    //设置导航栏标签
    func setuptitle(){
        let titlebtn = WBNetworkManager.shared.userAccount.screen_name
        let button = WBTitleButton(title: titlebtn!)
        navItem.titleView = button
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
        button.isSelected = true
    }
    @objc func clickTitleButton(btn:UIButton){
        //设置选中
        btn.isSelected = !btn.isSelected
    }
}
