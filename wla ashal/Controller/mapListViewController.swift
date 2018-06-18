//
//  mapListViewController.swift
//  wla ashal
//
//  Created by amr sobhy on 6/4/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces
import CoreLocation


class mapListViewController: UIViewController , UITextFieldDelegate ,CLLocationManagerDelegate{
    
    var address_send = ""
    var city = ""
    var longtude = 0.0
    var latitude = 0.0
    var addressFrom = [addressMapProduct]()
    var name = ""
    var shopname = ""
    var licensce = ""
    var markerDict: [String: GMSMarker] = [:]
    var request = false
    
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        self.navigationItem.title = "الاعلانات"
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            if request == false {
                let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
                mapView.camera = camera
                
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                state_marker.title = "موقعي"
                
                state_marker.snippet = ""
                 state_marker.icon = GMSMarker.markerImage(with: UIColor.blue)
                state_marker.map = mapView
                showMarker(position: camera.target)
            }
            
        }else{
            if request == false {
                let alertController = UIAlertController(title: NSLocalizedString("تنبية", comment: ""), message: NSLocalizedString("يجب السماح بتحديد المكان", comment: ""), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("الغاء", comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString("الاعدادات", comment: ""), style: .default) { (UIAlertAction) in
                    UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                }
                
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        print(addressFrom)
        
        for state in addressFrom {
            print(state.latitude)
            print("lat")
            print(state.productName)
            
            let camera = GMSCameraPosition.camera(withLatitude: state.latitude, longitude: state.longtide, zoom: 15.0)
            
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: state.latitude, longitude: state.longtide)
            state_marker.title = state.productName
            
            state_marker.snippet = "\(state.productID)"
            if request == true {
                mapView.camera = camera
                state_marker.snippet = "\(state.address)"
                state_marker.icon = GMSMarker.markerImage(with: UIColor.green)
            }
            state_marker.map = mapView
            markerDict[state.productID] = state_marker
            showMarker(position: camera.target)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            if request == false {
                let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
                mapView.camera = camera
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                state_marker.title = "موقعي"
                
                state_marker.icon = GMSMarker.markerImage(with: UIColor.blue)
                state_marker.snippet = ""
                
                state_marker.map = mapView
                showMarker(position: camera.target)
            }
            
        }else{
            if request == false {
                let alertController = UIAlertController(title: NSLocalizedString("تنبية", comment: ""), message: NSLocalizedString("يجب السماح بتحديد المكان", comment: ""), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("الغاء", comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString("الاعدادات", comment: ""), style: .default) { (UIAlertAction) in
                    UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                }
                
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        print(addressFrom)
        
        for state in addressFrom {
            print(state.latitude)
            print("lat")
            print(state.productName)
            
            let camera = GMSCameraPosition.camera(withLatitude: state.latitude, longitude: state.longtide, zoom: 15.0)
            // mapView.camera = camera
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: state.latitude, longitude: state.longtide)
            state_marker.title = state.productName
            
            state_marker.snippet = "\(state.productID)"
            if request == true {
                
                mapView.camera = camera
                state_marker.snippet = "\(state.address)"
                state_marker.icon = GMSMarker.markerImage(with: UIColor.green)
            }
            
          
            state_marker.map = mapView
            markerDict[state.productID] = state_marker
            showMarker(position: camera.target)
        }
        
    }
    
    func appMovedToForeground() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
            mapView.camera = camera
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            state_marker.title = "موقعي"
            
            state_marker.snippet = ""
            
            state_marker.icon = GMSMarker.markerImage(with: UIColor.blue)
            state_marker.map = mapView
            showMarker(position: camera.target)
            
        }
        print("App moved to ForeGround!")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showMarker(position: CLLocationCoordinate2D){
        
        marker.position = position
        marker.title = ""
        
        marker.map = mapView
        
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            print("addressaa\(address)")
            print("lines\(lines)")
            
            self.marker.snippet = lines.joined(separator: "\n")
            self.longtude = position.latitude as? Double ?? 0.0
            self.latitude = position.latitude as? Double ?? 0.0
            print(self.longtude)
            print(self.latitude)
            
            
            // 3
            //  self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25) {
                //2
                self.view.layoutIfNeeded()
            }
        }
        marker.isDraggable = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - CLLocationManagerDelegate
//1
extension mapListViewController {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        showMarker(position: location.coordinate)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
    // 1
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            print("exact location")
            print(lines.joined(separator: "\n"))
            
            // 3
            //  self.addressLabel.text = lines.joined(separator: "\n")
            
            // 4
            UIView.animate(withDuration: 0.25) {
                //2
                
                self.view.layoutIfNeeded()
            }
        }
    }
}
// MARK: - GMSMapViewDelegate
extension mapListViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if request == false {
            if marker.snippet as? String != "" {
                let showProduct = self.storyboard?.instantiateViewController(withIdentifier: "productView") as? productViewController
                showProduct?.product_id = marker.snippet as? String ?? ""
                print(marker.snippet)
                
                self.navigationController?.pushViewController(showProduct!, animated: true)
            }
            
        }
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let geocoder = GMSGeocoder()
        
        // 2
        
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = marker.title
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        if marker.snippet != "" {
         
            lbl2.text = "اضغط هنا لمشاهدة الاعلان"
        }
        if request == true {
            lbl2.text = marker.snippet
        }
        
        lbl2.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(lbl2)
        return view
        
    }
    
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        //   marker.position = coordinate
    }
    
}

