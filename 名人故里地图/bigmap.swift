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
        
        view?.leftCalloutAccessoryView = nil

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
            var ikinciEkran = segue.destinationViewController as! ziliao
            
            ikinciEkran.baike = (((sender as? MKAnnotationView)!.annotation?.title)!)!
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //侧滑菜单
        if self.revealViewController() != nil {
            backmenu.target = self.revealViewController()
            backmenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }

        
        navigationController!.navigationBar.barTintColor = UIColor.redColor()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let query = PFQuery(className:"people")
                query.whereKey("geopoint", nearGeoPoint:geoPoint!)
                query.limit = 54
                query.orderByDescending("num")
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
                        
                        annotation.title = "\(hero["name"] as! String) 字\(hero["word"] as! String) "
                        annotation.subtitle = "古:\(hero["oldlocname"] as! String), 现:\(hero["newlocname"] as! String)"
                        self.mmap.addAnnotation(annotation)
                        
                        
                        self.mmap.setRegion(region, animated: true)
                        
                        
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
