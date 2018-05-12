//
//  ziliao.swift
//  名人故里地图
//
//  Created by 陈音澎 on 2/15/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class ziliao: UIViewController,UIWebViewDelegate {
    
    var receivedCellIndex = 0
    var baike:String = ""
    var links:String = ""
    
    
    
    //indicator
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    
    func printweb(value: String) {
        // Here you work with mark value
        
        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 65, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-49-55))
        webV.loadRequest(NSURLRequest(URL: NSURL(string: "\(value)")!))
        webV.delegate = self;
        self.view.addSubview(webV)
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if receivedCellIndex == 3{
            
            if baike != ""{
                let query1 = PFQuery(className:"people")
                query1.whereKey("name", equalTo:"\(baike)")
                query1.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        self.links = object!["baike"] as! String
                        print("links\(self.links)")
                        let mark = object?.objectForKey("baike") as! String
                        self.printweb(mark)
                    }
                    
                }
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }else{
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                let webV:UIWebView = UIWebView(frame: CGRectMake(0, 52, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-49-44))
                webV.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.yinpengchen.com")!))
                webV.delegate = self;
                self.view.addSubview(webV)
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }

            
            
        }else{
        
        
        if baike != ""{
        let delimiter = " "
        var token = baike.componentsSeparatedByString(delimiter)
        print (token[0])
        let query1 = PFQuery(className:"people")
        query1.whereKey("config", notEqualTo: 3).whereKey("name", equalTo:"\(token[0])")
        query1.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
            } else {
                // The find succeeded.
                self.links = object!["baike"] as! String
                print("links\(self.links)")
                let mark = object?.objectForKey("baike") as! String
                self.printweb(mark)
            }
            
        }
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

        }else{
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            let webV:UIWebView = UIWebView(frame: CGRectMake(0, 52, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-49-44))
            webV.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.yinpengchen.com")!))
            webV.delegate = self;
            self.view.addSubview(webV)
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

        }
        //weblink
        }

        
        
        
        
        

        
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
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

