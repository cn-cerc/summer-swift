//
//  CustemNavItem.swift
//  summer
//
//  Created by FangLin on 2/13/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

protocol CustemBBI:class {
    func BBIdidClickWithName(infoStr:String)
}

class CustemNavItem: UIBarButtonItem {
    
    weak var delegate:CustemBBI?
    var infoStr:String?
    
    class func initWithImage(image:UIImage, target:CustemBBI, infoStr:String) -> CustemNavItem! {
        let imageView = UIImageView(frame:CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.isUserInteractionEnabled = true
        imageView.image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let BBI = CustemNavItem(customView:imageView)
        let tap = UITapGestureRecognizer(target: BBI, action:#selector(BBIdidClick))
        imageView.addGestureRecognizer(tap)
        BBI.delegate = target
        BBI.infoStr = infoStr
        return BBI
    }
    
    class func initWithString(str:String, target:CustemBBI, infoStr:String) -> CustemNavItem! {
        let btn = UIButton(type:.custom)
        btn.setTitle(str, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
        let BBI = CustemNavItem(customView:btn)
        btn.addTarget(BBI, action: #selector(BBIdidClick), for: .touchUpInside)
        BBI.delegate = target
        BBI.infoStr = infoStr
        return BBI
    }
    
    func BBIdidClick() {
        self.delegate?.BBIdidClickWithName(infoStr: self.infoStr!)
    }
}


