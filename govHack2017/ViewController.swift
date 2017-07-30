//
//  ViewController.swift
//  CoreLocationDemo
//
//  Created by Joshua Mengeloid (ExxoTooNaine) on 25/7/17.
//  Copyright © 2017 Joshua Mengel. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation
import SceneKit

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var theMap: MKMapView!
    
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var currentLocation = CLLocation!.self
    
    var theWinner = "(149.12837474655475, -35.333036537872715)"
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        theWinner = ("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    @IBAction func cameraSegue(_ sender: Any) {
        performSegue(withIdentifier: "highscoreSegue", sender: "\(theWinner)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination2 = segue.destination as? ViewController_camera {

            if let name = sender as? String {

                destination2.userLocation = name

            }

        }

    }

    override func viewDidLoad() {
        
        if CLLocationManager.locationServicesEnabled() {
locationManager.delegate = self
locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
locationManager.startUpdatingLocation()
        }
        
        print(currentLocation)
        
        super.viewDidLoad()
        
        let fileLocation = Bundle.main.path(forResource: "Red Hill LatLong", ofType: "json")!
        let text : String
        
        do
        {
            text = try String(contentsOfFile: fileLocation)
            
            if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
                
                do {
                    let json = try JSON(data: dataFromString)
                    var i = 0
                    var latJson = json[i]["FIELD2"]
                    var longJson = json[i]["FIELD1"]
                    while i < json.count-1 {
                        latJson = json[i]["FIELD2"]
                        longJson = json[i]["FIELD1"]
                        let lat = latJson.doubleValue
                        let long = longJson.doubleValue
                        //lat = Double(latJson)
                        //long = Double(longJson)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        mapView.addAnnotation(annotation)
                        //print(json[i]["FIELD2"], json[i]["FIELD1"])
                        //print("\(lat) \(long)")
                        i = i + 1
                    }
                }
                    
                catch {
                    print("Error")
                }
                
            }
            
        }
            
        catch
        {
            text = ""
        }
        
        reportButton.isUserInteractionEnabled = false
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        theMap.delegate = self
        theMap.showsUserLocation = true
        theMap.mapType = MKMapType(rawValue: 0)!
        theMap.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        reportButton.backgroundColor = UIColor.red
        reportButton.isUserInteractionEnabled = true
    
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        let reportEmailVC = MFMailComposeViewController()
        reportEmailVC.mailComposeDelegate = self
        reportEmailVC.setToRecipients(["edanreynolds@gmail.com"])
        reportEmailVC.setSubject("Report Email")
        reportEmailVC.setMessageBody("Test", isHTML: false)
        
        return reportEmailVC
        
    }
    
    func showReportError() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send mail", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}
