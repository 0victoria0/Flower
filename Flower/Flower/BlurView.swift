//
//  BlurView.swift
//  Flower
//
//  Created by victoria on 16/7/21.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

private let CategoryCellReuseIdentifier = "CategoryCellReuseIdentifier"
class BlurView: UIVisualEffectView , UITableViewDelegate, UITableViewDataSource{
    /// 分类数组
    var categories : [AnyObject]?
        {
        didSet{
            self.tableView.reloadData()
        }
    }
    /// 代理
    weak var delegate : BlurViewDelegate?
    
    // MARK: - 生命周期方法
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI设置和布局
    private func setupUI()
    {
        self.addSubview(tableView)
        self.addSubview(bottomView)
        self.addSubview(underLine)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: self.tableView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.tableView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.tableView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 40))
        
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: self.bottomView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -10))
        self.addConstraint(NSLayoutConstraint.init(item: self.bottomView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 27))
        
        self.underLine.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint.init(item: self.underLine, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.underLine, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.underLine, attribute: .Top, relatedBy: .Equal, toItem: self.tableView, attribute: .Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: self.underLine, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomView, attribute: .Top, multiplier: 1, constant: -10))
    }
    
    // MAKR: - 懒加载
    /// 底部的Logo
    private lazy var bottomView : UIImageView = UIImageView(image: UIImage(named: "f_logo"))
    /// 底部的分割线
    private lazy var underLine : UIImageView = UIImageView(image: UIImage(named:"topLineBlack"))
    private lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRectZero, style: .Plain)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.clearColor()
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: CategoryCellReuseIdentifier)
        table.tableFooterView = UIView()
        table.separatorStyle = .None
        table.rowHeight = 60
        return table
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 非商城
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 非商城
        return categories?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryCellReuseIdentifier)!
        let count = categories?.count ?? 0
        if count > 0 {
            cell.backgroundColor = UIColor.clearColor()
            let obj = categories![indexPath.row]
            cell.textLabel?.text = (obj as! Category).name
            
            cell.selectionStyle = .None
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont.init(name: "CODE LIGHT", size: 14)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.blurView!(self, didSelectCategory: categories![indexPath.row])
    }
}

@objc
protocol BlurViewDelegate : NSObjectProtocol {
    optional func blurView(blurView: BlurView, didSelectCategory category: AnyObject)
}
