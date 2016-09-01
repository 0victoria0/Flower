//
//  LoginViewController.swift
//  Flower
//
//  Created by victoria on 16/7/27.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var localTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var pwdTextField: UITextField!
    @IBOutlet var serviceTermLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }
    
    func createUI(){
        /**** 设置navigationBar的背景色为透明start ***/
        let nav = self.navigationController!
        nav.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.translucent = true
        /**** 设置navigationBar的背景色为透明end ***/
        
        // 设置下划线
        let originStr = "注册即表示我同意 花田小憩服务条款 内容"
        let attrstr = NSMutableAttributedString(string: originStr)
        let range = (originStr as NSString).rangeOfString("花田小憩服务条款")
        attrstr.addAttributes([NSUnderlineStyleAttributeName : NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue )], range: range)
        self.serviceTermLabel.attributedText = attrstr
        self.serviceTermLabel.userInteractionEnabled = true
        self.serviceTermLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.gotoProtocel)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoProtocel(){
        print("clickProtocol")
    }
    
    @IBAction func registerbtn(sender: UIButton) {
    }
    
    @IBAction func forgetPwdBtn(sender: UIButton) {
    }

    @IBAction func loginBtn(sender: UIButton) {
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
