//
//  WBProfileViewController.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/12.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBProfileViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        WBNetworkManager.shared.userAccount.access_token = nil
        print("修改了token")
    }

}
