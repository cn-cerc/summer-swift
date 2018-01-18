//
//  STPagesCollectionViewFlowLayout.swift
//  summer
//
//  Created by 王雨 on 2018/1/16.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import Foundation
let RotateDegree : CGFloat = -60.0
let pageHeight : CGFloat = SCREEN_HEIGHT

class STPagesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var deleteIndexPaths = [IndexPath]()
    var insertIndexPaths = [IndexPath]()
    
    override init() {
         super.init()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: (collectionView?.frame.size.width)!, height: pageHeight)
        minimumLineSpacing = -1 * (itemSize.height - 160)
        scrollDirection = .vertical
    }
}
extension STPagesCollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        var contentHeight : CGFloat =  CGFloat((collectionView!.numberOfItems(inSection: 0) - 1)) * 160.0 + pageHeight
        contentHeight = max(contentHeight, (collectionView?.frame.size.height)!)
        return CGSize(width: (collectionView?.frame.size.width)!, height: contentHeight)
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) ->   UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else{return nil}
        makeRotateTransFormForAttributes(attributes: attributes)
        return attributes
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let array = super.layoutAttributesForElements(in: rect) else{return nil}
        for attr in array {
            makeRotateTransFormForAttributes(attributes: attr)
        }
        return array
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        for updateItem in updateItems {
            if updateItem.updateAction == .delete {
                deleteIndexPaths.append(updateItem.indexPathBeforeUpdate!)
            }
            if updateItem.updateAction == .insert {
                insertIndexPaths.append(updateItem.indexPathAfterUpdate!)
            }
            print("插入的个数是" + String(describing: insertIndexPaths.count))
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
//        deleteIndexPaths.removeAll()
//        insertIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if (insertIndexPaths.contains(itemIndexPath)) {
            if attributes == nil {
                attributes = layoutAttributesForItem(at: itemIndexPath)
            }
            let rotate = STCATransform3DPerspectSimpleWithRotate(degree: -90)
            attributes?.transform3D = rotate
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if (deleteIndexPaths.contains(itemIndexPath)) {
            if attributes == nil {
                attributes = layoutAttributesForItem(at: itemIndexPath)
            }
            let moveTransform = CATransform3DMakeTranslation(-320, 0, 0)
            attributes?.transform3D = CATransform3DConcat(CATransform3DIdentity, moveTransform)
        }
        return attributes
    }
}

extension STPagesCollectionViewFlowLayout {
    func makeRotateTransFormForAttributes(attributes : UICollectionViewLayoutAttributes) {
        attributes.zIndex = attributes.indexPath.row
        let distance = attributes.frame.origin.y - (collectionView?.contentOffset.y)!
        let normalizedDistance = distance / (collectionView?.frame.size.height)!
        let rotate = RotateDegree + 20 * normalizedDistance
        attributes.transform3D = STCATransform3DPerspectSimpleWithRotate(degree : rotate)
    }
}
 //MARK: - 3D显示的函数
extension STPagesCollectionViewFlowLayout {
    fileprivate func STCATransform3DMakePerspective(center : CGPoint, disZ : CGFloat) -> CATransform3D {
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, -300)
        let transBack = CATransform3DMakeTranslation(center.x, center.y, 300)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0/disZ
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
    }
    fileprivate func STCATransform3DPerspect(t : CATransform3D, center : CGPoint, disZ : CGFloat) -> CATransform3D {
        return CATransform3DConcat(t, STCATransform3DMakePerspective(center: center, disZ: disZ))
    }
    fileprivate func STCATransform3DPerspectSimple(t : CATransform3D) -> CATransform3D{
        return STCATransform3DPerspect(t: t, center: CGPoint(x : 0, y : 0), disZ: 1500)
    }
    fileprivate func STCATransform3DPerspectSimpleWithRotate(degree : CGFloat) -> CATransform3D {
        return STCATransform3DPerspectSimple(t : CATransform3DMakeRotation(CGFloat
            .pi * degree / 180.0, 1, 0, 0))
    }
    
}
