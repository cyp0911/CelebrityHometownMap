//
//  users.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2/17/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import MessageUI


class users: UIViewController,MFMailComposeViewControllerDelegate {

    @IBAction func ratebtn(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1078095818")!);

        
        
        //UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
        
        
    }
    
    
    
    @IBAction func mailbutton(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

        
        
        
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["cyp0911@gmail.com"])
        mailComposerVC.setSubject("来自名人地图的用户")
        mailComposerVC.setMessageBody("你好，我想进行一些反馈和建议：", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Email发送失败", message: "您所用设备的Email设置有误，请检查", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
            
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled mail")
        case MFMailComposeResultSent.rawValue:
            print("Mail Sent")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.barTintColor = UIColor(netHex:0x4CB5F5)
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        
        
        
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
