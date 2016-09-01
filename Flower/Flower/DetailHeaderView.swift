//
//  DetailHeaderView.swift
//  Flower
//
//  Created by victoria on 16/7/15.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    /// 头像
    @IBOutlet var headerImageView: UIImageView!
    /// 认证
    @IBOutlet var authIdentityImageView: UIImageView!
    /// 作者
    @IBOutlet var authorLabel: UILabel!
    /// 称号
    @IBOutlet var identityNameLabel: UILabel!
    /// 订阅
    @IBOutlet var subscriberBtn: UIButton!
    /// 订阅数量描述
    @IBOutlet var subscriberLabel: UILabel!
    
    var article : Article?
        {
        didSet{
            if let art = article {
                if let author = art.author {
                    headerImageView.kf_setImageWithURL(NSURL(string: author.headImg!)!, placeholderImage: UIImage(named: "p_avatar"), optionsInfo: [], progressBlock: nil, completionHandler: nil)
                    authorLabel.text = author.userName!
                    identityNameLabel.text = author.identity!
                    subscriberLabel.text = "已有\(author.subscibeNum)人订阅"
                    authIdentityImageView.image = author.authImage
                }
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialFromXib()
    }
    
    func initialFromXib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DetailHeaderView", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds  // 问题1的解决方案
        addSubview(contentView)
        
        self.identityNameLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        
        self.headerImageView.layer.cornerRadius = 31 * 0.5
        self.headerImageView.layer.masksToBounds = true
        self.headerImageView.layer.borderWidth = 0.5
        self.headerImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
