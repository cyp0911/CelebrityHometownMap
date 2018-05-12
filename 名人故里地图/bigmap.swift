//
//  bigmap.swift
//  奇多三国卡
//
//  Created by 陈音澎 on 2/9/16.
//  Copyright © 2016 Clark Chen. All rights reserved.
//

import MapKit
import CoreLocation
import Parse


class bigmap: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    //values
    
    var userlong = 0.1
    var userlat = 0.1
    
    var receivedCellIndex = 0
    
    
    
    //    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var mmap: MKMapView!
    
    var manager:CLLocationManager!
    
    
    @IBOutlet weak var backmenu: UIBarButtonItem!
    
    
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
        
        
        //    if(picdic["\(annotation.title!!)"] != nil){
        //        let imageView = UIImageView(frame: CGRectMake(0, 0, 25, 60))
        //
        //        let hold = picdic["\(annotation.title!!)"]! as String
        //        if hold != "nil"{
        //
        //        //download url
        //        let url = NSURL(string: "\(hold)")
        //
        //        if let url  = NSURL(string: "\(hold)"),
        //            data = NSData(contentsOfURL: url)
        //        {
        //            imageView.image = UIImage(data: data)
        //        }
        //
        //
        ////        }else{
        ////        let image = UIImage(named: "pin.png")
        ////            imageView.image = image;
        ////
        ////        }
        //
        //        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        //
        //
        //
        //        view?.leftCalloutAccessoryView = imageView
        //        }
        //        }
        
        view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        
        
        
        //swift 1.2
        //view?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        
        return view
    }
    var message:String = ""
    var passname:String = ""
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("toziliao", sender: view)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toziliao" )
        {
            let ikinciEkran = segue.destinationViewController as! ziliao
            
            ikinciEkran.baike = (((sender as? MKAnnotationView)!.annotation?.title)!)!
            
        }
        
    }
    
    var picdic = [String: String]()
    
    var classlist = ["三国","古代英杰","娱乐","体坛","当代政治","科学","商界","文艺"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        //        activityIndicator.center = self.view.center
        //        activityIndicator.hidesWhenStopped = true
        //        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        //
        
        SwiftSpinner.show("地图读取中，请稍等～")
        
        
        
        
        print("receive\(receivedCellIndex)")
        
        self.title = "\(classlist[receivedCellIndex - 1])人物地图"

        
        
        //侧滑菜单
        if self.revealViewController() != nil {
            backmenu.target = self.revealViewController()
            backmenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }
        
        
        navigationController!.navigationBar.barTintColor = UIColor(netHex:0x4CB5F5)
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let query = PFQuery(className:"people")
                print( (self.classlist[self.receivedCellIndex - 1]))
                print(self.receivedCellIndex)
                query.whereKey("class", equalTo: "\(self.classlist[self.receivedCellIndex-1])").whereKey("config", notEqualTo: 3)
                query.limit = 100
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error) -> Void in
                    let place = objects
                    for object in place! {
                        let hero = object
                        
                        let latitude:CLLocationDegrees = hero["geopoint"]!.latitude
                        
                        let longitude:CLLocationDegrees = hero["geopoint"]!.longitude
                        
                        let latDelta:CLLocationDegrees = 10.0
                        
                        let lonDelta:CLLocationDegrees = 10.0
                        
                        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                        
                        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                        
                        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                        
                        
                        
                        
                        
                        let annotation = MKPointAnnotation()
                        
                        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        
                        
                        annotation.coordinate = coordinate
                        
                        annotation.title = "\(hero["name"] as! String) \(hero["word"] as! String)"
                        
                        self.picdic = ["\(hero["name"] as! String) \(hero["word"] as! String)":"\(hero["peoimage"])"]
                        
                        if(hero["oldlocname"] != nil){
                            annotation.subtitle = "古:\(hero["oldlocname"] as! String), 现:\(hero["prov"] as! String),\(hero["city"] as! String),\(hero["district"] as! String)"
                        }else{
                            if (hero["district"] != nil){
                                if hero["prov"] as! String != hero["city"]as! String{
                                    annotation.subtitle = "\(hero["prov"] as! String),\(hero["city"] as! String),\(hero["district"] as! String)"
                                }else{
                                     annotation.subtitle = "\(hero["prov"] as! String),\(hero["district"] as! String)"
                                }
                            }else{
                                annotation.subtitle = "\(hero["newlocname"] as! String)"
                            }
                        }
                        self.mmap.addAnnotation(annotation)
                        
                        
                        self.mmap.setRegion(region, animated: true)
                        SwiftSpinner.hide()

                        
                        //                        self.activityIndicator.stopAnimating()
                        //                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    }
                    
                })
                
                
                
            }
            
        }
        
        
        
        
        
        
        
        // User's location
        // Create a query for places
        
        
        
        
        
        // Do any additional setup after loading the view.
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
