  //
//  WeiBoCommon.swift
//  QQWB
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 高级iOS开发. All rights reserved.
//

import Foundation


  let WBAppKey = "1824427535"

  let WBAppSecret = "adec043d5a0b0a5fe7d4b3779845c224"

  let WBRedirectUTI = "http://baidu.com"

//用户需要登录通知
  let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
//用户登录成功通知
  let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"

  ///微博配图视图常量
  // 参数准备
  // 配图视图外侧的间距
  let WBStatusPictureOutterMargin = CGFloat(12)
  // 配图视图内部头像的间距
  let WBStatusPictureInnerMarghin = CGFloat(3)
  // 屏幕的宽度
  let WBStatusPictureWidth = UIScreen.cz_screenWidth() - 2*WBStatusPictureOutterMargin
  // 每个item默认的高度
  let WBStatusPictureItemWidth = (WBStatusPictureWidth - 2 * WBStatusPictureInnerMarghin)/3
  
