//
//  data.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-22.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse
import BTNavigationDropdownMenu


class data: UITableViewController {
    
    var wintitlelist = [String]()
    var winamelist = [String]()
    var winimageFiles = [PFFile]()
    
    var segueclass = [String]()
    

    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        self.wintitlelist.removeAll(keepCapacity: true)
        self.winamelist.removeAll(keepCapacity: true)
        self.winimageFiles.removeAll(keepCapacity: true)
        self.segueclass.removeAll(keepCapacity: true)
        self.winimageFiles.removeAll(keepCapacity: true)

        
        
        
        var query = PFQuery(className: "Data")
        query.whereKey("show", equalTo: 1)
        query.orderByDescending("updatedAt")
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.winamelist.append(object["winame"] as! String)
                    
                    self.wintitlelist.append(object["wintitle"] as! String)
                    
                    if object["winimage"] != nil {
                    self.winimageFiles.append(object["winimage"] as! PFFile)
                    }
                    
                    self.segueclass.append(object["segue"] as! String)
                    
                    
                    self.tableView.reloadData()
                    
                    print("refresh!")
                    
                    self.refresher.endRefreshing()
                    
                }
                
            }
            
            
        })
        
        

        
        
        
        
        
    }
    
    let items = ["各省名人汇总", "三国名人汇总","古代英杰人物","娱乐人物","体坛人物","当代政治人物","科学人物"]
    
      var classindex = ["0","三国","古代英杰","娱乐","体坛","当代政治","科学","商界"]
    
    var classnum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        self.navigationItem.titleView = menuView
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

        menuView.cellBackgroundColor =  UIColor(netHex:0x4CB5F5)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelAlignment = .Center
        menuView.maskBackgroundColor = UIColor.whiteColor()

        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.classnum = indexPath
            if (indexPath != 0){
            self.performSegueWithIdentifier("togezi", sender: self)
            }
            
            
            
        }
        
        

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
        return wintitlelist.count
    }

    var City_name = ""
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("windowcell", forIndexPath: indexPath) as! windowcell
        
        winimageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.winimage.image = downloadedImage
            }
        }
        
        myCell.wintitle.text = wintitlelist[indexPath.row]
        
        City_name = wintitlelist[indexPath.row]
        
        myCell.winame.text = winamelist[indexPath.row]

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
        chooseSegue = segueclass[indexPath.row]
        passcitysnames = wintitlelist[indexPath.row]
        performSegueWithIdentifier("\(segueclass[indexPath.row])", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("pass before\(chosenCellIndex)")
        if (segue.identifier == "tocity" ) {
            let navVC = segue.destinationViewController as! citytable
            print("1.passcitykkk\(passcitysnames)")
            navVC.cityname = "\(passcitysnames)"
        }else if (segue.identifier == "torank" ){
            let navVC = segue.destinationViewController as! ranks
            print("2.passcitykkk\(passcitysnames)")
            navVC.cityname = "\(passcitysnames)"
        }else if (segue.identifier == "togezi" ){
            let navVC = segue.destinationViewController as! UINavigationController
            
            let tableVC = navVC.viewControllers.first as! sanguo
            
            print("2.passcitykkk\(classnum)")
            tableVC.classnum = classnum
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

}
