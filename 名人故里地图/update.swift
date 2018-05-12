//
//  update.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-27.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class update: UITableViewController {
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
    
    var updatetimelist = [NSDate]()
    
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
        self.provlist.removeAll(keepCapacity: true)
        
        
        super.title = "\(cityname)"
        
        
        
    
        
        
        var querzp = PFQuery(className: "people")
        querzp.whereKey("config", notEqualTo: 3)
        querzp.orderByDescending("createdAt")
        querzp.limit = 25
        querzp.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error != nil){
                print("cant take poeple")
            }else{
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        self.likelist.append("\(object["like"])")
                        self.peoplelist.append(object["name"] as! String)
                        self.classlist.append(object["class"] as! String)
                        if object["prov"] != nil{
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
                        }
                        self.updatetimelist.append(object.createdAt!)
                        print(object.createdAt)
                        
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
        return 25
    }
    
    
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
            return 140
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let updateCell = tableView.dequeueReusableCellWithIdentifier("updater", forIndexPath: indexPath) as! updatecell
        
        
        
            
        
            if peoplelist.count > 0{
                
                updateCell.updatename.text = "\(peoplelist[indexPath.row])"
                
                
                if provlist[indexPath.row] == citylist[indexPath.row]{
                    updateCell.updateword.text = "\(provlist[indexPath.row]),\(districtlist[indexPath.row]),\(wordlist[indexPath.row]),\(classlist[indexPath.row])人物"
                }else{
                   updateCell.updateword.text = "\(provlist[indexPath.row]),\(citylist[indexPath.row]),\(districtlist[indexPath.row]),\(wordlist[indexPath.row]),\(classlist[indexPath.row])人物"
                }
        
        }
        
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if updatetimelist.count > 0{
                let date = dateFormatter.stringFromDate(updatetimelist[indexPath.row])
                
                
                updateCell.updatetime.text = "\(date)"
        }
        
                
                
                if peopleimage.count > 0 {
                    if likeimageindex["\(peoplelist[indexPath.row])"] != nil{
                        let ttimage = likeimageindex["\(peoplelist[indexPath.row])"]! as PFFile
                        ttimage.getDataInBackgroundWithBlock { (data, error) -> Void in
                            
                            if let downloadedImage = UIImage(data: data!) {
                                
                                updateCell.updateimage.image = downloadedImage
                            }
                        }
                    }else {
                        updateCell.updateimage.image = UIImage(named: "niming.jpg")
                    }
                }
                
        
            return updateCell
            
            
        }


    
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

}
