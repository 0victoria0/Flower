//
//  CountryCell.swift
//  Flower
//
//  Created by victoria on 16/7/28.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var keyNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
