//
//  HomeArticleCell.swift
//  Flower
//
//  Created by victoria on 16/7/8.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit
import Kingfisher

class HomeArticleCell: UITableViewCell {
    /// 缩略图
    @IBOutlet var smallIconImageView: UIImageView!
    /// 视频播放按钮
    @IBOutlet var playVideo: UIImageView!
    /// 作者
    @IBOutlet var authorLabel: UILabel!
    /// 称号
    @IBOutlet var identityNameLabel: UILabel!
    /// 头像
    @IBOutlet var headerImageView: UIImageView!
    /// 认证
    @IBOutlet var authIdentityImageView: UIImageView!
    /// 分类
    @IBOutlet var categoryLabel: UILabel!
    /// 标题
    @IBOutlet var titleLabel: UILabel!
    /// 摘要
    @IBOutlet var descLabel: UILabel!
    /// 下划线
    @IBOutlet var underLineImageView: UIImageView!
    /// 评论、点赞、查看和时间显示自定义View
    @IBOutlet var toolBottomView: ToolBottomView!
    
    var article:Article?{
        didSet{
            if let art = article {
                smallIconImageView.kf_setImageWithURL(NSURL(string: art.smallIcon!)!,placeholderImage: UIImage(named: "placehodler" ),optionsInfo: [],progressBlock: nil,completionHandler: nil)
                if art.video == true {
                    playVideo.hidden = false
                }else{
                    playVideo.hidden = true
                }
                headerImageView.kf_setImageWithURL(NSURL(string: art.author!.headImg!)!,placeholderImage: UIImage(named: "pc_default_avatar"),optionsInfo: nil,progressBlock: nil,completionHandler: nil)
                identityNameLabel.text = art.author!.identity!
                authorLabel.text = art.author!.userName ?? "佚名"
                categoryLabel.text = "[" + art.category!.name! + "]"
                titleLabel.text = art.title
                descLabel.text = art.desc
                authIdentityImageView.image = art.author?.authImage
                toolBottomView.article = art
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.identityNameLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        
        self.headerImageView.layer.cornerRadius = 51 * 0.5
        self.headerImageView.layer.masksToBounds = true
        self.headerImageView.layer.borderWidth = 0.5
        self.headerImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.headerImageView.userInteractionEnabled = true
        self.headerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,action: #selector(HomeArticleCell.toProfile)))
        
        self.categoryLabel.textColor = UIColor(r:199,g:167,b:98)
        
        self.descLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    }
    
    var clickHeadImage : ((article: Article?)->())?

    // MARK: - private method
    @objc private func toProfile()
    {
        clickHeadImage!(article: article)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
