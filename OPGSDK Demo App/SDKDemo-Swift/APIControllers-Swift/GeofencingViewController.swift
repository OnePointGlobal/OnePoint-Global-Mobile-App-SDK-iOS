//
//  GeofencingViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 06/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class GeofencingViewController: UIViewController, OPGGeoFenceSurveyDelegate, CLLocationManagerDelegate
{
    var geo = OPGGeoFence.sharedInstance()
    @IBOutlet weak var switchControl : UISwitch!
    var arrayLocations : NSArray = []
    var alertsArray : Array<Any> = []
    var myLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        geo?.initialiseGeofencing()
        geo?.fencingDelegate = self
    }

    func getGeoSurveysFromServer() {
         let locationManager = CLLocationManager()
        self.myLocation = locationManager.location?.coordinate

        DispatchQueue.global(qos: .default).async {
            let sdk = OPGSDK()
            do {
                self.arrayLocations = try sdk.getGeofenceSurveys(Float((self.myLocation?.latitude)!), longitude: Float((self.myLocation?.longitude)!)) as NSArray
                DispatchQueue.main.async {
                    if self.arrayLocations.count > 1 {
                        var error: NSError?
                        self.geo?.startMonitor(forGeoFencing: Array(self.arrayLocations) as! [OPGGeofenceSurvey], error: &error)
                        if error != nil {
                            print(error.debugDescription)
                        }
                    }
                    else {
                        print("No geofenced survey locations to monitor")
                    }
                }
            }
            catch let err as NSError {
                DispatchQueue.main.async {
                    print("Error: \(err)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchTapped(_ sender: AnyObject) {
        let custom : UISwitch = sender as! UISwitch

        if custom.isOn {
            print("ON")
            self.getGeoSurveysFromServer()
        } else {
            print("OFF")
           self.geo?.stopMonitorForGeoFencing()
        }
    }
    
    func didEnterSurveyRegion(_ regionEntered: OPGGeofenceSurvey) {
            self.showAlert(regionEntered: regionEntered)
    }

    func didExitSurveyRegion(_ regionExited: OPGGeofenceSurvey!) {

    }

    func showAlert(regionEntered: OPGGeofenceSurvey) {
        let alert = UIAlertController.init(title: NSLocalizedString("MySurveys", comment: ""), message: ("Welcome to \(regionEntered.address!)!. You have a survey available!"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Take Survey", comment: ""), style: UIAlertActionStyle.default, handler: {
            action in
            self.alertsArray.removeFirst()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: {
            action in
            self.alertsArray.removeFirst()
            if self.alertsArray.count > 0 {
                self.present(self.alertsArray.first as! UIAlertController, animated: true, completion: nil)
            }
        }))
        self.alertsArray.append(alert)
        self.present(alert, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("User method called")
}

}
