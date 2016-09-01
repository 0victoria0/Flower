//
//  DetailWebViewCell.swift
//  Flower
//
//  Created by victoria on 16/7/20.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

// 详情页的webviewCell的高度改变的通知
let DetailWebViewCellHeightChangeNoti = "DetailWebViewCellHeightChangeNoti"
let DetailWebViewCellHeightKey = "DetailWebCellHeightKey"

class DetailWebViewCell: UITableViewCell,UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    
    var article : Article?
        {
        didSet{
            if let art = article {
                let H5Url = art.pageUrl ?? ("http://m.htxq.net//servlet/SysArticleServlet?action=preview&artId=" + art.id!)
                webView.loadRequest(NSURLRequest(URL: NSURL(string: H5Url)!))
                
            }
        }
    }
    
    // 父视图所在控制器
    weak var parentViewController : UIViewController?
    
    var cellHeigth : CGFloat = 0
        {
        didSet{
            if cellHeigth > 0  {
                isFinishLoad = true
                NSNotificationCenter.defaultCenter().postNotificationName(DetailWebViewCellHeightChangeNoti, object: nil, userInfo: [DetailWebViewCellHeightKey : Float(cellHeigth)])
            }
        }
    }

    // 是否加载完毕的flag
    private var isFinishLoad = false
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlstr = request.URL?.absoluteString
        let components : [String] = urlstr!.componentsSeparatedByString("::")
        if (components.count >= 1) {
            //判断是不是图片点击
            if (components[0] == "imageclick") {
//                parentViewController?.presentViewController(ImageBrowserViewController(urls: [NSURL(string: components.last!)!], index: NSIndexPath(forItem: 0, inSection: 0)), animated: true, completion: nil)
                return false;
            }
            return true;
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //        HUD.hideAnimated(true)
        // 加载js文件
//        webView.stringByEvaluatingJavaScriptFromString(try! String(contentsOfURL: NSBundle.mainBundle().URLForResource("image", withExtension: "js")!, encoding: NSUTF8StringEncoding))
        
        // 给图片绑定点击事件
//        webView.stringByEvaluatingJavaScriptFromString("setImageClick()")
        
        
        let height = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")
        print((height! as NSString).floatValue)
        // 只需要获得scrollView.contentSize一次即可
        if !isFinishLoad && webView.scrollView.contentSize.height > 0{
            isFinishLoad = true
            let height = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")
            cellHeigth = CGFloat(((height ?? "0")! as NSString).floatValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        webView.scrollView.scrollEnabled = false
        webView.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
