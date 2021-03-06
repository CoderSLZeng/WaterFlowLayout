//
//  ShopCell.swift
//  瀑布流
//
//  Created by Anthony on 17/2/28.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SDWebImage

class ShopCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var priceLabel: UILabel!
    
    
    var shop: ShopItem? {
        didSet {
            guard let img = shop?.img else
            {
                print("获取图片数据失败")
                return
            }
            
            self.imageView.sd_setImageWithURL(NSURL(string: img), placeholderImage: UIImage(named: "loading"))
            
            guard let price = shop?.price else
            {
                print("获取价格数据失败")
                return
            }
            
            self.priceLabel.text = price
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
