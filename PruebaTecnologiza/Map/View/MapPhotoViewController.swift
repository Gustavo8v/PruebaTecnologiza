//
//  MapPhotoViewController.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 07/01/22.
//

import UIKit
import MapKit

class MapPhotoViewController: UIViewController {
    
    @IBOutlet weak var mapPhotographUser: MKMapView!
    
    var coordinateRegion = MKCoordinateRegion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapPhotographUser.setRegion(coordinateRegion, animated: true)
    }
    
    func renderMap(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        coordinateRegion = region
    }
}
