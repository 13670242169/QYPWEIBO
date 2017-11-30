//
//  WBStatusViewModel.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/25.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import Foundation
//单条微博的视图模型
/*CustomStringConvertible
 如果没有任何父类，如果希望在开发中调试，输出调试信息，需要
 1.遵守CustomStringConvertible
 2.实现 description计算型属性
 .关于表格的性能优化
    - 尽量少计算，所有需要的素材提前计算好
    - 控件上不要设置图标圆角半径，所有的图标渲染的属性，都要注意
    - 不要动态创建控件，所有需要的控件，都要提前创建好，在现实的时候，根据数据隐藏、显示
    - cell中控件的层次越少越好，数量越少越好
 */
class WBStatusViewModel:CustomStringConvertible{
    //微博模型
    var status:WBStatus
    
    ///会员图标 - 存储型属性（用内存换cpu）
    var memberIcon:UIImage?
    //认证类型
    //认证类型-1没有认证 0 认证用户，235企业认证，220达人
    var vipIcon:UIImage?
    ///转发文字
    var retweetedStr:String?
    ///评论文字
    var commentStr:String?
    ///点赞文字
    var likeStr:String?
    
    /// 来至微博
    var sourceStr:String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    /// 如果是被转发的微博，原创微博一定没有图
    var picURLs:[WBStatusPicture]?{
        // 如果有被转发微博，返回被转发微博的配图
        // 如果没有被转发微博，返回原创微博的配图
        /// 如果都没有返回nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls 
    }
    /// 微博正文的属性文本
    var statusAttrText:NSAttributedString?
    /// 被转发微博的文字
    var retweetedAttrText:NSAttributedString?
    
    /// 行高
    var rowHeight:CGFloat = 0
    /// 构造函数
    ///
    /// - Parameter model: 微博视图模型
    init(model:WBStatus) {
        self.status = model
        //直接计算出会员图标、会员等级0-6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7{
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named:imageName)
        }
        //认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named:"avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named:"avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named:"avatar_grassroot")
        default:
            break
        }
        //设置底部计算
        //测试随机生成一个10万
//        model.reposts_count = Int(arc4random_uniform(100000))
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comment_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes, defaultStr: "点赞")
        
        /// 计算配图大小，有原创的计算原创的，有转发的就计算转发的
        
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        /// 设置被转发微博的文字
        let rText = "@" + (status.retweeted_status?.user?.screen_name ?? "")
            + ":"
            + (status.retweeted_status?.text ?? "")
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        // 微博正文的属性文本
        statusAttrText = YWEmoticonManager.shared.emoticonString(string: model.text ?? "" ,font: originalFont)
        
        retweetedAttrText = YWEmoticonManager.shared.emoticonString(string: rText,font: retweetedFont)
        /// 计算行高
        updateRowHeight()
        
        // 设置sourceStr
        sourceStr = "来自" + (model.source?.qyp_href()?.text ?? "")
    }
   
    var description: String{
        return status.description
    }
    /// 根据当前的视图模型内容计算行高
    func updateRowHeight(){
        let margin:CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolbarHeight:CGFloat = 35
        
        var height:CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        // 1.计算顶部位置
        height = 2 * margin + iconHeight + margin
        
        //2.正文高度
        if let text = statusAttrText{
            height += text.boundingRect(with: viewSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin], context: nil).height
            
        }
        // 3.判断是否转发微博
        if status.retweeted_status != nil{
            height += 2 * margin
            
            //转发文本的高度 -- 一定用retweetedText，因为拼接了@ ：
            if let text = retweetedAttrText{
                // 根据属性文本计算高度
                height += text.boundingRect(with: viewSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin], context: nil).height
//                height += (text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName:retweetedFont], context: nil).height
            }
        }
        // 4.配图视图
        height += pictureViewSize.height
        
        height += margin
        
        // 5底部工具栏
        height += toolbarHeight
        
        // 6.使用属性记录
        rowHeight = height
        
    }
    /// 计算配图视图的大小
    ///
    /// - Parameter count: 配图视图的数量
    /// - Returns: 配图视图代销
    private func calcPictureViewSize(count:Int?) ->CGSize{
        if count == 0 || count == nil {
            return CGSize()
        }
        //1.计算配图视图的宽度
        // 2 计算高度
        // 1》 根据count 知道函数 1~9
        let row = (count! - 1)/3 + 1
        // 2》 更加行数算高度
        var height = WBStatusPictureOutterMargin
        height += CGFloat(row) * WBStatusPictureItemWidth
        height += CGFloat(row - 1) * WBStatusPictureInnerMarghin
        return CGSize(width:WBStatusPictureWidth,height:height)
    }
    /// 给定一个数字，返回对应的描述结果
    ///
    /// - Returns: 描述结果
    ///
    ///   - count: 数字
    ///   - defaultStr: 默认字符串，转发、评论。赞
    private func countString(count:Int ,defaultStr:String)->String{
        if count == 0{
            return defaultStr
        }
        if count < 10000{
            return count.description
        }
        return String(format:"%.02f 万",Double(count)/10000)
    }
    /// 新浪微博支持  长微博  有的时候有特别长，长到宽度只有1个点
    func updateSingleImageSize(image:UIImage){
        
        var size = image.size
        
        // 过宽图像处理
        let maxWidth:CGFloat = 300
        let minWidth:CGFloat = 40
        if size.width > maxWidth{
            //设置最大宽度
            size.width = maxWidth
            // 等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        // 过宰图像处理
        if size.width < minWidth {
            size.width = maxWidth
            // 要特殊处理高度，否则高度太大，会影响用户体验
            size.height = size.width * image.size.height / image.size.width/4
        }
        
        // 特列：有限头像本身就是很窄，很长-》定义一个minHeight，思路同上
        // 在工作中，如果看到代码中有些疑惑的分支处理
        
        //注意，尺寸需要增加顶部12个点，便于布局
        size.height += WBStatusPictureOutterMargin
        
        // 重新设置配图视图大小
        pictureViewSize = size
        // 更新行高
        updateRowHeight()
    }
}
