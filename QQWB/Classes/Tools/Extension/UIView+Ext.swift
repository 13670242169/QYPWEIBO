//
//  UIView+Ext.swift
//  Lease
//
//  Created by Apple on 2017/3/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIView {

    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var top: CGFloat{
    
        get {
            return self.frame.origin.y
        }
        set{
        
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    
    }

    public var bottom: CGFloat{
        
        get {
            return self.frame.origin.y+self.frame.size.height
        }
        set{
            
            var r = self.frame
            r.origin.y = newValue - self.frame.size.height
            self.frame = r
        }
        
    }
    
    public var width: CGFloat{
        
        get {
            return self.frame.size.width
        }
        set{
            
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
        
    }
    
    public var height: CGFloat{
        
        get {
            return self.frame.size.height
        }
        set{
            
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
        
    }
    
}
