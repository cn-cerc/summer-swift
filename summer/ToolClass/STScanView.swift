//
//  STScanView.swift
//  summer
//
//  Created by 王雨 on 2018/1/8.
//  Copyright © 2018年 FangLin. All rights reserved.
//  二维码扫描界面

import UIKit
let leftMargin : CGFloat = 60   //扫描框左间距
//MARK: - 定义STScanView类
class STScanView: UIView {
    fileprivate var lineImageView : UIImageView = UIImageView()
    fileprivate var scale   : CGFloat = 1.0 //二维码和条形码的扫描区域范围
    fileprivate var scanRect : CGRect? //扫描的聚焦区域
    var scanType : STScanType? {
        didSet {//监听扫描类型发生变化的时候（setter）
            if scanType == .STScanTypeQrCode {//二维码
                scale = 1.0
                startAnimating()
            } else {//条形码
                scale = 3.0
                lineImageView.alpha = 0
            }
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    //MARK: - 自定义构造方法
    override init(frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.clear
        lineImageView = UIImageView.init(image : UIImage.init(named: "scan_blue_line"))
        self.addSubview(lineImageView)
    }
    
    //MARK: - 布局子视图
    override func layoutSubviews() {
        let lineImageViewX = leftMargin / scale
        let lineImageViewW = self.frame.size.width - leftMargin * 2
        let lineImageViewY = self.frame.size.height / 2 -  lineImageViewW / (scale * 2)
        lineImageView.frame = CGRect(x: lineImageViewX, y: lineImageViewY, width: lineImageViewW - 4, height: 5)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawScanRect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension STScanView {
    //MARK: - 绘制二维码的扫描区域
    fileprivate func drawScanRect() {
        let left : CGFloat = leftMargin / scale
        let width : CGFloat = self.frame.size.width - 2 * left
        let height : CGFloat = width
        let maxX : CGFloat = self.frame.size.width - left
        let minY : CGFloat = self.frame.size.height / 2 - height / (2 * scale)
        let maxY : CGFloat = minY + height / scale
        //使用图形上下文绘制张正方形框
        let context = UIGraphicsGetCurrentContext()
        //设置非扫描区域的背景颜色
        context?.setFillColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor)
        let topRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: minY)
        let bottomRect = CGRect(x: 0, y: maxY, width: self.frame.size.width, height: self.frame.size.height-maxY)
        let leftRect = CGRect(x: 0, y: minY, width: left, height: height / scale)
        let rightRect = CGRect(x: maxX, y: minY, width: left, height: height / scale)
        context?.fill([topRect, bottomRect, leftRect, rightRect])
        context?.strokePath()
        //设置正方形框
        context?.setStrokeColor(UIColor.init(white: 1.0, alpha: 1.0).cgColor)
        let rect = CGRect(x: left, y: minY, width: width, height: height / scale)
        context?.addRect(rect)
        context?.strokePath()
        //设置正方形框的4个角
        let angleWidth : CGFloat = 15
        let angleHeight : CGFloat = 15
        let lineWidth : CGFloat = 4
        let margin = lineWidth / 3
        let leftX = left - margin
        let topY = minY - margin
        let rightX = maxX + margin
        let bottomY = maxY + margin
        context?.move(to: CGPoint(x: leftX, y: topY))
        context?.addLine(to: CGPoint(x: leftX + angleWidth, y: topY))
        context?.move(to: CGPoint(x: leftX, y: topY))
        context?.addLine(to: CGPoint(x: leftX, y: topY + angleHeight))
        
        context?.move(to: CGPoint(x: rightX, y: topY))
        context?.addLine(to: CGPoint(x: rightX - angleWidth, y: topY))
        context?.move(to: CGPoint(x: rightX, y: topY))
        context?.addLine(to: CGPoint(x: rightX, y: topY + angleHeight))
        
        context?.move(to: CGPoint(x: leftX, y: bottomY))
        context?.addLine(to: CGPoint(x: leftX + angleWidth, y: bottomY))
        context?.move(to: CGPoint(x: leftX, y: bottomY))
        context?.addLine(to: CGPoint(x: leftX, y: bottomY - angleHeight))
        
        context?.move(to: CGPoint(x: rightX, y: bottomY))
        context?.addLine(to: CGPoint(x: rightX - angleWidth, y: bottomY))
        context?.move(to: CGPoint(x: rightX, y: bottomY))
        context?.addLine(to: CGPoint(x: rightX, y: bottomY - angleHeight))
        
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.setLineCap(.round)
        context?.setLineWidth(lineWidth)
        context?.strokePath()
    }
    //MARK: - 开始扫描动画
    fileprivate func startAnimating() {
        let left : CGFloat = leftMargin / scale
        let width : CGFloat = self.frame.size.width - 2 * left
        let height : CGFloat = width
        let minY : CGFloat = self.frame.size.height / 2 - height / (2 * scale)
        let maxY : CGFloat = minY + height / scale
        lineImageView.frame = CGRect(x: left, y: minY + 2, width: width - 4, height: 5)
        lineImageView.alpha = 1
        
        let animation : CABasicAnimation = CABasicAnimation.init(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = height
        animation.duration = 1.5
        animation.repeatCount = MAXFLOAT
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        lineImageView.layer.add(animation, forKey: "position")
        
    }
    //MARK: - 结束扫描动画
    public func stopAnimating()  {
        lineImageView.layer.removeAnimation(forKey: "position/")
    }
}


