//
//  SelectedThemeTableViewController.swift
//  Flower
//
//  Created by victoria on 16/7/22.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit
import MJRefresh

class SelectedThemeTableViewController: UITableViewController {
    
    /// 文章数组
    var articles : [Article]?
    /// 当前叶
    var currentPage : Int = 0
    /// 选中的分类
    var selectedCategory :Category?
    
    // 是否加载更多
    private var toLoadMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.getList()
    }

    func createUI(){
        self.title = selectedCategory?.name
        // 设置tableview相关
        self.tableView.registerNib(UINib(nibName: "HomeArticleCell",bundle: nil), forCellReuseIdentifier: "HomeArticleCell")
        tableView.rowHeight = 330;
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        
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
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
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
    
    /*UITableViewDataSource, UITableViewDelegate*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeArticleCell")! as! HomeArticleCell
        cell.selectionStyle = .None
        let count = articles?.count ?? 0
        if count > 0 {
            let article = articles![indexPath.row]
            cell.article = article
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let themeSB = UIStoryboard(name: "Theme",bundle: nil)
        let detailVC:DetailViewController = themeSB.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailVC.article = articles![indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
