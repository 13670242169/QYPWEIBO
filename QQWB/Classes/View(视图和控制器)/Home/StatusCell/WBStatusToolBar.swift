//
//  WBStatusToolBar.swift
//  QQWB
//
//  Created by 高级iOS开发 on 2017/9/26.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import UIKit
import YYModel
class WBStatusToolBar: UIView {

    var viewModel:WBStatusViewModel?{
        didSet{
//            retweetedButton.setTitle("\(String(describing: viewModel?.status.reposts_count))", for: [])
//            commentButton.setTitle("\(String(describing: viewModel?.status.comment_count))", for: [])
//            likeButton.setTitle("\(String(describing: viewModel?.status.attitudes))", for: [])
            retweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }
    //转发
    @IBOutlet weak var retweetedButton: UIButton!
    //评论
    @IBOutlet weak var commentButton: UIButton!
    //点赞
    @IBOutlet weak var likeButton: UIButton!

    override var description: String{
        return yy_modelDescription()
    }
}
