//
//  ViewController.swift
//  瀑布流
//
//  Created by Anthony on 17/2/24.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - 自定义基本属性
    let CELL = "CELL"
    // MARK: - 系统初始化
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        
        // 创建collection
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        // 获取app的状态栏的高度
        let top = UIApplication.sharedApplication().statusBarFrame.height
        collection.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        collection.backgroundColor = UIColor.whiteColor()
        collection.dataSource = self
        self.view.addSubview(collection)
        
        // 注册cell
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CELL)

    }

}


// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource
{
    // 每组有多少个元素
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    // 元素的属性
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
}
