//
//  ViewController.swift
//  GPS_Speed
//
//  Created by xuanyuan on 2022/10/2.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var kphLabel: UILabel!
    
    var maxSpeed: Double = 0
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.maxLabel.text = "最高速度：".appendingFormat("%.2f", 0) + "km/h"
        self.kphLabel.text = "当前速度：".appendingFormat("%.2f", 0) + "km/h"


        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.stopUpdatingLocation()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CLLocationManager delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                self.maxLabel.text = "Error"
                self.kphLabel.text = "Error"
                return
        }
        
        var speed = newLocation.speed * 3.6
        if speed < 0 {
            speed = 0
        }
        self.kphLabel.text = "当前速度：".appendingFormat("%.2f", speed) + "km/h"
        if speed > maxSpeed {
            maxSpeed = speed
            self.maxLabel.text = "最高速度：".appendingFormat("%.2f", maxSpeed) + "km/h"
        }
    }
}

