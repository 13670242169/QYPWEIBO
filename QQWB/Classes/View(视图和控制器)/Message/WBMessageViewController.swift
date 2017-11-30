//
//  WBMessageViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/12.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBMessageViewController: WBBaseViewController {

    var funViewVM = JYFunViewModelData()
    override func viewDidLoad() {
        super.viewDidLoad()
        funViewVM.getFunViewData()

        // Do any additional setup after loading the view.
        WBNetworkManager.shared.userAccount.access_token = "123123"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
