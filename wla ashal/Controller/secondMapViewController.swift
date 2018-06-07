//
//  secondMapViewController.swift
//  barber
//
//  Created by amr sobhy on 3/12/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class secondMapViewController: UIViewController , UITextFieldDelegate{
    
    var address = ""
    var city = ""
    var longtude = 0.0
    var latitude = 0.0
    
    var address_to = ""
    var city_to = ""
    var longtude_to = 0.0
    var latitude_to = 0.0
    var addressFrom :addressMap!
    var addressTo :addressMap!
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
        mapView.camera = camera
        addressTo = addressMap(longtide: 0.0, latitude: 0.0, address: "", city: "")
        showMarker(position: camera.target)
        
        self.searchText.delegate = self
        confirmBtn.ButtonborderRoundradius(radius: 7)
        print(self.addressFrom)
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            addressTo.longtide = (locationManager.location?.coordinate.longitude)!
            addressTo.latitude = (locationManager.location?.coordinate.latitude)!
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 6.0)
            mapView.camera = camera
            
            showMarker(position: camera.target)
        }else{
            let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
            mapView.camera = camera
            
            showMarker(position: camera.target)
        }
    }
    @IBOutlet weak var searchText: UITextField!
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func confirmAction(_ sender: Any) {
        
        let previous  = self.storyboard?.instantiateViewController(withIdentifier: "taxiPriceView") as? taxiPriceViewController
       
        previous?.addressFrom = self.addressFrom
        previous?.addressTo = self.addressTo
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
            print("ely hytb3t \(self.address_to)")
            
            self.addressTo.longtide = position.longitude as? Double ?? 0.0
            self.addressTo.latitude = position.latitude as? Double ?? 0.0
            self.addressTo.city = address.administrativeArea as? String ?? ""
            self.addressTo.address =  lines.joined(separator: " , ")
            
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
extension secondMapViewController: GMSAutocompleteViewControllerDelegate {
    
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
extension secondMapViewController: CLLocationManagerDelegate {
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
            self.addressTo.longtide = coordinate.longitude as? Double ?? 0.0
            self.addressTo.latitude = coordinate.latitude as? Double ?? 0.0
            self.addressTo.city = address.administrativeArea as? String ?? ""
            self.addressTo.address =  lines.joined(separator: " , ")
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
extension secondMapViewController: GMSMapViewDelegate {
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
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
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
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            print("addressaa\(address)")
            print("lines\(lines)")
            
            self.marker.snippet = lines.joined(separator: "\n")
            print("ely hytb3t \(self.address_to)")
            
            self.addressTo.longtide = coordinate.longitude as? Double ?? 0.0
            self.addressTo.latitude = coordinate.latitude as? Double ?? 0.0
            self.addressTo.city = address.administrativeArea as? String ?? ""
            self.addressTo.address =  lines.joined(separator: " , ")
            print(self.addressTo)
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


