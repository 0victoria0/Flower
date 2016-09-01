//
//  DetailTableViewController.swift
//  Flower
//
//  Created by victoria on 16/7/15.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var article : Article?
    
    // 屏幕的宽度
    let ScreenWidth  = UIScreen.mainScreen().bounds.width
    // 屏幕的高度
    let ScreenHeight = UIScreen.mainScreen().bounds.height
    
    // 头部Cell的高度
    private let DetailHeadCellHeight   : CGFloat = 240
    // HeaderView的高度
    private let DetailHeaderViewHeight : CGFloat = 40
    // 底部工具栏的高度
    private let DetailFooterViewHeight : CGFloat = 40
    
    // 浏览器的高
    var WebCellHeight : CGFloat?
        {
        didSet{
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.getDetail()
    }
    
    // 头部的重用标识符
    private let DetailHeadCellReuseIdentifier = "DetailHeadCellReuseIdentifier"
    // webView的重用标识符
    private let DetailWebCellReuseIdentifier = "DetailWebCellReuseIdentifier"

    func createUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.registerNib(UINib(nibName: "DetailHeaderCell",bundle: nil), forCellReuseIdentifier: DetailHeadCellReuseIdentifier)
        self.tableView.registerNib(UINib(nibName: "DetailWebViewCell",bundle: nil), forCellReuseIdentifier: DetailWebCellReuseIdentifier)

        self.tableView.separatorStyle = .None
        NSNotificationCenter.defaultCenter().addObserverForName(DetailWebViewCellHeightChangeNoti, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self](noti) in
            if let instance = self{
                instance.WebCellHeight = CGFloat(noti.userInfo![DetailWebViewCellHeightKey] as! Float)
            }
        }
    }

    // MARK: - 数据获取
    private func getDetail()
    {
        NetworkTool.sharedTools.getArticleDetail(["articleId":article!.id!]) { [unowned self] (article, error) in
            self.article = article
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*UITableViewDataSource, UITableViewDelegate*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailHeadCellReuseIdentifier) as! DetailHeaderCell
            cell.article = article
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailWebCellReuseIdentifier) as! DetailWebViewCell
            cell.article = article
            cell.parentViewController = self
            cell.selectionStyle = .None
            return cell
        }
    }
    
    // MARK: - table view delegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DetailHeaderViewHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DetailHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: DetailHeaderViewHeight))
        view.article = article
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  indexPath.row == 0 {
            return DetailHeadCellHeight
        }else{
            return WebCellHeight ?? (UIScreen.mainScreen().bounds.size.height - DetailHeadCellHeight - DetailHeaderViewHeight - DetailFooterViewHeight)
        }
    }
}
