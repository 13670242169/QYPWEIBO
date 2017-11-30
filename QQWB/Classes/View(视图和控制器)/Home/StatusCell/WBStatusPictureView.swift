//
//  WBStatusPictureView.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/10/11.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//
import UIKit
class WBStatusPictureView: UIView {
    var viewModel:WBStatusViewModel?{
        didSet{
            calcViewSize()
            urls = viewModel?.picURLs
        }
    }
    private func calcViewSize(){
        /// 处理宽度
        // 1> 单图,根据配图视图的大小，修改subview【0】的宽度
        if viewModel?.picURLs?.count == 1{
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                           y: WBStatusPictureOutterMargin,
                       width: viewSize.width,
                      height: viewSize.height - WBStatusPictureOutterMargin)
        }else{
            // 2> 多图（无图），回复subview[0] 的宽度，保证九宫格布局的完成
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                           y: WBStatusPictureOutterMargin,
                       width: WBStatusPictureItemWidth,
                      height: WBStatusPictureItemWidth)
        }
        /// 修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    /// 配图视图数组
    private var urls:[WBStatusPicture]?{
        didSet{
            // 1.隐藏所有的imageView
            for v in subviews {
                v.isHidden = true
            }
            // 2.遍历URLs数组,顺序设置头像
            var index = 0
            for url in urls ?? [] {
                // 获得对应的索引imageView
                let iv = subviews[index] as! UIImageView
                // 4张图像
                if index == 1 && urls?.count == 4{
                    index += 1
                }
                 // 设置头像
                 iv.cz_setImage(urlString: url.thumbnail_pic, placehoderImage: nil)
                // 显示头像
                iv.isHidden = false
                index += 1
            }
        }
    }
    @IBOutlet weak var heightCons :NSLayoutConstraint!
    override func awakeFromNib() {
        setupUI()
    }
}
extension WBStatusPictureView{
    /// 1.cell中所有的控件都是提前准备好
    /// 2 。设置的时候，根据数据决定是否显示
    /// 3. 不要动态创建控件
    func setupUI(){
        backgroundColor = superview?.backgroundColor
        // 超出边界的内容
        clipsToBounds = true
        let count = 3
        let rect = CGRect(x: 0,
                          y: WBStatusPictureOutterMargin,
                          width: WBStatusPictureItemWidth,
                          height: WBStatusPictureItemWidth)
        for i in 0..<count * count {
            let iv = UIImageView()
            // 设置contentMode /// 图像就不会变形
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            // 行 -> Y
            let row = CGFloat(i / count)
            // 列 -> x
            let col = CGFloat(i % count)
            iv.frame = rect.offsetBy(dx: col * (WBStatusPictureItemWidth + WBStatusPictureInnerMarghin), dy: row * (WBStatusPictureItemWidth + WBStatusPictureInnerMarghin))
            addSubview(iv)
        }
    }
}
