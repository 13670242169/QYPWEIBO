//
//  WBOAuthViewController.swift
//  QQWB
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import SVProgressHUD
//铜鼓网页加载
class WBOAuthViewController: UIViewController {
    lazy var webView = UIWebView()
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    @objc func close(){
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    @objc func autoFill(){
        //准备js // 由于这里使用的是js注入,我把我的小号账户密码也放进去了,这只是小号,方便学习,请不要有任何想法
        let js = "document.getElementById('userId').value='13670242169';" + "document.getElementById('passwd').value='qyp123456';"

        //让weView执行js
        webView.stringByEvaluatingJavaScript(from: js)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectUTI)"


        //url确定要访问的资源
        guard let url = URL(string: urlString) else {
            return
        }
        //建立请求
        let request = URLRequest(url:url)

        //加载请求
        webView.loadRequest(request)
        webView.delegate = self
    }


}
extension WBOAuthViewController:UIWebViewDelegate{
    /// 监听webView加载页面的请求代理
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns:是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //确定思路
        //1,如果请求包含http://baidu.com不加载页面/否则加载页面
        //
        if request.url?.absoluteString.hasPrefix(WBRedirectUTI) == false{
            return true
        }
        print("加载请求----\(String(describing: request.url?.absoluteString))")
        print("加载请求----\(String(describing: request.url?.query))")
        //2.从http://baidu.com回到地址中查询字符串中是否有code=
        if request.url?.query?.hasPrefix("code=") == false{
            print("取消授权")
            close()
            return true
        }
        //3.冲query字符串中去除授权码
        //代码走到这里一定有code=

        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""

        print("获取授权码...\(code)")


        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            print(isSuccess)
            if !isSuccess {
                print("网络请求失败")
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
                print(WBNetworkManager.shared.userAccount.access_token)
                SVProgressHUD.showInfo(withStatus: "登录成功")
                //下一步跳转界面,通过通知发送登录成功消息
                //1>发送通知-不关心有没有监听者
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
                //关闭窗口
                self.close()
            }
        }

        SVProgressHUD.dismiss()

        return false
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}


