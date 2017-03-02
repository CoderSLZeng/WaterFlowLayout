//
//  ViewController.swift
//  瀑布流
//
//  Created by Anthony on 17/2/24.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import MJExtension

class ViewController: UIViewController {
    
    // MARK: - 自定义基本属性
    let CELL = "CELL"
    
    /// 模型数组
    var shops: NSMutableArray = {
    
        () -> NSMutableArray
        in
        
        // 初始化数据
        return ShopItem.mj_objectArrayWithFilename("1.plist")

    }()
    
    // MARK: - 系统初始化
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建布局
        let layout = WaterFlowLayout()
        layout.delegate = self
        layout.columnCount = 2
        
        let margin: CGFloat = 15
        
        layout.rowMargin = margin
        layout.columnMargin = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        
        // 创建collection
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        // 获取app的状态栏的高度
        let top = UIApplication.sharedApplication().statusBarFrame.height
        collection.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        collection.backgroundColor = UIColor.blackColor()
        collection.dataSource = self
        self.view.addSubview(collection)
        
        // 注册cell
        let nib = UINib(nibName: "\(ShopCell.self)", bundle: nil)
        collection.registerNib(nib, forCellWithReuseIdentifier: CELL)

    }

}


// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource
{
    // 每组有多少个元素
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    // 元素的属性
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL, forIndexPath: indexPath) as! ShopCell
        
        // 设置获取的模型数组
        cell.shop = (self.shops[indexPath.item] as! ShopItem)
        return cell
    }
}

extension ViewController: WaterFlowLayoutDelegate
{
    func waterFlowLayout(layout: WaterFlowLayout, heighWithWidth width: CGFloat, atIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 获取数据
        let shop: ShopItem = (self.shops[indexPath.item] as! ShopItem)
        
        guard let cellH = shop.h else
        {
            print("获取Cell的高度失败")
            return 0
        }
        
        guard let cellW = shop.w else
        {
            print("获取Cell的宽度失败")
            return 0
        }
        
        return CGFloat(cellH) / CGFloat(cellW) * width
        
        
    }
}
