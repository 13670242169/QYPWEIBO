//
//  WBStatusList.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/18.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import Foundation
import SDWebImage
//微博视图模型
/*
 父类的旋转
 -如果类需要使用“kvc”或者字典转模型框架设置对象，类就需要继承自NSObject
 -如果类知识包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：更加轻量级
 -提示：如果使用OC写，一律继承自NSObject即可
 -使命：负责微博的数据处理
 */

class WBStatusListModel{
    //微博视图模型数组懒加载
    lazy var statusList = [WBStatusViewModel]()
    private let  maxPullupTryTimes:Int64 = 3
    private var pullupErrorTimes:Int64 = 0
    
    /// 加载微博数据
    ///
    /// - Parameters:
    ///   - pullup: 是否标记上啦刷新
    ///   - completion: 完成回调【网络请求是否成功】
    func loadStatus(pullup:Bool = false, completion:@escaping (_ success:Bool,_ shouldRefresh:Bool)->()){


        //since_id取出数组中第一条微博的id
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        
        //上啦刷新取出数组的最后一条微博id
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)

        if pullup && pullupErrorTimes > maxPullupTryTimes{
            completion(false,false)
            return
        }

        WBNetworkManager.shared.statusList (since_id: since_id,max_id: max_id){ (list, isSuccess) in
            print(list)
            //0.判断网络请求是否成功
            if !isSuccess {
                //直接回调返回
                completion(false, false)
                return
            }
            
            //1.字典转模型（所有第三方框架都支持所有且套的字典转模型！）
            //1>定义结果可变数组
            var array = [WBStatusViewModel]()
            //2》遍历服务器返回的字典数组，字典转模型
            for dict in list ?? []{
                print("查看\(dict["pic_urls"])")
               //1>创建微博模型
                let status = WBStatus()
                
                //2>使用字典设置模型数值
                status.yy_modelSet(with: dict)
                print(status.comment_count)
                //3》使用‘微博'模型创建’微博视图‘模型
                let viewModel = WBStatusViewModel(model: status)
                
                //4》添加到数组
                array.append(viewModel)
            }
            print("显示\(array.count)多少条\(array)")
            ///下啦刷新请求数据失败(没有刷新到新的数据）
            if array.count == 0{
                
                completion(isSuccess,false)
                self.pullupErrorTimes += 1
            }

            //2.拼接数据
            if pullup{
                //上拉刷新，将数组拼接的最后面
                self.statusList += array
            }else{
               //下拉刷新，家最新的数据放在前面
               self.statusList = array + self.statusList
            }
            //判断上啦刷新刷新的数量
            if pullup && array.count == 0{
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            }else if array.count != 0{
                print(array.count)
                self.cacheSingleImage(list: array,finished: completion)
                //3.完成回调
//                completion(isSuccess,true)
            }
            
            
        }
    }
    /// 缓存本次下载微博数据数组中的单张图像
    /// - 应该缓存完单张图像，并且修改配图的大小之后，再回调，才能够包装表格等比例显示单张图像
    /// - Parameter list: 本次下载的视图模型数组
    private func cacheSingleImage(list:[WBStatusViewModel],finished:@escaping (_ success:Bool,_ shouldRefresh:Bool)->()){
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        // 遍历数组，查找微博数据中有单张图像的，进行缓存
        for vm in list {
            
            // 1》判断图像数量
            if vm.picURLs?.count != 1{
                continue
            }
            // 2> 代码执行到此，数组中有且仅有一张图片
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string:pic) else{
                    
                    continue
            }
            //print("要缓存的 URL 是 \(url)")
            // 3 下载图像
            /*
                 1) downloadImage 是SDWebImage的核心方法
                 2) 图像下载完成之后，会自动保存到沙盒中，文件路径是url 的md5
                 3) 如果沙盒中已经存在缓存头像，后续使用sd 通过url 加载图像，都会加载本地的图像
                 4) 不会发起网络请求，同事，回调方法，同样会调用！
                 5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网络请求
              */
            // 注意点：如果要缓存的头像累计很大，要找后台要接口
            //入组
            group.enter()
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                // 将图像转换成二进制数据
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                    // NSData 是length 属性
                    length += data.count
                    vm.updateSingleImageSize(image: image)
                }
//                出组
                group.leave()
//                print("缓存的图像是\(image) 长度 \(length)")
            })
        }
        // 监听调度组
        group.notify(queue: DispatchQueue.main) {
            print("缓存的图像长度 \(length/1024)K")
            //执行回调必报
            finished(true,true)
        }
    
    }
}
