//
//  citytable.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-22.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class ranks: UITableViewController {
    
    
    var peoplelist = [String]()
    var wordlist = [String]()
    var citylist = [String]()
    var provlist = [String]()
    var districtlist = [String]()
    var classlist = [String]()
    var peopleimage = [PFFile]()
    var cityimage = [PFFile]()
    var likelist = [String]()
    var likeimageindex = [String: PFFile]()
    
    
    var cityname = ""
    
    var succ = false
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        SwiftSpinner.show("资料读取中，请稍等～")

        
        self.peoplelist.removeAll(keepCapacity: true)
        self.wordlist.removeAll(keepCapacity: true)
        self.citylist.removeAll(keepCapacity: true)
        self.districtlist.removeAll(keepCapacity: true)
        self.classlist.removeAll(keepCapacity: true)
        self.cityimage.removeAll(keepCapacity: true)
        self.likelist.removeAll(keepCapacity: true)
        self.provlist.removeAll(keepCapacity: true)


        
        
        super.title = "\(cityname)"
        
        
        
    
        var querymr = PFQuery(className: "News")
        querymr.whereKey("title", equalTo: "\(cityname)")
        querymr.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error != nil{
                print("cant take citycell")
            }else{
            if let objects = objects {
                
                for object in objects {
                    if object["insideimage"] != nil{
                        self.cityimage.append(object["insideimage"] as! PFFile)
                        print("takes????")
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            }
        })

        
        var querzp = PFQuery(className: "people")
        querzp.whereKey("config", notEqualTo: 3).whereKey("like", greaterThan: 0)
        querzp.orderByDescending("like")
        
        querzp.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error != nil){
                print("cant take poeple")
            }else{
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.likelist.append("\(object["like"])")
                    self.peoplelist.append(object["name"] as! String)
                    self.classlist.append(object["class"] as! String)
                    self.provlist.append(object["prov"] as! String)
                    self.citylist.append(object["city"] as! String)
                    self.wordlist.append(object["word"] as! String)
                    if object["portrait"] != nil{
                    self.peopleimage.append(object["portrait"] as! PFFile)
                    self.likeimageindex.updateValue(object["portrait"] as! PFFile, forKey: "\(object["name"])")
                    }

                    
                    if (object["district"] != nil){
                        self.districtlist.append(object["district"] as! String)
                    }
                    
                    
//                    if object["portrait"] != nil{
//                        self.peopleimage.append(object["portrait"] as! PFFile)
//                    }else{
//                        self.peoplepic = false
//                    }
                    
                    self.tableView.reloadData()
                    
                    // self.tableView.reloadData()
                    
                    
                    self.refresher.endRefreshing()
                    SwiftSpinner.hide()

                }
                
            }
            
            }
        })
        
        
        
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "拖拽刷新")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peoplelist.count + 2
    }
    
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.row == 0 {
                return 202 //Whatever fits your need for that cell
            } else if indexPath.row == 1  {
                return 66 // other cell height
            } else  {
                return 235 // other cell height

            }
    }
    
    var peoplepic = true
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //  print("index\(indexPath.row)")
        
        if(indexPath.row == 0){
            
            
            let imageCell = tableView.dequeueReusableCellWithIdentifier("paihangtitle", forIndexPath: indexPath) as! cityimagecell
            if cityimage.count > 0 {
                cityimage[0].getDataInBackgroundWithBlock { (data, error) -> Void in
                    
                    if let downloadedImage = UIImage(data: data!) {
                        
                        imageCell.cityimage.image = downloadedImage
                    }
                }
            }
            
            return imageCell
            
        }else if indexPath.row == 1{
            
            let introCell1 = tableView.dequeueReusableCellWithIdentifier("paihanglabel", forIndexPath: indexPath) as! introcell
            
            introCell1.introcelllabel.text = "\(cityname)"
            
            
            return introCell1
            
        }else{
            let likesCell = tableView.dequeueReusableCellWithIdentifier("ranklabel", forIndexPath: indexPath) as! liketimescell
            
            
            likesCell.likeorder.text = "\(indexPath.row - 1). "
            
            if peoplelist.count > 0{
                    if provlist[indexPath.row - 2] == citylist[indexPath.row - 2]{
                        likesCell.likenames.text = "\(peoplelist[indexPath.row - 2]), \(citylist[indexPath.row - 2]),\(classlist[indexPath.row - 2])人物"
                    }else{
                        likesCell.likenames.text = "\(peoplelist[indexPath.row - 2]),\(provlist[indexPath.row - 2]), \(citylist[indexPath.row - 2]),\(classlist[indexPath.row - 2])人物"
                    }
                
                
                
            likesCell.liketimes.text = "\(likelist[indexPath.row - 2])次"
     

                
            
            if peopleimage.count > 0 {
                if likeimageindex["\(peoplelist[indexPath.row - 2])"] != nil{
                    let ttimage = likeimageindex["\(peoplelist[indexPath.row - 2])"]! as PFFile
                    ttimage.getDataInBackgroundWithBlock { (data, error) -> Void in
                        
                        if let downloadedImage = UIImage(data: data!) {
                            
                            likesCell.likeimage.image = downloadedImage
                        }
                    }
                }else {
                    likesCell.likeimage.image = UIImage(named: "niming.jpg")
                }
                }
            
            }
            return likesCell
            
            
        }
        
        
    }
    
    
    
    var actionButton: ActionButton!

    var passnames = ""
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        // Start segue with index of cell clicked
        
        
        
        if(indexPath.row > 1){
        passnames = peoplelist[indexPath.row-2]
            
            
        let optionMenu = UIAlertController(title: nil, message: "请选择", preferredStyle: .ActionSheet)

        
        var deleteAction = UIAlertAction(title: "赞👍/消赞", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in

            if(!NSUserDefaults.standardUserDefaults().boolForKey("\(self.peoplelist[indexPath.row - 2])liked?")){
                let query1 = PFQuery(className:"people")
                
                query1.whereKey("config", notEqualTo: 3).whereKey("name", equalTo:"\(self.peoplelist[indexPath.row - 2])")
                query1.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        let likenow = (object!["like"] as! Int) + 1
                        
                        object!["like"] = likenow
                        
                        object!.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                self.displayAlert("点赞成功", message: "\(object!["name"])目前获赞\(object!["like"])次，刷新页面可见最新排名")
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "\(self.peoplelist[indexPath.row - 2])liked?")
 
//                                self.likebutton.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)
                            } else {
                                // There was a problem, check error.description
                                
                                
                            }
                        }
                        
                        
                    }
                }
                
                
                
                
            }else{
                let query1 = PFQuery(className:"people")
                query1.whereKey("config", notEqualTo: 3).whereKey("name", equalTo:"\(self.peoplelist[indexPath.row - 2])")
                query1.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        let likenow = (object!["like"] as! Int) - 1
                        
                        object!["like"] = likenow
                        
                        object!.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                self.displayAlert("取消点赞", message: "\(object!["name"])赞已取消，刷新本页面可查看最新数目")
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "\(self.peoplelist[indexPath.row - 2])liked?")
                                
//                                self.likebutton.setImage(UIImage(named: "thumb.png"), forState: UIControlState.Normal)
                            } else {
                                // There was a problem, check error.description
                                
                                
                            }
                        }
                        
                        
                        
                    }
                }
                
                
                
                
            }
            
            
            
            
        })
            
            
        let saveAction = UIAlertAction(title: "了解更多", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("ranktoziliao", sender: self)

        })
        
        //
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
       
            
        //performSegueWithIdentifier("ranktoziliao", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ranktoziliao" ) {
            let navVC = segue.destinationViewController as! ziliao
            navVC.baike = "\(passnames)"
            navVC.receivedCellIndex = 3
        }
        
        
    }

    
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "好的", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

}
