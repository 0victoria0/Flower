//
//  MallsViewController.swift
//  Flower
//
//  Created by victoria on 16/7/7.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit

class MallsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }
    
    func createUI(){
        var image = UIImage(named: "tb_1_selected")
        self.navigationController?.tabBarItem.selectedImage = image?.imageWithRenderingMode(.AlwaysOriginal)
        image = UIImage(named: "tb_1")
        self.navigationController?.tabBarItem.image = image
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
