//
//  buchong.swift
//  名人故里地图
//
//  Created by 陈音澎 on 2/16/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class buchong: UIViewController {
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var place: UITextField!
    
    @IBOutlet weak var times: UITextField!
    
    
    @IBOutlet weak var reason: UITextField!
    
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        name.resignFirstResponder()
        place.resignFirstResponder()

        times.resignFirstResponder()

        reason.resignFirstResponder()

        return true
        
    }

    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "好的", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

    
    
    
    
    @IBAction func submitting(sender: AnyObject) {
        
        if name.text != "" && place.text != "" && times.text != "" {
            let makeup = PFObject(className:"buchong")
            makeup["name"] = name.text
            makeup["times"] = times.text
            makeup["place"] = place.text
            if reason.text != nil{
                makeup["reason"] = reason.text
            }
            
            makeup.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    self.displayAlert("登记成功", message: "感谢你为籍贯地图所做的贡献")
                } else {
                    // There was a problem, check error.description
                }
            }
            


            
            
        }else{
            displayAlert("信息不完整", message: "请完善信息，谢谢")
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
