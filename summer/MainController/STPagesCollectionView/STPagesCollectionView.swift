//
//  STPagesCollectionView.swift
//  summer
//
//  Created by 王雨 on 2018/1/16.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit

@objc(STPagesCollectionViewDataSource)
protocol STPagesCollectionViewDataSource : UICollectionViewDataSource {
    //删除cell
    func removeCell(collectionView : STPagesCollectionView, indexPath : IndexPath)
    //新建cell
    func addCell(collectionView : STPagesCollectionView, indexPath : IndexPath)
}
@objc(STPagesCollectionViewDelegate)
protocol STPagesCollectionViewDelegate : UICollectionViewDelegate {
    func showHighLightCell(collectionView : STPagesCollectionView, indexPath : IndexPath)
}

class STPagesCollectionView: UICollectionView {
    var canRemove : Bool?
    var isHighLight : Bool?

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = STPagesCollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension STPagesCollectionView {

    //显示状态
    func showCellToHighLightAtIndexPath(index : IndexPath, completion : @escaping(_ finished : Bool) -> ()) {
        if isHighLight == true {
            return
        }
        self.isScrollEnabled = false
        print(self.visibleCells.count)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.visibleCells.forEach({ (cell : UICollectionViewCell) in
                let visibleIndexPath = self.indexPath(for: cell)!
                let pageCell = cell as! STPagesCollectionViewCell
                if index.row == visibleIndexPath.row {
                    pageCell.showState = .highlight
                } else if index.row < visibleIndexPath.row {
                    pageCell.showState = .bottom
                } else if index.row > visibleIndexPath.row {
                    pageCell.showState = .top
                } else {
                    pageCell.showState = .normal
                }
                
            })
        }) { (finished : Bool) in
            self.isHighLight = true
            completion(finished)
        }
    }
    //回到原来的状态
    func dismissFromHighLight(completion : @escaping(_ finished : Bool) -> ()) {
        if isHighLight == false {
            return
        }
        print(self.visibleCells.count)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.visibleCells.forEach({ (cell : UICollectionViewCell) in
                (cell as! STPagesCollectionViewCell).showState = .normal
            })
            
        }) { (finished : Bool) in
            self.isScrollEnabled = true
            self.isHighLight = false
            completion(finished)
        }
    }
}

extension STPagesCollectionView {
    func addPageCell() {
        if isHighLight == true {
            dismissFromHighLight(completion: { (finished : Bool) in
                self.addNewPage()
            })
        }else {
            addNewPage()
        }
    }
    fileprivate func addNewPage() {
        let total = numberOfItems(inSection: 0)
        print("总的cell数量是\(total)")
        let index = IndexPath.init(row: total-1, section: 0)
        scrollToItem(at: index, at: .bottom, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // 添加数据
            weak var dataSource = self.dataSource as? STPagesCollectionViewDataSource
            //最后一条数据的index
            let lastIndex = IndexPath.init(row: total, section: 0)
            dataSource?.addCell(collectionView: self, indexPath: lastIndex)
            self.performBatchUpdates({
                self.insertItems(at: [lastIndex])
                print("添加之后总的cell数量是\(self.numberOfItems(inSection: 0))")
            }, completion: { (finished : Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.reloadItems(at: [lastIndex])
                    //新建一个窗口后，从3D立体显示回到正常显示
//                    self.showCellToHighLightAtIndexPath(index: lastIndex, completion: { (finished : Bool) in
//
//                   })
                }
            })
        }
    }
   
}

