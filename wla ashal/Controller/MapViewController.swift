//
//  MapViewController.swift
//  barber
//
//  Created by amr sobhy on 3/12/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

import CoreLocation

class MapViewController: UIViewController , UITextFieldDelegate ,CLLocationManagerDelegate{
    
    var address_send = ""
    var city = ""
    var longtude = 0.0
    var latitude = 0.0
    var addressFrom :addressMap!
    var name = ""
    var shopname = ""
    var licensce = ""
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft

        mapView.delegate = self
        
        self.searchText.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        addressFrom = addressMap(longtide: 0.0, latitude: 0.0, address: "", city: "")
        confirmBtn.ButtonborderRoundradius(radius: 7)
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            addressFrom.longtide = (locationManager.location?.coordinate.longitude)!
            addressFrom.latitude = (locationManager.location?.coordinate.latitude)!
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
            mapView.camera = camera
            
            marker.position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            marker.title = "مكان التحرك"
            
            marker.snippet = ""
            
            marker.icon = GMSMarker.markerImage(with: UIColor.green)
            marker.map = mapView
            showMarker(position: camera.target)
        }else{
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
    func appMovedToForeground() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0)
            mapView.camera = camera
            
            
        }
        print("App moved to ForeGround!")
    }
    @IBOutlet weak var searchText: UITextField!
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func confirmAction(_ sender: Any) {
        let previous  = self.storyboard?.instantiateViewController(withIdentifier: "secondMapView") as? secondMapViewController
        
       previous?.addressFrom = addressFrom
        
        self.navigationController?.pushViewController(previous!, animated: true)
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
            
            self.addressFrom.latitude = self.latitude
            self.addressFrom.longtide = self.longtude
           
           self.addressFrom.city = address.administrativeArea as? String ?? ""
            self.addressFrom.address =  lines.joined(separator: " , ")
            
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
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        self.searchText.text = place.formattedAddress
        print("Place attributions: \(String(describing: place.attributions))")
        
        mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - CLLocationManagerDelegate
//1
extension MapViewController {
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
            self.addressFrom.latitude = self.latitude
            self.addressFrom.longtide = self.longtude
            
            self.addressFrom.city = address.administrativeArea as? String ?? ""
            self.addressFrom.address =  lines.joined(separator: " , ")
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
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
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
        lbl1.text = "مكان التحرك"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = ""
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
        marker.position = coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "مكان التحرك"
        
        marker.snippet = ""
        
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        marker.map = mapView
        showMarker(position: camera.target)
    }
    
}


