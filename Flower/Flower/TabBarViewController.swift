//
//  TabBarViewController.swift
//  Flower
//
//  Created by victoria on 16/7/7.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initMainTabViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMainTabViewController() {
        self.tabBar.tintColor = UIColor.blackColor()
        
        let themeSB = UIStoryboard(name: "Theme",bundle: nil)
        let themeVC = themeSB.instantiateViewControllerWithIdentifier("Theme")
        
        let mallsSB = UIStoryboard(name: "Malls",bundle: nil)
        let mallsVC = mallsSB.instantiateViewControllerWithIdentifier("Malls")
        
        let profileSB = UIStoryboard(name: "Profile",bundle: nil)
        let profileVC = profileSB.instantiateViewControllerWithIdentifier("Profile")
        
        self.viewControllers = [themeVC,mallsVC,profileVC]
        self.selectedIndex = 0;
        
        delegate = self
    }
    
    
    // 点击profile的时候.判断是否登录. 如果没有登录, 需要跳转到登录界面, 反之则跳转到个人界面
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        if tabBarController.childViewControllers.indexOf(viewController) == tabBarController.childViewControllers.count-1 {
            // 判断是否登录
            let isLogin = LoginHelper.sharedInstance.isLogin()
            if !isLogin {
                login()
            }
            return isLogin
        }
        return true
    }
    
    /// 跳转到登录界面
    private func login()
    {
        let loginSB = UIStoryboard(name: "Login",bundle: nil)
        let loginVC = loginSB.instantiateViewControllerWithIdentifier("Login")
        presentViewController(loginVC, animated: true, completion: nil)
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
