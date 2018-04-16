//
//  ViewController.swift
//  WeatherFun
//
//  Created by ECE Tech on 08/03/2018.
//  Copyright © 2018 ECE Tech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController,CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    let myPickerData = [String](arrayLiteral: "Peter", "Jane", "Paul", "Mary", "Kevin", "Lucy")
    
    @IBOutlet var map: MKMapView!
    var locationManager  = CLLocationManager()
    
    
    @IBOutlet weak var theTextfield: UITextField!
    
    
    @IBAction func buttonClick(sender: UIButton) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Coffee"
        // Set the region to an associated map view's region
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard  let response = response , error == nil else
            {
                return
            }
            
            for place in  response.mapItems
            {
                print("\(place.name)")
                print("\(place.phoneNumber)")
                print("\(place.placemark.coordinate)")
                
                let point = MKPointAnnotation()
                point.coordinate = place.placemark.coordinate
                point.title = place.name
                self.map.addAnnotation(point)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thePicker = UIPickerView()
        
        theTextfield.inputView = thePicker
        
        thePicker.delegate = self
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            map.userTrackingMode = .follow
            print ("\(locationManager.location?.coordinate.longitude)\(locationManager.location?.coordinate.latitude)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        theTextfield.text = myPickerData[row]
    }

}

