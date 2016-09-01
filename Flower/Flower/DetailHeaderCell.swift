//
//  DetailHeaderCell.swift
//  Flower
//
//  Created by victoria on 16/7/20.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class DetailHeaderCell: UITableViewCell {
    
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    var article : Article?
        {
        didSet{
            if let art = article {
                topImageView.kf_setImageWithURL(NSURL(string: art.smallIcon!)!, placeholderImage: UIImage(named: "placehodler"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                titleLabel.text = art.title
                if let category = art.category {
                    let flag = "#"
                    categoryLabel.text = flag + category.name! + flag
                }
                
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
