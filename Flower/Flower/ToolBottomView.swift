//
//  ToolBottomView.swift
//  Flower
//
//  Created by victoria on 16/7/11.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class ToolBottomView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var zanBtn: UIButton!
    @IBOutlet var seeBtn: UIButton!
    @IBOutlet var timeBtn: UIButton!

    var article : Article?
        {
        didSet{
            seeBtn .setTitle("\(article!.read)", forState: .Normal)
            commentBtn.setTitle("\(article!.fnCommentNum)", forState: .Normal)
            zanBtn.setTitle("\(article!.favo)", forState: .Normal)
            
            if article!.isNotHomeList {
                if let time = article!.createDateDesc {
                    timeBtn.hidden = false
                    timeBtn.setTitle(time, forState: .Normal)
                    commentBtn.userInteractionEnabled = true
                }else{
                    timeBtn.hidden = true
                }
            }else{
                timeBtn.hidden = true
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
        let nib = UINib(nibName: "ToolBottomView", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds  // 问题1的解决方案
        addSubview(contentView)
    }
}
