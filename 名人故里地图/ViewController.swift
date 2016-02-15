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


class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    var manager:CLLocationManager!
    var userlong = 0.1
    var userlat = 0.1
    var visitlog = PFObject(className:"visitlog")

    
    
    @IBOutlet weak var hanbao: UIBarButtonItem!
    
    @IBAction func menuButton(sender: AnyObject) {
    }
    
    
    
    @IBOutlet weak var text: UITextView!
    
    
    
    
    @IBOutlet weak var selfmap: MKMapView!
    

    @IBOutlet weak var userloc: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //侧滑菜单
        if self.revealViewController() != nil {
            hanbao.target = self.revealViewController()
            hanbao.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = 200
            
            
        //状态栏
            navigationController!.navigationBar.barTintColor = UIColor.redColor()
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
        
        
        
        
            self.visitlog["pos"] = PFGeoPoint(latitude:latitude, longitude:longitude)
            self.visitlog.saveInBackground()
            
            
            
            
            annotation.coordinate = coordinate
            
            annotation.title = "您的位置"
            self.selfmap.addAnnotation(annotation)
            
            
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

                                if (addressbook["CountryCode"] as! String) == "CN"{
                                    
                                    self.city = addressbook["City"] as! String
                                    self.prov = addressbook["State"] as! String
                                    self.userprov = self.prov
                                    self.district = addressbook["SubLocality"] as! String
                                    self.userloc.text = "\(self.prov),\(self.city),\(self.district)"
                                    self.visitlog["district"] = self.district
                                }else{
                                    self.city = addressbook["City"] as! String
                                    self.prov = addressbook["State"] as! String
                                    self.userloc.text = "\(self.prov),\(self.city)"
                                }
                                self.visitlog["fullpos"] = addressbook["FormattedAddressLines"]
                                self.visitlog["country"] = self.country
                                self.visitlog["prov"] = self.prov
                                self.visitlog["city"] = self.city
                                
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
        
        
        
        var query = PFQuery(className:"people")
        query.whereKey("prov", equalTo: prov)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                if(objects!.count == 0){
                    self.text.text = "抱歉，系统内尚未收录您所在省份的名人，欢迎点击下方选项完善系统，为本省正名！"
                }else{
                    self.text.text = "您所在省份共出产名人\(objects!.count)位：\n"

                }
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        self.text.text = self.text.text + "1. \(object["class"])人物 \(object["name"]),来自\(object["prov"]),\(object["city"])\n"
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
                    self.text.text = self.text.text + "可谓：山清水秀,人才辈出"
                case 4...7:
                    self.text.text = self.text.text + "可谓：钟灵毓秀,人杰地灵"
                case 8...12:
                    self.text.text = self.text.text + "可谓：物华天宝,群星璀璨"
                default:
                    self.text.text = self.text.text + "可谓：名家倍起,大师云集"
                

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

