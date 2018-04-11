//
//  custonAnnotation.swift
//  SwiftMap
//
//  Created by 箫海岸 on 2018/1/20.
//  Copyright © 2018年 箫海岸. All rights reserved.
//

import UIKit
import MapKit

class custonAnnotation: NSObject,MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    
    override init() {

        
    }
    
}
