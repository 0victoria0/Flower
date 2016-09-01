//
//  CountryViewController.swift
//  Flower
//
//  Created by victoria on 16/7/28.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    // 国家名数组
    var countries : [[String]]?
        {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    // 索引keys
    var keys : [NSString]?
        {
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.getList()
    }
    
    func createUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 330.0
        self.tableView.registerClass(CountryCell.self, forCellReuseIdentifier: "CountryCellIdentifier")
    }
    
    private  func getList() {
        // 获取plist的路径
        let path = NSBundle.mainBundle().pathForResource("country.plist", ofType: nil)
        // 获得
        let dic = NSDictionary.init(contentsOfFile: path!)
        // 索引排序
        keys = dic!.allKeys.sort({ (obj1, obj2) -> Bool in
            return (obj1 as! String) < (obj2 as! String)
        }) as? [NSString]
        
        // 获取国家名
        var values = [[String]]()
        if let rkeys = keys {
            for key in rkeys {
                if let value = dic![key] {
                    values.append(value as! [String])
                }
            }
            countries = values
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = countries?.count ?? 0
        if count == 0 {
            return 0
        }
        let array  = countries![section]
        return array.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CountryCell = tableView.dequeueReusableCellWithIdentifier("CountryCellIdentifier") as! CountryCell
        let count = countries?.count ?? 0
        if count > 1 {
            let countryCount = countries![indexPath.section].count ?? 0
            if countryCount > 1 {
                cell.countryNameLabel.text = countries![indexPath.section][indexPath.row]
            }
        }
        return cell
        
    }
    
    // 设置左边的索引
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let count = keys?.count ?? 0
        return count > 0 ? keys![section] as String : nil
    }
    
    // 设置每组的title
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return keys as? [String]
    }
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let country = countries![indexPath.section][indexPath.row]
//        NSNotificationCenter.defaultCenter().postNotificationName(ChangeCountyNotifyName, object: nil, userInfo: ["country" : country])
//        back()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
