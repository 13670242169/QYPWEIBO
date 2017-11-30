//
//  JYFunViewModelData.swift
//  JYFarmSwift
//
//  Created by 高级iOS开发 on 2017/11/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import YYModel
class JYFunViewModelData: NSObject {
    
    var modeArray = [JYFunViewModel]()
    
    func getFunViewData(){
        JYNetWorking.shared.handlerCategoryData(method: .GET, parameters: [:]) { (isSuccess, json) in
            guard let array = json["data"] as? [[String:AnyObject]] else {
                return
            }
            print(json)
            var arr = [JYFunViewModel]()
            for dict in array{
                print(dict)
                let model = JYFunViewModel()
                model.yy_modelSet(with: dict)
                print(model.id)
                print(model.child)
                arr.append(model)
            }
            self.modeArray = arr
            print(self.modeArray.count)
        }
    }
}
