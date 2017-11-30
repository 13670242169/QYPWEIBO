//
//  WBNerFeatureView.swift
//  QQWB
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit

class WBNerFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func enterStatus(_ sender: Any) {
    }
    class func nerFeatureView() -> WBNerFeatureView{
        let nib = UINib(nibName: "WBNerFeatureView", bundle: nil)

        let v  = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNerFeatureView

        v.frame = UIScreen.main.bounds

        return v
    }

    override func awakeFromNib() {
        //如果是自动布局设置的界面,从xib加载默认600 * 600
        //添加4个新特性
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let imageName = "ad_background"
            let iv = UIImageView(image: UIImage(named:imageName))
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        //指定scroolView的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        //隐藏按钮
        enterButton.isHidden = true

    }
}
extension WBNerFeatureView :UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //1.滚动到最后一屏,让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)

        //2.判断是否最后一页
        if page == scrollView.subviews.count{
            removeFromSuperview()
        }

        //3.如果是倒数第二也,显示按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1.一但滚动，隐藏按钮
        enterButton.isHidden = true
        //2.计算分页控件
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        //3设置分页控件
        pageControl.currentPage = page
        
        //4分页控件隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }


}
