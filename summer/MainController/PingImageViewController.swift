//
//  PingImageViewController.swift
//  summer
//
//  Created by FangLin on 17/2/16.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class PingImageViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var imageView:UIImageView?
    var imageStr:String?
    var size:CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        self.view.contentMode = .center
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI, infoStr: "first")
        let data = try! NSURLConnection.sendSynchronousRequest(URLRequest.init(url: URL.init(string: imageStr!)!), returning: nil)
        let image = UIImage.init(data: data as Data)
        if (image != nil) {
            size = image?.size
        }
        self.imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.center = self.view.center
        self.imageView?.sd_setImage(with: URL.init(string: imageStr!), placeholderImage: nil)
        view.addSubview(self.imageView!)
        
        let pinchRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(scaleImage))
        pinchRecognizer.delegate = self
        self.imageView?.isUserInteractionEnabled = true
        self.imageView?.addGestureRecognizer(pinchRecognizer)
        
        //平移
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panView))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.imageView?.addGestureRecognizer(panGesture)
    }
    
    func scaleImage(pinchGestureRecognizer:UIPinchGestureRecognizer) {
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            self.imageView?.transform = (self.imageView?.transform)!.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1
        }
    }
    
    func panView(panGestureRecognizer:UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed {
            let translation = panGestureRecognizer.translation(in: self.imageView?.superview)
            self.imageView?.center = CGPoint.init(x: (self.imageView?.center.x)! + translation.x, y: (self.imageView?.center.y)! + translation.y)
            panGestureRecognizer.setTranslation(.zero, in: self.imageView?.superview)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PingImageViewController:CustemBBI {
    func BBIdidClickWithName(infoStr: String) {
        self.imageView?.isHidden = true
        _ = self.navigationController?.popViewController(animated: true)
    }
}
