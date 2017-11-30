//
//  WBComposeTypeButton.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/20.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var clsName:String?
    class func composeTypeButton(imageName:String,title:String) -> WBComposeTypeButton{
        
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        
        btn.titleLabel.text = title
        
        return btn
    }
}
