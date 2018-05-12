//
//  mail.swift
//  名人故里地图
//
//  Created by 陈音澎 on 2/16/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit

class mail: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = "mailto:121440c@acadiau.com"
        let url = NSURL(string: str)
        UIApplication.sharedApplication().openURL(url!)
        
        

        // Do any additional setup after loading the view.
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
