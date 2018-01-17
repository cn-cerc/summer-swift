//
//  STPagesCollectionViewCell.swift
//  summer
//
//  Created by 王雨 on 2018/1/16.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit
enum STPagesCollectionViewCellShowState : Int {
    case normal
    case highlight
    case top
    case bottom 
}
class STPagesCollectionViewCell: UICollectionViewCell {
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        scrollView.delegate = self
        return scrollView
    }()
    //属性监听器
    var showState : STPagesCollectionViewCellShowState? {
        didSet {
            let state = showState!
            switch state {
                case .highlight:
                    normalTransform = layer.transform//先记录原来的位置
                    scrollView.isScrollEnabled = false
                    let indexPath = collectionView.indexPath(for: self)!
                    let lineSpacing = pageHeight - 160
                    let moveY = collectionView.contentOffset.y - (pageHeight - lineSpacing) * CGFloat(indexPath.row);
                    let moveTransform = CATransform3DMakeTranslation(0, moveY, 0)
                    layer.transform = moveTransform
                
                case .normal:
                    layer.transform = normalTransform
                    scrollView.isScrollEnabled = true
                
                case .top:
                    normalTransform = layer.transform//先记录原来的位置
                    scrollView.isScrollEnabled = false
                    let moveTransform = CATransform3DMakeTranslation(0, -1 * pageHeight, 0)
                    layer.transform = CATransform3DConcat(normalTransform, moveTransform)
                
                case .bottom:
                    normalTransform = layer.transform//先记录原来的位置
                    scrollView.isScrollEnabled = false
                    let moveTransform = CATransform3DMakeTranslation(0, pageHeight, 0)
                    layer.transform = CATransform3DConcat(CATransform3DIdentity, moveTransform)
                
                default:
                    self.layer.transform = normalTransform
                    scrollView.isScrollEnabled = true
            }
        }
    }
    fileprivate lazy var tapGes : UIGestureRecognizer = {
        let tapGes = UIGestureRecognizer.init(target: self, action: #selector(onTapGes(_:)))
        return tapGes
    }()
    var normalTransform : CATransform3D!
    var normalRect : CGRect!
    var collectionView : UICollectionView!
    lazy var cellContentView : UIView = {
        let cellContentView  = UIView()
        cellContentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return cellContentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = false
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension STPagesCollectionViewCell {
    func setupUI() {
        contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cellContentView)
        self.scrollView.addGestureRecognizer(self.tapGes)
        
    }
}
//
extension STPagesCollectionViewCell {
    @objc func onTapGes(_ sender : UIGestureRecognizer) {
        guard let selectedIndex = collectionView.indexPath(for: self) else{return}
        (collectionView as! STPagesCollectionView).showCellToHighLightAtIndexPath(index: selectedIndex) { (finished : Bool) in
            print("highlight completed")
        }
    }
}


//MARK: - UIScrollViewDelegate
extension STPagesCollectionViewCell : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}
