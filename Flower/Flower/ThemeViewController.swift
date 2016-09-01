//
//  ThemeViewController.swift
//  Flower
//
//  Created by victoria on 16/7/7.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class ThemeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BlurViewDelegate {

    /// 文章数组
    var articles : [Article]?
    /// 当前叶
    var currentPage : Int = 0
    /// 所有的主题分类
    var categories : [Category]?
    /// 选中的分类
    var selectedCategory :Category?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menu: UIButton!
    
    // 是否加载更多
    private var toLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        self.createUI()
        self.getCategories()
        self.getList()
    }
    
    func createUI(){
        var image = UIImage(named: "tb_0_selected")
        self.navigationController?.tabBarItem.selectedImage = image?.imageWithRenderingMode(.AlwaysOriginal)
        image = UIImage(named: "tb_0")
        self.navigationController?.tabBarItem.image = image

        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 330.0
        self.tableView.registerNib(UINib(nibName: "HomeArticleCell",bundle: nil), forCellReuseIdentifier: "HomeArticleCell")
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(ThemeViewController.resetCurrentPage))
        self.tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(ThemeViewController.addCurrentPage))
        self.tableView.mj_footer = footer
    }
    
    /**
     加载页书重置为初始值,下拉刷新
     */
    func resetCurrentPage() {
        self.currentPage == 0
        self.getList()
    }
    
    /**
     加载书页＋1，上拉加载更多
     */
    func addCurrentPage(){
        self.currentPage = self.currentPage + 1
        self.toLoadMore = true
        self.getList()
    }
    
    // MARK: 数据获取
    private func getCategories()
    {
        // 1. 获取本地保存的
        if let array = Category.loadLocalCategories()
        {
            self.categories = array
        }
        // 2. 获取网络数据
        NetworkTool.sharedTools.getCategories { (categories, error) in
            if error == nil{
                self.categories = categories
                // 3. 保存在本地(已在方法中实现了)
            }else{
                print(error?.domain)
            }
        }
    }
    
    /**
     #1.获得专题的类型:(POST或者GET都行)
     http://m.htxq.net/servlet/SysCategoryServlet?action=getList
     */
    func getList()
    {
        // 参数设置
        var paramters = [String : AnyObject]()
        paramters["currentPageIndex"] = "\(currentPage)"
        paramters["pageSize"] = "5"
        // 如果选择了分类就设置分类的请求ID
        if let categry = selectedCategory {
            paramters["cateId"] = categry.id
        }
        NetworkTool.sharedTools.getHomeList(paramters) { (articles, error, loadAll) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if loadAll{
                self.showHint("已经到最后了", duration: 2, yOffset: 0)
                self.currentPage -= 1
                return
            }
            
            // 显示数据
            if error == nil
            {
                if var _ = self.articles{
                    self.toLoadMore = false
                    self.articles! += articles!
                }else{
                    self.articles = articles!
                }
                self.tableView.reloadData()
            }else{
                // 获取数据失败后
                self.currentPage -= 1
                if self.toLoadMore{
                    self.toLoadMore = false
                }
                self.showHint("网络异常", duration: 2, yOffset: 0)
            }
        }
    }
    
    /**
     分类选择
     
     - parameter sender: 分类选择button
     */
    @IBAction func selectedCategory(sender: AnyObject) {
        let btn = sender as! UIButton
        btn.selected = !btn.selected
        
        if btn.selected {
            self.tableView.addSubview(blurView)
            
            blurView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint.init(item: self.blurView, attribute: .Left, relatedBy: .Equal, toItem: self.tableView, attribute: .Left, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint.init(item: self.blurView, attribute: .Top, relatedBy: .Equal, toItem: self.tableView, attribute: .Top, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint.init(item: self.blurView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.tableView.frame.size.height))
            self.view.addConstraint(NSLayoutConstraint.init(item: self.blurView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.tableView.frame.size.width))
            
            blurView.transform = CGAffineTransformMakeTranslation(0, -UIScreen.mainScreen().bounds.height)
        }
        
        UIView.animateWithDuration(0.5, animations: {
            if btn.selected {
                btn.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                self.blurView.transform = CGAffineTransformIdentity
                self.tableView.bringSubviewToFront(self.blurView)
                self.tableView.scrollEnabled = false
            }else{
                btn.transform = CGAffineTransformIdentity
                self.blurView.transform = CGAffineTransformMakeTranslation(0, -UIScreen.mainScreen().bounds.height)
                self.tableView.scrollEnabled = true
            }
            }) { (_) in
                if !btn.selected{ // 如果是向上走, 回去, 需要removeFromSuperview
                    self.blurView.removeFromSuperview()
                }
        }
    }
    
    /**
     专题选择
     
     - parameter sender: 主题选择button
     */
    @IBAction func themeSelectAction(sender: AnyObject) {        
        (sender as! UIButton).selected = !sender.selected
    }
    
    /*UITableViewDataSource, UITableViewDelegate*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeArticleCell")! as! HomeArticleCell
        cell.selectionStyle = .None
        let count = articles?.count ?? 0
        if count > 0 {
            let article = articles![indexPath.row]
            cell.article = article
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let themeSB = UIStoryboard(name: "Theme",bundle: nil)
        let detailVC:DetailViewController = themeSB.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailVC.article = articles![indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private lazy var blurView : BlurView = {
        let blur = BlurView(effect: UIBlurEffect(style: .Light))
        blur.categories = self.categories
        blur.delegate = self
        return blur
    }()
    
    // MARK: -BlurViewDelegate
    func blurView(blurView: BlurView, didSelectCategory category: AnyObject) {
        let selectedThemeVC = SelectedThemeTableViewController()
        selectedThemeVC.selectedCategory = category as? Category
        self.navigationController?.pushViewController(selectedThemeVC, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
