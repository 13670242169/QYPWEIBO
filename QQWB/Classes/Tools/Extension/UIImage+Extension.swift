//
//  UIImage+Extension.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/26.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

extension UIImage{
    /// 创建头像图像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    ///   - linColor:
    /// - Returns: 
    func cz_avatarImage(size:CGSize?,backColor:UIColor = UIColor.white,linColor:UIColor = UIColor.lightGray) ->UIImage?{
        var size = size
        if size == nil{
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        linColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
