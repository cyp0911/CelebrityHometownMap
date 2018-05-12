//
//  citytable.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-22.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse


class citytable: UITableViewController {
    
    //var commentlist = [String]()

    var peoplelist = [String]()
    var wordlist = [String]()
    var citylist = [String]()
    var districtlist = [String]()
    var classlist = [String]()
    var peopleimage = [PFFile]()
    var cityimage = [PFFile]()
    var bieming = ""
    var peopleimageindex = [String: PFFile]()
    
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
        self.peopleimage.removeAll(keepCapacity: true)
        self.cityimage.removeAll(keepCapacity: true)
        //self.commentlist.removeAll(keepCapacity: true)

        
        
        super.title = "\(cityname)名人汇总"
        
        
       print("passedcityname\(cityname)")
        
        
        var querytt = PFQuery(className: "citycell")
        querytt.whereKey("cityname", equalTo: "\(cityname)")
        querytt.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    if object["citybigimage"] != nil{
                        self.cityimage.append(object["citybigimage"] as! PFFile)
                        self.succ = true
                        self.bieming = object["bieming"] as! String
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        })
        
        
        var queryp = PFQuery(className: "people")
        queryp.whereKey("config", notEqualTo: 3).whereKey("prov", equalTo: "\(cityname)")
        queryp.orderByAscending("city")
        queryp.addAscendingOrder("district")
        queryp.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.peoplelist.append(object["name"] as! String)
                    self.classlist.append(object["class"] as! String)
                    //self.commentlist.append(object["comment"] as! String)

                    self.citylist.append(object["city"] as! String)
                    self.wordlist.append(object["word"] as! String)
                    if (object["district"] != nil){
                        self.districtlist.append(object["district"] as! String)
                    }
                    
                    
                    if object["portrait"] != nil{
                        self.peopleimage.append(object["portrait"] as! PFFile)
                        self.peopleimageindex.updateValue(object["portrait"] as! PFFile, forKey: "\(object["name"])")
                    }

                    
                    self.tableView.reloadData()
                    
                    // self.tableView.reloadData()
                    
                    
                    self.refresher.endRefreshing()
                    
                }
                
            }
            
            
        })

        SwiftSpinner.hide()

        
        
        
        
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
        return peoplelist.count + 3
    }

    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.row == 0 {
                return 202 //Whatever fits your need for that cell
            } else if indexPath.row == 1 {
                return 50 // other cell height
            } else if indexPath.row == 2{
                return 66
            }else{
                return 157
            }
    }
    
    var peoplepic = true

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
      //  print("index\(indexPath.row)")
        
        if(indexPath.row == 0){
            
            
            let imageCell = tableView.dequeueReusableCellWithIdentifier("cityimagecell", forIndexPath: indexPath) as! cityimagecell
            if cityimage.count > 0 {
            cityimage[0].getDataInBackgroundWithBlock { (data, error) -> Void in
                
                if let downloadedImage = UIImage(data: data!) {
                    
                    imageCell.cityimage.image = downloadedImage
                }
            }
            }else{
                imageCell.cityimage.image = UIImage(named: "niming.jpg")

            }
            
            return imageCell
            
        }else if indexPath.row == 1{
            
            let labelCell = tableView.dequeueReusableCellWithIdentifier("labelcell", forIndexPath: indexPath) as! labelcell
            
            labelCell.labeltitle.text = "\(cityname)---(\(bieming))"
            
            labelCell.labelimage.image = UIImage(named:"city.png")
            
            labelCell.labellike.image = UIImage(named: "thumb.png")
            
            
            return labelCell
        
        }else if indexPath.row == 2{
            
            let introCell = tableView.dequeueReusableCellWithIdentifier("jieshao", forIndexPath: indexPath) as! introcell
            
            introCell.introcelllabel.text = "省份名人"
            
            
            return introCell
            
        }else{
            let ppCell = tableView.dequeueReusableCellWithIdentifier("ppcell", forIndexPath: indexPath) as! ppcell
            
            
            if peopleimage.count > 0 {
                if peopleimageindex["\(peoplelist[indexPath.row - 3])"] != nil{
                    print("iamgetakes")
                    let ttimage = peopleimageindex["\(peoplelist[indexPath.row - 3])"]! as PFFile
                    ttimage.getDataInBackgroundWithBlock { (data, error) -> Void in
                        
                        if let downloadedImage = UIImage(data: data!) {
                            
                            ppCell.ppcellimage.image = downloadedImage
                        }
                    }
                }else {
                    ppCell.ppcellimage.image = UIImage(named: "niming.jpg")
                }
            }
            
        

        
            
            
        
            ppCell.ppcelltitle.text = peoplelist[indexPath.row-3]
            
            if districtlist.count>0{
            ppCell.ppcelldetail.text = "\(citylist[indexPath.row-3]),\(districtlist[indexPath.row-3])人, \(wordlist[indexPath.row-3]),\(classlist[indexPath.row-3])人物"
            }else{
                 ppCell.ppcelldetail.text = "\(citylist[indexPath.row-3])人,\(wordlist[indexPath.row-3]),\(classlist[indexPath.row-3])人物"
            }
            
            ppCell.likeimage.image = UIImage(named: "thumb.png")
            
            return ppCell
            
            
        }
        
        
    }
    
    
    
    var passnames = ""
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        // Start segue with index of cell clicked
        
        
        if(indexPath.row > 1){
            passnames = peoplelist[indexPath.row-3]
            performSegueWithIdentifier("citytoziliao", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "citytoziliao" ) {
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

}
