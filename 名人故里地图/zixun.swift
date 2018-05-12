//
//  zixun.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-27.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class zixun: UITableViewController {
    
    
    
    var newstitlelist = [String]()
    var newscontentlist = [String]()
    var newstimelist = [NSDate]()
    var newsimagelist = [PFFile]()
    
    var segueclass = [String]()

    
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        SwiftSpinner.show("资料读取中，请稍等～")
        
        self.newstitlelist.removeAll(keepCapacity: true)
        self.newsimagelist.removeAll(keepCapacity: true)
        self.newscontentlist.removeAll(keepCapacity: true)
        self.segueclass.removeAll(keepCapacity: true)
        self.newstimelist.removeAll(keepCapacity: true)
        
        
        
        var query = PFQuery(className: "News")
        query.whereKey("show", equalTo: 1)
        query.orderByDescending("updateAt")
        print("loaded")
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.newscontentlist.append(object["content"] as! String)
                    
                    self.newstitlelist.append(object["title"] as! String)
                    
                    if object["image"] != nil {
                        self.newsimagelist.append(object["image"] as! PFFile)
                    }
                    
                    self.segueclass.append(object["segue"] as! String)
                    
                    self.newstimelist.append(object.updatedAt!)
                    print(object.updatedAt)
                    
                    self.tableView.reloadData()
                    
                    print("refresh!")
                    
                    self.refresher.endRefreshing()
                    
                    SwiftSpinner.hide()
                }
                
            }
            
            
        })
        
        
        
        
        
        
        
        
    }
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor(netHex:0x4CB5F5)
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        
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
        return newstitlelist.count + 1
    }
    
    

    
    
    var City_name = ""
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let titleCell = tableView.dequeueReusableCellWithIdentifier("titlenew", forIndexPath: indexPath) as! cityimagecell
            
            titleCell.imageView?.image = UIImage(named: "zixun.png")
            
            return titleCell
            
        }
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("normalnew", forIndexPath: indexPath) as! newscell
        
        newsimagelist[indexPath.row-1].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.newsimage.image = downloadedImage
            }
        }
        
        myCell.newstitle.text = newstitlelist[indexPath.row-1]
        
        City_name = newstitlelist[indexPath.row-1]
        
        myCell.newscontent.text = newscontentlist[indexPath.row-1]
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.stringFromDate(newstimelist[indexPath.row-1])
        
        
        myCell.newstime.text = "\(date)"
        
        // Configure the cell...
        
        return myCell
    }

    
    
    
    
    
    
    var chosenCellIndex = 0
    var passcitysnames = ""
    var chooseSegue = ""
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chosenCellIndex = indexPath.row
        
        // Start segue with index of cell clicked
        
        if segueclass.count > 0{
            chooseSegue = segueclass[indexPath.row - 1]
            passcitysnames = newstitlelist[indexPath.row - 1]
            performSegueWithIdentifier("\(segueclass[indexPath.row - 1])", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.row == 0 {
                return 200
            }else{
                return 92
            }
    }
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("pass before\(chosenCellIndex)")
        if (segue.identifier == "toupdate" ) {
            let navVC = segue.destinationViewController as! update
            print("1.passcitykkk\(passcitysnames)")
            navVC.cityname = "\(passcitysnames)"
        }else if (segue.identifier == "torank" ){
            let navVC = segue.destinationViewController as! ranks
            print("2.passcitykkk\(passcitysnames)")
            navVC.cityname = "\(passcitysnames)"
        }else if (segue.identifier == "toessay" ) {
            let navVC = segue.destinationViewController as! essay
            print("1.passcitykkk\(passcitysnames)")
            navVC.cityname = "\(passcitysnames)"
        }
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

extension NSDate {
    func dateFromString(date: String, format: String) -> NSDate {
        let formatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "zh_Hans_CN")
        
        formatter.locale = locale
        formatter.dateFormat = format
        
        return formatter.dateFromString(date)!
    }
}
