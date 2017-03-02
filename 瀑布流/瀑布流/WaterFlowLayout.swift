//
//  WaterFlowLayout.swift
//  瀑布流
//
//  Created by Anthony on 17/3/1.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

protocol WaterFlowLayoutDelegate: NSObjectProtocol {
    func waterFlowLayout(layout: WaterFlowLayout,  heighWithWidth width: CGFloat, atIndexPath indexPath: NSIndexPath) -> CGFloat
}

class WaterFlowLayout: UICollectionViewLayout {
    
    // MARK - 默认设置基本属性
    
    /// 默认内边距
    var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    /// 默认列数
    var columnCount: Int = 3
    /// 默认每一行之间的间距
    var rowMargin: CGFloat = 10
    /// 默认每一列之间的间距
    var columnMargin: CGFloat = 10
    
    /// 代理
    weak var delegate: WaterFlowLayoutDelegate?
    
    // MARK - 懒加载
    
    /// 存放所有布局属性的数组
    private lazy var attrArrayM = [UICollectionViewLayoutAttributes]()
    
    /// 存放每一列中最大的Y值的字典
    private lazy var maxYDictM = [String: CGFloat]()
    
    // MARK - 重写系统函数
    override func prepareLayout()
    {
        super.prepareLayout()
        
        // 1.清空最大的Y值
        for i: Int in 0..<columnCount {
            let cloumn = String(i)
            maxYDictM[cloumn] = sectionInset.top
        }
        
        // 获取所有cell的布局属性
        guard let items = collectionView?.numberOfItemsInSection(0) else
        {
            print("获取第0组的元素个数失败")
            return
        }
        
        for i: Int in 0..<items
        {
            guard let layoutAttrs = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) else
            {
                print("获取这个位置的元素属性失败")
                return
            }
            
            attrArrayM.append(layoutAttrs)
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    /**
     范围内容大小
     */
    override func collectionViewContentSize() -> CGSize {
        
        // 假设默认第0列高度就是最长的
        var maxColumn = "0"
        // 找出高度最长的那一列
        for (column, maxY) in maxYDictM {
            if maxY > maxYDictM[maxColumn] {
                maxColumn = column
            }
        }
        
        guard let height = maxYDictM[maxColumn] else
        {
            print("获取最长高度值失败")
            return CGSizeZero
        }
        
        return CGSize(width: 0, height: height + sectionInset.bottom)
    }
    
    /**
     返回指定rect范围内的所有布局属性
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrArrayM
    }
    
    /**
     返回indexPath这个位置Item的布局属性
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        // 假设默认第0列高度就是最短的
        var minColumn = "0"
        // 找出高度最短的那一列
        for (column, maxY) in maxYDictM {
            if maxY < maxYDictM[minColumn] {
                minColumn = column
            }
        }
        
        // 计算尺寸
        // 获取collectionView的frame
        guard let collectionF = collectionView?.frame else
        {
            print("获取collectionView的frame失败")
            return nil
        }
        
        let width = (collectionF.width - sectionInset.left - sectionInset.right - CGFloat(columnCount - 1) * columnMargin) / CGFloat(columnCount)
        let currentHeight = self.delegate?.waterFlowLayout(self,  heighWithWidth: width, atIndexPath: indexPath)
        
        // 计算位置
        // 转换
        guard let shortestCol = Double(minColumn) else
        {
            print("获取最短列数失败")
            return nil
        }
        let x = sectionInset.left + (width + columnMargin) * CGFloat(shortestCol)
        
        guard let maxY = maxYDictM[minColumn] else
        {
            print("获取最大Y值失败")
            return nil
        }
        let y = maxY + rowMargin
        
        guard let height = currentHeight else
        {
            print("获取高度值失败")
            return nil
        }
        
        // 更新最大的Y值
        maxYDictM[minColumn] = y + height + sectionInset.bottom
        
        // 创建LayoutAttributes
        let layoutAttrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        layoutAttrs.frame = CGRect(x: x, y: y, width: width, height: height)
        return layoutAttrs


    }
}
