//
//  WBStatusCell.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/25.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

//面试：如何不设置圆角图标：不适用conradise：
//关键点，加一个裁剪路径，路径之后去去绘图，会吐的内容都是被裁剪路径框在里面的，在绘出来

import UIKit

class WBStatusCell: UITableViewCell {
    
    var viewModel:WBStatusViewModel?{
        didSet{
            statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            //用户头像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placehoderImage: UIImage(named:"avatar_default_big"),isAvatar: true)
            //底部工具栏
            toolBar.viewModel = viewModel
            
            /// 配图视图模型
            pictureView.viewModel = viewModel
            /// 配图视图(移动到配图视图里面去了)
//            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            
            // 微博文本
            statusLabel.attributedText = viewModel?.statusAttrText
            
            /// 设置被转发微博的文字
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
            ///设置来源
            sourceLabel.text = viewModel?.sourceStr
        }
    }
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// vip图标
    @IBOutlet weak var vipIconView: UIImageView!
    /// 微博正文
    @IBOutlet weak var statusLabel: UILabel!
    /// 底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    /// 被转发微博的标签 ---- 原创微博没有次控件，一定要用问号
    @IBOutlet weak var retweetedLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染 -- 异步绘制
        self.layer.drawsAsynchronously = true
        // 栅格化 -- 异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是一张图片
        // cell 优化，要尽量减少图层的数量，相当于就是只有一层
        // 停止滚动之后，可以接受监听
        self.layer.shouldRasterize = true
        
        // 使用 “”栅格化，必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
