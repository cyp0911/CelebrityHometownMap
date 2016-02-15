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
    
    
    @IBAction func shareloc(sender: AnyObject) {
        let shareController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        shareController.setInitialText("离我最近的三国英雄是：\(nameofhero), 籍贯: \(locofhero), \(disofhero). 想找离自己最近的三国英雄？ 当年收藏过的奇多三国卡, APP Store 搜索: 奇多三国卡－电子卡册")
        
        let imagenow = screenshot()
        
        shareController.addImage(imagenow)
        
        shareController.addURL(NSURL(string: "https://appsto.re/cn/k_Mqab.i"))
        self.presentViewController(shareController, animated: true, completion: nil)
        
        
    }
    
    
    
    var i = 1

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        //scrollview
        
        
        
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let query = PFQuery(className:"people")
                query.whereKey("geopoint", nearGeoPoint:geoPoint!)
                query.limit = 3
                self.text.text = "离您最近的3位名人：\n"
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
                        self.nameofhero = "\(hero["name"] as! String) 字\(hero["word"] as! String)"
                        self.locofhero = "古:\(hero["oldlocname"] as! String), 现:\(hero["newlocname"] as! String)"
                        
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
                        
                        annotation.title = "\(hero["name"] as! String) 字\(hero["word"] as! String)  故里"
                        annotation.subtitle = "古:\(hero["oldlocname"] as! String), 现:\(hero["newlocname"] as! String)"
                        self.mmap.addAnnotation(annotation)
                        
                        
                        self.mmap.setRegion(region, animated: true)
                        //self.text.font = UIFont (name: "MFYueHei_Noncommercial-Regular", size: 30)
                        
//                        self.text.font = UIFont(name: "MF YueHei (Noncommercial)", size: 30)

                        self.text.text = self.text.text + "\(self.i).\t\(hero["name"] as! String)\t\t字\(hero["word"] as! String)\t\(self.disofhero).\n"
//                        self.text.font = UIFont (name: "CTXingKaiSJ", size: 30)
               
                        self.i++
                    }
                    
                })
                
                
                
            }
            
        }
        
        
        // User's location
        // Create a query for places
        
        
        
        
        
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
        view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
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
