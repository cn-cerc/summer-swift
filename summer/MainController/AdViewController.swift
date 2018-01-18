//
//  AdViewController.swift
//  summer
//
//  Created by 王雨 on 2018/1/2.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit
//MARK: - 定义协议
protocol StartAppDelegate : class {
    func startApp()
    
}
class AdViewController: UIViewController {
    /**存放图片的数组*/
    fileprivate lazy var images = [String]()
    /**滑动控制器*/
    var scrollView : UIScrollView? = UIScrollView()
    /**图片页码*/
    var pageControl : UIPageControl?
    /** 4秒的定时器 */
    var timer : Timer?
    /** 跳过按钮 */
    var skipButton : UIButton?
    /** 协议 */
    weak var delegate : StartAppDelegate?
    /** 工具类 */
    var adTool : AdOnlineTool? = AdOnlineTool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - 设置UI界面
extension AdViewController {
    func setupUI() {
        setupScrollView()
    }
}
//MARK: - 初始化scrollview
extension AdViewController {
    fileprivate func setupScrollView() {
        scrollView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollView?.delegate = self
        scrollView?.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView!)
        //给scrollview添加照片
        let adImages : [UIImage]? = adTool?.getImages(type: .PhotoTypeAd) as? [UIImage]
        let adImageURLs : [String]? = adTool?.getAdImageURLs() as? [String]
        let imageWidth = scrollView?.frame.size.width
        let imageHeight = scrollView?.frame.size.height
        for i in 0..<adImageURLs!.count {
            let filePath = adImageURLs![i]
            let imageData = NSData.init(contentsOfFile: filePath)
            let imageType : String = adTool!.contentTypeForImageData(imageData!)
            let imageView = UIImageView.init()
            imageView.frame = CGRect(x: CGFloat(i)*imageWidth!, y: 0, width: imageWidth!, height: imageHeight!)
            imageView.isUserInteractionEnabled = true
            imageView.image = adImages?[i]
            scrollView?.addSubview(imageView)
            if imageType == "gif" {
                setGifImageWithImageView(gifImgPath: filePath, imageView: imageView)
            }else {
                imageView.image = UIImage.init(contentsOfFile: filePath)
            }
            if i == 0 && (adImageURLs?.count)! > 1{
                setupSkipButton(imageView)
            }
            if i == (adImages?.count)! - 1 {
                //在最后一张图片上添加开始按钮
                setupStartButton(imageView)
            }
        }
        
        //设置其他属性
        scrollView?.contentSize = CGSize(width: imageWidth! * CGFloat(adImages!.count), height: 0)
        scrollView?.bounces = false
        scrollView?.isPagingEnabled = true
        //图片数量超过一张时添加一个pagecontrol
        if adImages!.count > 1 {
            pageControl = UIPageControl.init()
            let pageControlW : CGFloat = 150
            let pageControlH : CGFloat = 20
            let pageControlX : CGFloat = (view.frame.size.width - 150) / 2
            let pageControlY : CGFloat =  view.frame.size.height - 30
            pageControl?.frame = CGRect(x: pageControlX, y: pageControlY, width: pageControlW, height: pageControlH)
            pageControl?.currentPageIndicatorTintColor = UIColor.white
            pageControl?.pageIndicatorTintColor = UIColor.init(white: 1.0, alpha: 0.3)
            pageControl?.numberOfPages = adImages!.count
            pageControl?.currentPage = 0
            //view.addSubview(pageControl!)
        }
    }

}
extension AdViewController {
    //MARK: - 添加跳过按钮
    fileprivate func setupSkipButton(_ imageView : UIImageView) {
        let skipButton = UIButton.init(type: .custom)
        skipButton.frame = CGRect(x: SCREEN_WIDTH-SCREEN_WIDTH/4, y: 20, width: SCREEN_WIDTH/4-10, height: 20)
        skipButton.setTitle("跳过", for: .normal)
        skipButton.setTitleColor(UIColor.black, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        skipButton.layer.borderWidth = 1.0
        skipButton.layer.borderColor = UIColor.black.cgColor
        skipButton.layer.cornerRadius = 10.0
        skipButton.layer.masksToBounds = true
        imageView.addSubview(skipButton)
    }
    
    fileprivate func setupStartButton(_ imageView : UIImageView) {
        //1.添加开始按钮
        let startBtn = UIButton.init(type: .custom)
        //2.设置按钮属性
        let startBtnY : CGFloat = 20
        let startBtnW : CGFloat = SCREEN_WIDTH/4 - 10
        let startBtnH : CGFloat = 20;
        let startBtnX : CGFloat = SCREEN_WIDTH-SCREEN_WIDTH/4
        startBtn.frame = CGRect(x: startBtnX, y: startBtnY, width: startBtnW, height: startBtnH)
        startBtn.setBackgroundImage(UIImage.init(named: "login"), for: .normal)
        startBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
        startBtn.setTitle("进入系统", for: .normal)
        startBtn.setTitleColor(UIColor.black, for: .normal)
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        startBtn.layer.borderWidth = 1.0
        startBtn.layer.borderColor = UIColor.black.cgColor
        startBtn.layer.cornerRadius = 10.0
        startBtn.layer.masksToBounds = true
        imageView.addSubview(startBtn)
        
    }
    
}

extension AdViewController {
    fileprivate func setGifImageWithImageView(gifImgPath : String, imageView : UIImageView) {
        //1.获取gif的数据
        let source : CGImageSource = CGImageSourceCreateWithURL(URL.init(fileURLWithPath: gifImgPath) as CFURL, nil)!
        //2.获取gif中图片的个数
        let count : size_t = CGImageSourceGetCount(source)
        var images : [UIImage]?
        for i in 0..<count {
            let image : CGImageSource = CGImageSourceCreateImageAtIndex(source, i, nil) as! CGImageSource
            images?.append(UIImage.init(cgImage: image as! CGImage))
        }
        imageView.animationImages = images
        imageView.animationDuration = 3.0
        imageView.animationRepeatCount = Int(MAXFLOAT)
        imageView.startAnimating()
    }
}

//MARK: - Action
extension AdViewController {
    //开启APP
    @objc fileprivate func start() {
        delegate?.startApp()
    }
    //点击pagecontrol
    @objc fileprivate func change(pageControl: UIPageControl?) {
        let page = pageControl?.currentPage
        var frame : CGRect = self.scrollView!.frame
        frame.origin.y = 0
        frame.origin.x = frame.size.width * CGFloat(page!)
        self.scrollView?.scrollRectToVisible(frame, animated: true)
    }
    //跳过按钮
    @objc fileprivate func skip() {
        start()
    }
}
//MARK: - UIScrollViewDelegate
extension AdViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pagewidth : CGFloat = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pagewidth/2)/pagewidth) + 1)
        pageControl?.currentPage = page
    }
}
extension AdViewController {
    func COLOR_WITH_HEX(_ hex : Int) -> UIColor {
        return UIColor(red: CGFloat(Float(((hex & 0xFF0000) >> 16)) / 255.0), green: CGFloat(Float(((hex & 0xFF00) >> 16)) / 255.0), blue: CGFloat(Float(((hex & 0xFF) >> 16)) / 255.0), alpha: 1.0)
    }
}
