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
    var normalTransform : CATransform3D!
    var normalRect : CGRect!
    var collectionView : UICollectionView!

    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width+1, height: scrollView.frame.size.height)
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    //MARK: - 属性监听器
   
    var showState : STPagesCollectionViewCellShowState? {
        didSet {
                let state = showState!
                switch state {
                case .highlight:
                    self.deleteBtn.isHidden = true
                    self.clickBtn.isHidden = true
                    normalTransform = layer.transform//先记录原来的位置
                    scrollView.isScrollEnabled = false
                    let indexPath = collectionView.indexPath(for: self)!
                    let lineSpacing = pageHeight - 160
                    let moveY = collectionView.contentOffset.y - (pageHeight - lineSpacing) * CGFloat(indexPath.row);
                    let moveTransform = CATransform3DMakeTranslation(0, moveY, 0)
                    layer.transform = moveTransform
                    
                case .normal:
                    self.deleteBtn.isHidden = false
                    self.clickBtn.isHidden = false
                    layer.transform = normalTransform
                    scrollView.isScrollEnabled = true
                    
                case .top:
                    self.deleteBtn.isHidden = false
                    self.clickBtn.isHidden = false
                    normalTransform = layer.transform//先记录原来的位置
                    scrollView.isScrollEnabled = false
                    let moveTransform = CATransform3DMakeTranslation(0, -1 * pageHeight, 0)
                    layer.transform = CATransform3DConcat(normalTransform, moveTransform)
                    
                case .bottom:
                    self.deleteBtn.isHidden = false
                    self.clickBtn.isHidden = false
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

    fileprivate lazy var tapGes : UITapGestureRecognizer = {
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(onTapGes))
        return tapGes
    }()
   
    lazy var cellContentView : UIView = {
        let cellContentView  = UIView()
        cellContentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        cellContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return cellContentView
    }()
    
    fileprivate lazy var deleteBtn : UIButton = {
       let deleteBtn = UIButton.init(type: .custom)
        deleteBtn.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        deleteBtn .setImage(UIImage.init(named: "delete"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(removePageCellAction), for: .touchUpInside)
        deleteBtn.isHidden = true
        return deleteBtn
    }()
    fileprivate lazy var clickBtn : UIButton = {
        let clickBtn = UIButton.init(type: .custom)
        clickBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        clickBtn.backgroundColor = UIColor.clear
        clickBtn.addTarget(self, action: #selector(showCellToHighLightAtIndexPath), for: .touchUpInside)
        //clickBtn.isHidden = true
        return clickBtn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = false
        setupUI()
        showState = .normal
        self.addGestureRecognizer(self.tapGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setIsShowDeleteBtn(_ tag : Bool) {
        self.deleteBtn.isHidden = !tag
    }
}

extension STPagesCollectionViewCell {
   fileprivate func setupUI() {
        contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cellContentView)
        self.scrollView.addSubview(self.clickBtn)
        self.scrollView.addSubview(self.deleteBtn)
    
    }
}
//
extension STPagesCollectionViewCell {
    @objc func showCellToHighLightAtIndexPath() {
        let selectedIndex = collectionView.indexPath(for: self)
        let delegate = collectionView.delegate as! STPagesCollectionViewDelegate
        delegate.showHighLightCell(collectionView: collectionView as! STPagesCollectionView, indexPath: selectedIndex!)
       
    }
    @objc func onTapGes() {
        var selectedIndex = collectionView.indexPath(for: self)
        if selectedIndex == nil {
            selectedIndex = IndexPath.init(row: 0, section: 0)
        }
        (collectionView as! STPagesCollectionView).showCellToHighLightAtIndexPath(index: selectedIndex!) { (finished : Bool) in
            print("highlight completed")
        }
    }
    @objc func removePageCellAction() {
        guard let selectedIndex = collectionView.indexPath(for: self) else{return}
        if collectionView.numberOfItems(inSection: 0) <= 1 {return}
        //删除数据
        let dataSoure = collectionView.dataSource as! STPagesCollectionViewDataSource
        dataSoure.removeCell(collectionView: collectionView as! STPagesCollectionView, indexPath: selectedIndex)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [selectedIndex])
        }) { (finished : Bool) in
            print("deleted page cell")
        }
    }
}


//MARK: - UIScrollViewDelegate
extension STPagesCollectionViewCell : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //左滑删除
        if showState == .normal {
            if self.scrollView.contentOffset.x >= 50 {
                removePageCellAction()
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else{return nil}
        if view.isKind(of: STPagesCollectionView.self) == true {
            if showState == .highlight{
                return cellContentView///要把事件传递到这一层才可以
            }
        }
        return view
    }
}

