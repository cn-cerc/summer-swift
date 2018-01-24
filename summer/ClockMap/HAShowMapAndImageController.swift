//
//  HAShowMapAndImageController.swift
//  SwiftMap
//
//  Created by 箫海岸 on 2018/1/20.
//  Copyright © 2018年 箫海岸. All rights reserved.
//

import UIKit
import MapKit

class HAShowMapAndImageController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.isHidden = true
        map.delegate = self
        let span = MKCoordinateSpanMake(0.021251, 0.016093)
        let coordinate = CLLocationCoordinate2D(latitude: 22.601605807076556, longitude: 113.84994789084844)
        let region = MKCoordinateRegionMake(coordinate, span)
        addAnnotationToMapView(coorinate2D: coordinate)
        map.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //添加大头针
    func addAnnotationToMapView(coorinate2D: CLLocationCoordinate2D){
        map.removeAnnotations(map.annotations)
        let custonAnno = custonAnnotation.init()
        custonAnno.coordinate = coorinate2D
        map.addAnnotation(custonAnno)
    }

}

//MARK: - MKMapViewDelegate 代理
extension HAShowMapAndImageController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let indentifier = "AnnotationView"
        var Pin = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier)
        if Pin == nil {
            Pin = MKAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
            Pin?.canShowCallout = true
        }
        Pin?.image = UIImage.init(named: "redPin")
        Pin?.annotation = annotation
        return Pin
    }
}
