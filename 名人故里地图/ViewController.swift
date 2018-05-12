//
//  ViewController.swift
//  名人故里地图
//
//  Created by 陈音澎 on 2/14/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse
import Social
import CoreTelephony


class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    var manager:CLLocationManager!
    var userlong = 0.1
    var userlat = 0.1
    var visitlog = PFObject(className:"visitlog")
    var showbutton = false
    var cnma = true

    
    
    @IBOutlet weak var hanbao: UIBarButtonItem!
    
    @IBAction func menuButton(sender: AnyObject) {
    }
    
    
    
    @IBOutlet weak var text: UITextView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var selfmap: MKMapView!
    

    @IBOutlet weak var userloc: UILabel!
    
    let popover = Popover()
    
    @IBAction func share(sender: AnyObject) {
        if(!NSUserDefaults.standardUserDefaults().boolForKey("showbutton?")){
        }else{
            showbutton = true
            
        }
        
        
        
        let startPoint = CGPoint(x: self.view.frame.width - 40, y: 55)
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 230, height: 160))
        popover.show(aView, point: startPoint)
        
        let wbbtn = UIButton()
        wbbtn.setImage(UIImage(named: "weiboicon.png"), forState: .Normal)
        wbbtn.frame = CGRectMake(20, 20, 50, 50)
        wbbtn.addTarget(self, action: Selector("toweibo:"), forControlEvents: .TouchUpInside)
        aView.addSubview(wbbtn)
        
        
        if(showbutton == true){
            let frbtn = UIButton()
            frbtn.setImage(UIImage(named: "friendicon.png"), forState: .Normal)
            frbtn.frame = CGRectMake(90, 20, 50, 50)
            frbtn.addTarget(self, action: Selector("tofriend:"), forControlEvents: .TouchUpInside)
            aView.addSubview(frbtn)
            
            let wxbtn = UIButton()
            wxbtn.setImage(UIImage(named: "weixinicon.png"), forState: .Normal)
            wxbtn.frame = CGRectMake(160, 20, 50, 50)
            wxbtn.addTarget(self, action: Selector("toweixin:"), forControlEvents: .TouchUpInside)
            aView.addSubview(wxbtn)
        }
        
        if(cnma == true){
            let fbbtn = UIButton()
            fbbtn.setImage(UIImage(named: "facebookicon.png"), forState: .Normal)
            fbbtn.frame = CGRectMake(20, 90, 50, 50)
            fbbtn.addTarget(self, action: Selector("tofacebook:"), forControlEvents: .TouchUpInside)
            aView.addSubview(fbbtn)
            
            
            let twbtn = UIButton()
            twbtn.setImage(UIImage(named: "twittericon.png"), forState: .Normal)
            twbtn.frame = CGRectMake(90, 90, 50, 50)
            twbtn.addTarget(self, action: Selector("totwitter:"), forControlEvents: .TouchUpInside)
            aView.addSubview(twbtn)
        }

    }
    
    var provhere = ""
    var numhere = ""
    
    
    
    
    
    
    
    func toweibo(sender: AnyObject) {
        
        popover.dismiss()
        let shareController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        shareController.setInitialText("各行各业名人籍贯全收录，地图展示，人物介绍，来找找自己家乡的名人吧，APP store搜索：名人籍贯地图")
        
        let imagenow = screenshot()
        
        shareController.addImage(imagenow)
        
        shareController.addURL(NSURL(string: "https://itunes.apple.com/cn/app/ming-ren-ji-guan-de-tu/id1084855455"))
        
        self.presentViewController(shareController, animated: true, completion: nil)
        
        
    }
    
    
    func tofacebook(sender: AnyObject) {
        popover.dismiss()
        let shareController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareController.setInitialText("各行各业名人籍贯全收录，地图展示，人物介绍，来找找自己家乡的名人吧，APP store搜索：名人籍贯地图~")
        
        let imagenow = screenshot()
        
        shareController.addImage(imagenow)
        
        shareController.addURL(NSURL(string: "https://itunes.apple.com/cn/app/ming-ren-ji-guan-de-tu/id1084855455"))
        self.presentViewController(shareController, animated: true, completion: nil)
        
    }
    
    
    func totwitter(sender: AnyObject) {
        popover.dismiss()
        let shareController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareController.setInitialText("各行各业名人籍贯全收录，地图展示，人物介绍，来找找自己家乡的名人吧，APP store搜索：名人籍贯地图~")
        
        
        let imagenow = screenshot()
        
        shareController.addImage(imagenow)
        shareController.addURL(NSURL(string: "https://itunes.apple.com/cn/app/ming-ren-ji-guan-de-tu/id1084855455"))
        
        self.presentViewController(shareController, animated: true, completion: nil)
        
        
    }
    
    
    func sendText(text:String, inScene: WXScene)->Bool{
        let req=SendMessageToWXReq()
        req.text=text
        req.bText=true
        req.scene=Int32(inScene.rawValue)
        return WXApi.sendReq(req)
    }
    
    
    ///分享图片
    func sendImage(image:UIImage, inScene:WXScene)->Bool{
        let ext=WXImageObject()
        ext.imageData=UIImagePNGRepresentation(image)
        
        let message=WXMediaMessage()
        message.title="点击下载名人籍贯地图~"
        message.description="各行各业名人籍贯全收录，地图展示，人物介绍，来找找自己家乡的名人吧，APP store搜索：名人籍贯地图"
        message.mediaObject=ext
        message.mediaTagName="MyPic"
        //生成缩略图
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        image.drawInRect(CGRectMake(0, 0, 100, 100))
        let thumbImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData=UIImagePNGRepresentation(thumbImage)
        
        let req=SendMessageToWXReq()
        req.text="各行各业名人籍贯全收录，地图展示，人物介绍，来找找自己家乡的名人吧，APP store搜索：名人籍贯地图"
        req.message=message
        req.bText=false
        req.scene=Int32(inScene.rawValue)
        return WXApi.sendReq(req)
    }
    
    func sendlink(image:UIImage, insCene:WXScene) ->Bool{
        print("linkrun")
        let message=WXMediaMessage()
        message.title="点击下载名人籍贯地图～"
        message.description="各行各业名人籍贯全收录，地图展示，人物介绍，来找找自己家乡的名人吧，APP store搜索：名人籍贯地图"
        message.mediaTagName="mingrne"
        //生成缩略图
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        image.drawInRect(CGRectMake(0, 0, 100, 100))
        let thumbImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData=UIImagePNGRepresentation(thumbImage)
        
        var ext =  WXWebpageObject()
        ext.webpageUrl = "https://itunes.apple.com/cn/app/ming-ren-ji-guan-de-tu/id1084855455"
        message.mediaObject = ext
        
        var req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene=Int32(insCene.rawValue)
        
        return WXApi.sendReq(req)
    }
    
    
    func tofriend(sender: AnyObject) {
        popover.dismiss()
        print("aaaa")
        //sendText("做个实验～", inScene: WXSceneTimeline)
        //sendImage(biggraph.image!, inScene: WXSceneTimeline) //分享图片到朋友圈，假设项目中已经添加了一张名曰MyImage.png的大图片作为分享图片
        sendlink(UIImage(named: "iTunesArtwork1024.png")!, insCene: WXSceneTimeline )
        
        
    }
    
    func toweixin(sender: AnyObject) {
        popover.dismiss()
        //sendText("做个实验～", inScene: WXSceneTimeline)
        sendlink(UIImage(named: "iTunesArtwork1024.png")!, insCene: WXSceneSession )
    }
    
    
    func onResp(resp: BaseResp!) {
        //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
        if resp.isKindOfClass(SendMessageToWXResp){//确保是对我们分享操作的回调
            if resp.errCode == WXSuccess.rawValue{//分享成功
                NSLog("分享成功")
            }else{//分享失败
                NSLog("分享失败，错误码：%d, 错误描述：%@", resp.errCode, resp.errStr)
            }
        }
    }


    
    
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "好的", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

    
    
    
    
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("数据库连接中及地图定位中~请稍等")

        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        
        let locale = NSLocale.currentLocale()
        if let country = locale.objectForKey(NSLocaleCountryCode) as? String {
            if country == "CN" {
                self.cnma = false
            } else {
                self.cnma = true
            }
        }

        if(!NSUserDefaults.standardUserDefaults().boolForKey("showbutton?")){
            var showbtn = PFQuery(className:"swift")
            showbtn.whereKey("function", equalTo:"showbtn")
            showbtn.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            if (object["show"] as! Int == 0){
                                self.showbutton = false
                            }else{
                                self.showbutton = true
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "showbutton?")
                            }
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
        var carrierName = ""
        let networkInfo = CTTelephonyNetworkInfo()
        if networkInfo != ""{
            let carrier = networkInfo.subscriberCellularProvider
            
            // Get carrier name
            if carrier != nil{
                carrierName = carrier!.carrierName!
                
                print(carrierName)
            }
        }else{
            carrierName = "??"
        }
        let systemVersion = UIDevice.currentDevice().systemVersion;
        print(systemVersion)
        
        
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("log?")){
            let visitlog = PFObject(className:"visitimes")
            visitlog["carrier"] = "\(carrierName)"
            visitlog["logtime"] = 1
            
            visitlog["sysversion"] = "\(systemVersion)"
            visitlog.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("nicesave")
                    print(visitlog.objectId)
                    NSUserDefaults.standardUserDefaults().setObject("\(visitlog.objectId! as String)", forKey: "userid")
                } else {
                    // There was a problem, check error.description
                }
            }
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "log?")
            NSUserDefaults.standardUserDefaults().synchronize()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "cn?")
            
            
            
            
            
        }else{
            var visit1 = PFQuery(className:"visitimes")
            let defaults = NSUserDefaults.standardUserDefaults()
            var usid = ""
            if let userIds = defaults.stringForKey("userid")
            {
                print(userIds)
                usid = userIds
                print(usid)
            }
            visit1.getObjectInBackgroundWithId("\(usid)") {
                (visitlog: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let visitlog = visitlog {
                    visitlog["logtime"] = visitlog["logtime"] as! Int + 1
                    visitlog["sysversion"] = "\(systemVersion)"
                    visitlog["carrier"] = "\(carrierName)"
                    visitlog.saveInBackground()
                }
            }
            
        }
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("cn?")){
            
        }

        
        
        
        
        
        
        
        
        SwiftSpinner.hide()

        
        
        

        //侧滑菜单
        if self.revealViewController() != nil {
            hanbao.target = self.revealViewController()
            hanbao.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = 200
            
            
        //状态栏
            navigationController!.navigationBar.barTintColor = UIColor(netHex:0x4CB5F5)
            navigationController!.navigationBar.tintColor = UIColor.whiteColor()
            
            
            let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
            
            
            
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
            
            
        }
    }
    
    var city:String = ""
    var prov:String = ""
    var district:String = ""
    var country:String = ""
    var usercountry:String = ""
    var usercity:String = ""
    var userprov:String = ""

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            //userLocation - there is no need for casting, because we are now using CLLocation object
            
            let userLocation:CLLocation = locations[0]
        
            let latitude:CLLocationDegrees = userLocation.coordinate.latitude
            
            userlong = userLocation.coordinate.latitude
            
            let longitude:CLLocationDegrees = userLocation.coordinate.longitude
            
            let latDelta:CLLocationDegrees = 5.0
            
            let lonDelta:CLLocationDegrees = 5.0
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            let annotation = MKPointAnnotation()
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
            let pfuserloction = PFGeoPoint(latitude:latitude, longitude:longitude)

        
        
            self.visitlog["pos"] = PFGeoPoint(latitude:latitude, longitude:longitude)
            self.visitlog.saveInBackground()
            
            
            
            
