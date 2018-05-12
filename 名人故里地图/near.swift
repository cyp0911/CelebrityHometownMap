//
//  near.swift
//  名人故里地图
//
//  Created by 陈音澎 on 2/9/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import MapKit
import CoreLocation
import Parse
import Social



class near: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    //values
    
    var showbutton = false
    var cnma = true
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
        shareController.setInitialText("离我最近的名人是：\(nameofhero), 籍贯: \(locofhero), \(disofhero). 想看看有什么名人在附近出生？IOS APP Store搜索：名人籍贯地图~")
        
        let imagenow = screenshot()
        
        shareController.addImage(imagenow)
        
        shareController.addURL(NSURL(string: "https://itunes.apple.com/cn/app/ming-ren-ji-guan-de-tu/id1084855455"))
        
        self.presentViewController(shareController, animated: true, completion: nil)
        
        
    }
    
    
    func tofacebook(sender: AnyObject) {
        popover.dismiss()
        let shareController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareController.setInitialText("离我最近的名人是：\(nameofhero), 籍贯: \(locofhero), \(disofhero). 想看看有什么名人在附近出生？IOS APP Store搜索：名人籍贯地图~")
        
        let imagenow = screenshot()
        
        shareController.addImage(imagenow)
        
        shareController.addURL(NSURL(string: "https://itunes.apple.com/cn/app/ming-ren-ji-guan-de-tu/id1084855455"))
        self.presentViewController(shareController, animated: true, completion: nil)
        
    }
    
    
    func totwitter(sender: AnyObject) {
        popover.dismiss()
        let shareController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareController.setInitialText("离我最近的名人是：\(nameofhero), 籍贯: \(locofhero), \(disofhero). 想看看有什么名人在附近出生？IOS APP Store搜索：名人籍贯地图~")
        
        
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
        message.description="离我最近的名人是：\(nameofhero), 籍贯: \(locofhero), \(disofhero). 想看看有什么名人在附近出生？IOS APP Store搜索：名人籍贯地图~"
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
        message.description="离我最近的名人是：\(nameofhero), 籍贯: \(locofhero), \(disofhero). 想看看有什么名人在附近出生？IOS APP Store搜索：名人籍贯地图~"
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

    @IBOutlet weak var likebutton: UIButton!
    
    @IBAction func like(sender: AnyObject) {
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("liked?")){
            let query1 = PFQuery(className:"people")
            
            query1.whereKey("config", notEqualTo: 3).whereKey("name", equalTo:"\(titlename.text!)")
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
                            self.displayAlert("点赞成功", message: "老乡\(object!["name"])目前获赞\(object!["like"])次,叫更多朋友来为家乡名人呐喊助威吧")
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "liked?")
                            self.likebutton.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)
                        } else {
                            // There was a problem, check error.description
                            

                        }
                    }
                    

                }
            }
            
            
            

        }else{
            let query1 = PFQuery(className:"people")
            query1.whereKey("config", notEqualTo: 3).whereKey("name", equalTo:"\(titlename.text!)")
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
                            self.displayAlert("取消点赞", message: "老乡\(object!["name"])表示很伤心~")
                            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "liked?")
                            self.likebutton.setImage(UIImage(named: "thumb.png"), forState: UIControlState.Normal)
                        } else {
                            // There was a problem, check error.description
                            
                            
                        }
                    }
                    
                    
                
                }
            }

            
            

        }
        
        
        
        
    }

    
    @IBOutlet weak var titlename: UILabel!
    
    var userlong = 0.1
    var userlat = 0.1
    
    @IBOutlet weak var mmap: MKMapView!
    
    @IBOutlet weak var text: UITextView!

    
    var manager:CLLocationManager!
    
    var nameofhero: String!
    var disofhero: String!
    var locofhero: String!
    var numofhero = 0
    var indexofhero: String!
    
    
    
    
    @IBOutlet weak var showdis: UILabel!
    
    var i = 1

    
    
    @IBAction func sharebtn(sender: AnyObject) {
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
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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

        
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("liked?")){
            likebutton.setImage(UIImage(named: "thumb.png"), forState: UIControlState.Normal)

        }else{
            likebutton.setImage(UIImage(named: "dislike.png"), forState: UIControlState.Normal)

        }
        
        
        
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        //scrollview
        
        
        
        
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let query = PFQuery(className:"people")
                query.whereKey("config", notEqualTo: 3).whereKey("geopoint", nearGeoPoint:geoPoint!)
                query.limit = 1
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error) -> Void in
                    let place = objects
                    for object in place! {
                        let hero = object
//                        self.name.text = hero["name"] as? String
//                        self.loctext.text = "\(hero["oldlocname"] as! String),现\(hero["newlocname"] as! String)"
                        
                        
                        
                        let latitude:CLLocationDegrees = hero["geopoint"]!.latitude
                        
                        let longitude:CLLocationDegrees = hero["geopoint"]!.longitude
                        
                        
                        let latDelta:CLLocationDegrees = 5.0
                        
                        let lonDelta:CLLocationDegrees = 5.0
                        
                        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                        
                        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                        
                        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                        
                        let annotation = MKPointAnnotation()
                        
                        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        let loc = CLLocation(latitude: latitude, longitude: longitude)
                        let userloc = CLLocation(latitude: (geoPoint?.latitude)!, longitude: (geoPoint?.longitude)!)
                        let distances = userloc.distanceFromLocation(loc)
//                        self.distance.text = NSString(format: "距离您 %.2f 公里", (distances / 1000)) as String
                        self.disofhero = NSString(format: "距离 %.2f 公里", (distances / 1000)) as String
                        self.nameofhero = "\(hero["name"] as! String) \(hero["word"] as! String)"
                        if(hero["oldlocname"] != nil){
                        self.locofhero = "古:\(hero["oldlocname"] as! String), 现:\(hero["newlocname"] as! String)"
                        }else{
                            self.locofhero = "\(hero["newlocname"] as! String)"
                        }
                        
                        
                        
//                        self.numofhero = hero["num"] as! Int
//                        
//                        if (self.numofhero >= 1 && self.numofhero <= 9){
//                            
//                            self.indexofhero = "0\(self.numofhero)"
//                            
//                        }else if(self.numofhero >= 10 && self.numofhero <= 99){
//                            self.indexofhero = "\(self.numofhero)"
//                            
//                            
//                        }
                        
                        
                        
                        
                        
                        
                        annotation.coordinate = coordinate
                        
                        annotation.title = "\(hero["name"] as! String) \(hero["word"] as! String)"
                        self.titlename.text = "\(hero["name"] as! String)"
                        
                    
                        annotation.subtitle = self.locofhero
                        self.mmap.addAnnotation(annotation)
                        
                        self.mmap.setRegion(region, animated: true)
                        
                        self.showdis.text = "\(self.disofhero)"

                        self.text.text = "\(hero["word"] as! String), \(hero["class"] as! String)人物\n"
                        if(hero["comment"] != nil){
                            self.text.text = self.text.text + "\(hero["comment"])"
                        }
//                        self.text.font = UIFont (name: "CTXingKaiSJ", size: 30)
               
                    }
                    
                })
                
                
                
            }
            
        }
        
        
        
        //save image

        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var mapView: MKMapView!{ //make sure this outlet is connected
        didSet{
            mapView.delegate = self
        }
    }
    
    // MARK: - Map view delegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("AnnotationView Id")
        if view == nil{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView Id")
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        view?.leftCalloutAccessoryView = nil
        //swift 1.2
        //view?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        
        return view
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
