//
//  starting.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-21.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse

class starting: UITableViewController {
    
    var titlelist = [String]()
    var imagelist = [String]()
    
    
    var chosenCellIndex = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        let mama:UIImageView = UIImageView(image: UIImage(named: "inbg-sky.png"))
        mama.contentMode = .ScaleAspectFill

        tableView.backgroundView = mama
        
        var query = PFQuery(className: "Menu")
        query.orderByAscending("order")
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.titlelist.append(object["title"] as! String)
                    
                    self.imagelist.append(object["image"] as! String)
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        })

        
        
        
        
        
        
        
        
        
        
        
        
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
        return titlelist.count
    }

    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    var signs = 0
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        // Configure the cell...

        

        
        if(indexPath.row == 0){
            
            
            let wCell = tableView.dequeueReusableCellWithIdentifier("weizhi", forIndexPath: indexPath) as! loccell
            wCell.title.text = "我的位置"
            
            wCell.titleimage.image = UIImage(named: "gps.png")
            
            wCell.backgroundColor = UIColor.clearColor()
            
            wCell.contentView.backgroundColor = UIColor.clearColor()
            
            tableView.backgroundColor = UIColor.clearColor()

            
            return wCell
        }else{
            
            let myCell = tableView.dequeueReusableCellWithIdentifier("menu", forIndexPath: indexPath) as! menucell
            
            print("indexPath.row\(indexPath.row)")
            myCell.title.text = titlelist[indexPath.row]
            
            myCell.titleimage.image = UIImage(named: "\(imagelist[indexPath.row])")
            
            myCell.backgroundColor = UIColor.clearColor()
            
            myCell.contentView.backgroundColor = UIColor.clearColor()
            
            tableView.backgroundColor = UIColor.clearColor()
            
            return myCell
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chosenCellIndex = indexPath.row
        
        // Start segue with index of cell clicked
        if indexPath.row == 0 {
        performSegueWithIdentifier("toweizhi", sender: self)

        }else{
        performSegueWithIdentifier("toditu", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("pass before\(chosenCellIndex)")
        if (segue.identifier == "toditu" ) {
        let navVC = segue.destinationViewController as! UINavigationController
        
        let tableVC = navVC.viewControllers.first as! bigmap
        
        tableVC.receivedCellIndex = chosenCellIndex
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
