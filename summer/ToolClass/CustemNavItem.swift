//
//  CustemNavItem.swift
//  summer
//
//  Created by FangLin on 2/13/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
@objc(CustemBBI)
protocol CustemBBI : NSObjectProtocol {
    func BBIdidClickWithName(infoStr:String)
}

public class CustemNavItem: UIBarButtonItem {
    
    weak var myDelegate : CustemBBI?
    var infoStr : String?
   
    func initWithImage(image: UIImage, infoStr: String) -> CustemNavItem! {
        let imageView = UIImageView(frame:CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.isUserInteractionEnabled = true
        imageView.image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let BBI = CustemNavItem(customView:imageView)
        let tap = UITapGestureRecognizer(target: BBI, action:#selector(BBIdidClick))
        imageView.addGestureRecognizer(tap)
        BBI.infoStr = infoStr
        return BBI
    }
    
    func initWithString(str: String, target: CustemBBI, infoStr: String) -> CustemNavItem! {
        let btn = UIButton(type:.custom)
        btn.setTitle(str, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 40)
        let BBI = CustemNavItem(customView:btn)
        btn.addTarget(BBI, action: #selector(BBIdidClick), for: .touchUpInside)
        BBI.myDelegate = target
        BBI.infoStr = infoStr
        return BBI
    }
    
    func BBIdidClick() {
        self.myDelegate?.BBIdidClickWithName(infoStr: self.infoStr!)
    }
    
}


