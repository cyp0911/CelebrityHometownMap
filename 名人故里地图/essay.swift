//
//  essay.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-27.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class essay: UIViewController {
    
    @IBOutlet weak var estitle: UILabel!
    var cityname = ""

    
    
    @IBOutlet weak var estime: UILabel!
    
   
    @IBOutlet weak var esimage: UIImageView!
    
    
    @IBOutlet weak var escontent: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("资料读取中，请稍等～")

        var query = PFQuery(className: "News")
        query.whereKey("title", equalTo: "\(cityname)")
        print("loaded")
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.escontent.text = object["article"] as! String
                    
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    let date = dateFormatter.stringFromDate(object.createdAt!)
                    
                    let esauthor = object["author"] as! String
                        
                    self.estime.text = "\(date)   \(esauthor)"

                    
                    self.estitle.text = object["title"] as! String
                    
                    if object["image"] != nil {
                        var essiamge = object["insideimage"] as! PFFile
                        essiamge.getDataInBackgroundWithBlock { (data, error) -> Void in
                            
                            if let downloadedImage = UIImage(data: data!) {
                                
                                self.esimage.image = downloadedImage
                            }
                        }

                    }
                    
                    
                }
                
            }
            
            
        })
        

        
    
    
        SwiftSpinner.hide()
        
        
        
        
        
        
        
        
        
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
