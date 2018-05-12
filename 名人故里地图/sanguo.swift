//
//  sanguo.swift
//  名人籍贯地图
//
//  Created by 陈音澎 on 2016-02-28.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import Parse


class sanguo: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    @IBOutlet var collectionView: UICollectionView!
    

    var peoplelist = [String]()
    var wordlist = [String]()
    var citylist = [String]()
    var provlist = [String]()
    var districtlist = [String]()
    var classlist = [String]()
    var peopleimage = [PFFile]()
    var cityimage = [PFFile]()
    var bieming = ""
    var peopleimageindex = [String: PFFile]()
    
    var cityname = ""
    
    var classnum = 0
    
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
        self.provlist.removeAll(keepCapacity: true)
        
        
        super.title = "\(classindex[classnum])名人汇总"
        
        
        print("passedcityname\(cityname)")
        
        
        
        
        let queryp = PFQuery(className: "people")
        queryp.whereKey("config", notEqualTo: 3).whereKey("class", equalTo: "\(classindex[classnum])")
        queryp.orderByAscending("country")
        queryp.addAscendingOrder("prov")
        queryp.addAscendingOrder("city")

        
        queryp.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    print("haha")
                    self.peoplelist.append(object["name"] as! String)
                    self.classlist.append(object["class"] as! String)
                    self.provlist.append(object["prov"] as! String)
                    
                    
                    if (object["city"] != nil){
                    self.citylist.append(object["city"] as! String)
                    }
                    self.wordlist.append(object["word"] as! String)
                    if (object["district"] != nil){
                        self.districtlist.append(object["district"] as! String)
                    }
                    
                    
                    if object["portrait"] != nil{
                        self.peopleimage.append(object["portrait"] as! PFFile)
                        self.peopleimageindex.updateValue(object["portrait"] as! PFFile, forKey: "\(object["name"])")
                    }
                    
                    
//                    self.collectionView.reloadData()
                    
                     self.collectionView.reloadData()
                    
                    
                    self.refresher.endRefreshing()
                    
                }
                
            }
            
            
        })
        
        SwiftSpinner.hide()
        
        
        
        
        
    }
    

    @IBAction func 关闭(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    
    
    var classindex = ["0","三国","古代英杰","娱乐","体坛","当代政治","科学","商界","文艺"]

    
    @IBOutlet weak var serachbar: UISearchBar!
    let items = ["三国名人汇总", "各省名人汇总"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        serachbar.delegate = self
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "拖拽刷新")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView.addSubview(refresher)
        
        refresh()
        
        
        
        
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
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let geziCell = collectionView.dequeueReusableCellWithReuseIdentifier("gezi", forIndexPath: indexPath) as! gezicell
        
        
        if peopleimage.count > 0 {
            if peopleimageindex["\(peoplelist[indexPath.row ])"] != nil{
                print("iamgetakes")
                let ttimage = peopleimageindex["\(peoplelist[indexPath.row])"]! as PFFile
                ttimage.getDataInBackgroundWithBlock { (data, error) -> Void in
                    
                    if let downloadedImage = UIImage(data: data!) {
                        
                        geziCell.geziimage.image = downloadedImage
                    }
                }
            }else {
                geziCell.geziimage.image = UIImage(named: "niming.jpg")
            }
        }
        
        
        
        
        
        
        
        if peoplelist.count > 0{
        geziCell.geziname.text = "\(peoplelist[indexPath.row])  \(wordlist[indexPath.row])"
        }

        if districtlist.count>0{
            if provlist[indexPath.row] != citylist[indexPath.row]{
            geziCell.gezicontent.text = "\(provlist[indexPath.row]),\(citylist[indexPath.row]),\(districtlist[indexPath.row])人"
            }else{
                geziCell.gezicontent.text = "\(citylist[indexPath.row]),\(districtlist[indexPath.row])人, \(wordlist[indexPath.row])"
            }
        }else{
            geziCell.gezicontent.text = "\(citylist[indexPath.row])人"
        }
        
        geziCell.layer.cornerRadius = 5.0

        return geziCell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peoplelist.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(180, 235)
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