//            annotation.coordinate = coordinate
//            
//            annotation.title = "您的位置"
//            self.selfmap.addAnnotation(annotation)
        
            
            selfmap.setRegion(region, animated: false)
            
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                
                if (error != nil) {
                    
                    print(error)
                    
                } else {
                    
                    
                    
                    if let p = placemarks?[0] {
                        if let addressbook = placemarks?[0].addressDictionary{
                            self.visitlog["problem"] = addressbook
                            self.visitlog.saveInBackground()
                            

                            if(addressbook["CountryCode"] != nil){
                                self.country = addressbook["Country"] as! String
                                self.usercountry = addressbook["Country"] as! String
                                if addressbook["SubLocality"] != nil
                                {self.district = addressbook["SubLocality"] as! String
                                }else{
                                self.district = "??"
                                }
                                if (addressbook["CountryCode"] as! String) == "CN"{
                                    
                                    if addressbook["City"] != nil{
                                    self.city = addressbook["City"] as! String
                                    }
                                    if addressbook["State"] != nil{

                                    self.prov = addressbook["State"] as! String
                                    self.userprov = self.prov

                                    }
                                    
                                    print("gg\(addressbook["SubLocality"])")
                                    if addressbook["SubLocality"] != nil
                                    {self.district = addressbook["SubLocality"] as! String
                                    }else{
                                        self.district = "??"
                                    }
                                    if (self.prov == self.city){
                                        self.userloc.text = "\(self.city),\(self.district)"

                                    }else{
                                    self.userloc.text = "\(self.prov),\(self.city),\(self.district)"
                                    }
                                    self.visitlog["district"] = self.district
                                    

                                    
                                    let queryup = PFQuery(className:"people")
                                    queryup.whereKey("config", equalTo: 0)
                                    queryup.getFirstObjectInBackgroundWithBlock {
                                    (object: PFObject?, error: NSError?) -> Void in
                                    if error != nil || object == nil {
                                        print("The getFirstObject request failed.")
                
                                                    
                                    } else {
                                            // The find succeeded.
                                        print("Successfully retrieved the object.2")
                                        let pickloc = CLLocation(latitude: object!["geopoint"]!.latitude,longitude: object!["geopoint"]!.longitude)
                                                    
                                        CLGeocoder().reverseGeocodeLocation(pickloc, completionHandler: { (placemarks, error) -> Void in
                                                        
                                                    if (error != nil) {
                                                            
                                                        print(error)
                                                            
                                                    } else {
                                                        
                                                        if let place = placemarks?[0] {
                                                            var newcountry = ""
                                                            var newcity = ""
                                                            var newprov = ""

                                                    
                                                            let newaddbook = placemarks?[0].addressDictionary
                                                            print(newaddbook)
                                                            if newaddbook!["City"] != nil{
                                                                newcity = newaddbook!["City"] as! String
                                                            }
                                                            if newaddbook!["Country"] != nil{
                                                                newcountry = newaddbook!["Country"] as! String
                                                            }
                                                            if newaddbook!["State"] != nil{
                                                                
                                                            newprov = newaddbook!["State"] as! String

                                                            }
                                                            
                                                            
                                                            
                                                            var newdis = ""
                                                            if newaddbook!["SubLocality"] != nil{
                                                            newdis = newaddbook!["SubLocality"] as! String
                                                                print("1new\(newdis)")
                                                            }else{
                                                                newdis = "??"
                                                            }

                                                            object!["country"] = newcountry
                                                            object!["city"] = newcity
                                                            object!["prov"] = newprov
                                                            object!["district"] = newdis
                                                            object!["config"] = 1
                                                            object!.saveInBackground()
                                                        
                                                        }
                                                        
                                                        }
                                                    })
                                                    
                                                }
                                            }

                                            
                                            
                                    
                                    
                                    
                                    
                    
                                }else{
                                    self.city = addressbook["City"] as! String
                                    self.prov = addressbook["State"] as! String
                                    
                                    self.userloc.text = "\(self.prov),\(self.city)"
                                    
                                    let queryup = PFQuery(className:"people")
                                    queryup.whereKey("config", equalTo: 0).whereKey("geopoint", nearGeoPoint:pfuserloction,withinKilometers: 20000.0)

                                    queryup.getFirstObjectInBackgroundWithBlock {
                                        (object: PFObject?, error: NSError?) -> Void in
                                        if error != nil || object == nil {
                                            print("The getFirstObject request failed.")
                                            
                                            
                                        } else {
                                            // The find succeeded.
                                            print("Successfully retrieved the object.1")
                                            let pickloc = CLLocation(latitude: object!["geopoint"]!.latitude,longitude: object!["geopoint"]!.longitude)
                                            
                                            CLGeocoder().reverseGeocodeLocation(pickloc, completionHandler: { (placemarks, error) -> Void in
                                                
                                                if (error != nil) {
                                                    
                                                    print(error)
                                                    
                                                } else {
                                                    
                                                    if let place = placemarks?[0] {
                                                        
                                                        let newaddbook = placemarks?[0].addressDictionary
                                                        print(newaddbook)
                                                        let newcountrycode = newaddbook!["CountryCode"]
                                                        if((newcountrycode as! String) != "CN"){
                                                        let newcity = newaddbook!["City"]
                                                        let newcountry = newaddbook!["Country"]
                                                        let newprov = newaddbook!["State"]
                                                        
                                                        object!["country"] = newcountry
                                                        if newcity != nil{
                                                        object!["city"] = newcity
                                                            }
                                                        object!["prov"] = newprov
                                                            
                                                        if newaddbook!["SubLocality"] != nil{
                                                            let newdis = newaddbook!["SubLocality"]
                                                            print("newdis\(newdis)")

                                                            object!["district"] = newdis}else{
                                                            object!["district"] = "??"
                                                            }
                                                        object!["config"] = 1
                                                        object!.saveInBackground()
                                                        }
                                                    }
                                                }
                                            })
                                            
                                        }
                                    }

                                    
                                }
                                self.visitlog["fullpos"] = addressbook["FormattedAddressLines"]
                                self.visitlog["country"] = self.country
                                self.visitlog["prov"] = self.prov
                                self.visitlog["city"] = self.city
                                self.visitlog["district"] = self.district
                                let mark = self.prov
                                self.printnear(mark)
                                
                            }else{
                                self.userloc.text = "您在无主之地，就不判断了。。"
                            }
                            
                            
                            
                            
                            self.visitlog.saveInBackground()
                            

                            
                        }
                        
                        
                        
                        
                        
                        //if( p.country != "中国"){
                        //self.userloc.text = "您的位置： \(p.thoroughfare!), \(p.subLocality!), \(p.subAdministrativeArea!)"
                        
                        
                    }
                    
                    
                }
                
            })
            
            
        manager.stopUpdatingLocation()
        

        
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("dis?")){
            
            
            displayAlert("感谢下载", message: "分类大地图在左上角侧滑选项卡内，不要错过哦~")
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "dis?")

        }
    }
    
    

    
    func printnear(prov: String) {
        // Here you work with mark value
        
        let query = PFQuery(className:"people")
        print(prov)
        provhere = prov
        query.whereKey("config", notEqualTo: 3).whereKey("prov", equalTo: "\(prov)")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.numhere = "\((objects?.count)! as Int)"
                if(objects!.count == 0){
                    self.text.text = "抱歉，系统内尚未收录您所在省份的名人，欢迎点击下方选项完善系统，为本省正名！"
                }else{
                    self.text.text = "您所在省份共出产名人\(objects!.count)位：\n"
                    
                }
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if object["district"] != nil{
                        self.text.text = self.text.text + "\(object["class"])人物 \(object["word"]) \(object["name"]),来自\(object["prov"]),\(object["city"]),\(object["district"])\n"
                        }else{
                            self.text.text = self.text.text + "\(object["class"])人物 \(object["word"]) \(object["name"]),来自\(object["prov"]),\(object["city"])\n"
                        }
                        
                        let nearloc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(object["geopoint"]!.latitude, object["geopoint"]!.longitude)

                        let annotation = MKPointAnnotation()
                        
                        annotation.coordinate = nearloc
                        
                        annotation.title = "\(object["name"] as! String) \(object["word"] as! String)"
                        if (object["config"] as! Int == 1){
                            if object["district"] != nil{
                            annotation.subtitle = "\(object["prov"] as! String),\(object["city"] as! String),\(object["district"] as! String)"
                            }else{
                                annotation.subtitle = "\(object["prov"] as! String),\(object["city"] as! String)"
                            }
                        }else{
                            if(object["oldlocname"] != nil){
                                annotation.subtitle = "\(object["newlocname"] as! String),古:\(object["oldlocname"] as! String)"
                            }else{
                                annotation.subtitle = "\(object["newlocname"] as! String)"

                            }

                        }
                        self.selfmap.addAnnotation(annotation)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            switch(objects!.count){
            case 0:
                print("lala")
            case 1...3:
                self.text.text = self.text.text + "此地可谓：山清水秀,小有人物"
            case 4...7:
                self.text.text = self.text.text + "此地可谓：钟灵毓秀,人杰地灵"
            case 8...12:
                self.text.text = self.text.text + "此地可谓：物华天宝,群星璀璨"
            default:
                self.text.text = self.text.text + "此地可谓：名家倍起,大师云集"
                
                
            }
            
            
            
        }

        
        
        
        
    }
        


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func screenshot() -> UIImage {
        
        var imageSize: CGSize = CGSizeZero
        
        let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        if UIInterfaceOrientationIsPortrait(orientation) {
            imageSize = UIScreen.mainScreen().bounds.size
        } else {
            imageSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        for window in UIApplication.sharedApplication().windows {
            CGContextSaveGState(context)
            CGContextTranslateCTM(context, window.center.x, window.center.y)
            CGContextConcatCTM(context, window.transform)
            CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y)
            if (orientation == UIInterfaceOrientation.LandscapeLeft) {
                CGContextRotateCTM(context, CGFloat(M_PI_2))
                CGContextTranslateCTM(context, 0, -imageSize.width);
            } else if (orientation == UIInterfaceOrientation.LandscapeRight) {
                CGContextRotateCTM(context, CGFloat(-M_PI_2))
                CGContextTranslateCTM(context, -imageSize.height, 0)
            } else if (orientation == UIInterfaceOrientation.PortraitUpsideDown) {
                CGContextRotateCTM(context, CGFloat(M_PI))
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
            
            if window.respondsToSelector(Selector("drawViewHierarchyInRect:afterScreenUpdates:")) {
                window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates:true)
            } else {
                window.layer.renderInContext(context)
            }
            CGContextRestoreGState(context)
            
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }


    
    
    
    
}

