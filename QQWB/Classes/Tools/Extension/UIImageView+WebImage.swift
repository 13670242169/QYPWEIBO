//
//  UIImageView+WebImage.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/26.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import SDWebImage

extension UIImageView{
    
    /// 隔离sdWebImage设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placehoderImage: 占位图片
    /// - isAvatar是否头像
    func cz_setImage(urlString:String?,placehoderImage:UIImage?,isAvatar:Bool = false){
        guard let urlStirng = urlString,
            let url = URL(string:urlStirng) else {
            //设置占位图片
            image = placehoderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placehoderImage, options: []) { [weak self](image, _, _, _) in
            
            // 完成回调 判断是否是头像
            if isAvatar{
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
            
        }
    }
    
    
}
