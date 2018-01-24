//
//  HAFieldClockController.swift
//  SwiftMap
//
//  Created by 箫海岸 on 2018/1/16.
//  Copyright © 2018年 箫海岸. All rights reserved.
//

import UIKit
import MapKit
/** 屏幕宽 */
let SCREENWIDTH = UIScreen.main.bounds.size.width
/** 屏幕高 */
let SCREENHEIGHT = UIScreen.main.bounds.size.height

class HAFieldClockController: UIViewController {
    /** 地图 */
    var mapView = MKMapView()
    /** 选择的地址title */
    var addNameLbl = UILabel()
    /** 选择的地址 */
    var addressLbl = UILabel()
    /** 分割线 */
    var lineView = UIView()
    /** 照片展示View */
    var showView = UIView()
    /** 打卡按钮 */
    var clockBtn = UIButton()
    /** 记录按钮 */
    var recordBtn = UIButton()
    /** 调用相机按钮 */
    var cameraBtn = UIButton()
    var locationManager = CLLocationManager()
    var AnnotationType = Bool()
    var myLocation = CLLocation()
    var distance : Double = 0.0
    var imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        myLocation = CLLocation.init()
        creatUI()
        
        requestLocation()
        self.locationManager.startUpdatingLocation()

    }
    //MARK: - 请求定位
    func requestLocation(){
        self.locationManager = CLLocationManager.init()
        self.locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 8.0, *){
                if self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) || self.locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){
                    if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil{
                        self.locationManager.requestAlwaysAuthorization()
                    }else if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil{
                        self.locationManager.requestWhenInUseAuthorization()
                    }else{
                       print("定位未开启-Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription")
                    }
                }
            }else{
                print("ios 8.0以下的系统")
            }
        }else{
            print("定位服务未开启")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var map: MKMapView = {
        let myMap = MKMapView.init(frame: CGRect(x: 0, y: 64, width: SCREENWIDTH, height: self.lineView.frame.minY - 104))
        //代理
        myMap.delegate = self
        //是否显示用户当前位置
        myMap.showsUserLocation = true
        myMap.showsScale = true
        //地图是否缩放
        myMap.isZoomEnabled = true
        //地图风格
        myMap.mapType = .standard
        //用户位置追踪
        myMap.userTrackingMode = .follow
//        view.addSubview(mapView)
        return myMap
    }()
    
    lazy var geocoder: CLGeocoder = {
        let geo = CLGeocoder()
        return geo
    }()
 
}

//MARK: - 创建UI
extension HAFieldClockController{
    func creatUI(){
        //分割线
        lineView = UIView.init(frame: CGRect(x: 0, y: SCREENHEIGHT/2 + 20, width: SCREENWIDTH - 20, height: 1))
        lineView.backgroundColor = UIColor(displayP3Red: 206/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1.0)
        view.addSubview(lineView)
        var Y = lineView.frame.minY
        //地图
//        mapView = MKMapView.init(frame: CGRect(x: 0, y: 64, width: SCREENWIDTH, height: Y - 104))
        view.addSubview(map)
        //展示地址的Label
         Y = map.frame.maxY + 10
        addNameLbl = UILabel.init(frame: CGRect(x: 8, y: Y, width: 45, height: 20))
        addNameLbl.text = "地址:"
        addNameLbl.textColor = UIColor(displayP3Red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        addNameLbl.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(addNameLbl)
        
        addressLbl = UILabel.init(frame: CGRect(x: addNameLbl.frame.maxX, y: Y - 5, width: SCREENWIDTH - addNameLbl.frame.maxX, height: 30))
        addressLbl.text = "这里展示反地理编译过来的地址"
        addressLbl.numberOfLines = 2
        addressLbl.textColor = UIColor(displayP3Red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: 1.0)
        addressLbl.font = UIFont.boldSystemFont(ofSize: 12)
        view.addSubview(addressLbl)
        //照片展示view
        Y = lineView.frame.maxY
        showView = UIView.init(frame: CGRect(x: 40, y: Y + 40, width: SCREENWIDTH - 80, height: (SCREENWIDTH - 80)/2))
        showView.layer.borderWidth = 1
        showView.layer.borderColor = UIColor(displayP3Red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1.0).cgColor
        view.addSubview(showView)
        //打卡按钮
        clockBtn = UIButton.init(type: .custom)
        clockBtn.frame = CGRect(x: 0, y: SCREENHEIGHT - 40, width: SCREENWIDTH/2, height: 40)
        clockBtn.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1)
        clockBtn.setTitle("打卡", for: .normal)
        clockBtn.setTitleColor(UIColor.init(red: 58/255.0, green: 58/255.0, blue: 58/255.0, alpha: 1.0), for: .normal)
        clockBtn.setTitleColor(UIColor.init(red: 27/255.0, green: 126/255.0, blue: 252/255.0, alpha: 1), for: .highlighted)
        clockBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        clockBtn.layer.borderWidth = 1
        clockBtn.layer.borderColor = UIColor(displayP3Red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1.0).cgColor
        clockBtn.layer.cornerRadius = 3.0
        clockBtn.addTarget(self, action: #selector(clockButtonAction(sender:)), for: .touchUpInside)
        view.addSubview(clockBtn)
        //记录按钮
        recordBtn = UIButton.init(type: .custom)
        recordBtn.frame = CGRect(x: clockBtn.frame.maxX, y: clockBtn.frame.minY, width: SCREENWIDTH/2, height: 40)
        recordBtn.backgroundColor = UIColor(displayP3Red: 251/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1)
        recordBtn.setTitle("记录", for: .normal)
        recordBtn.setTitleColor(UIColor.init(red: 58/255.0, green: 58/255.0, blue: 58/255.0, alpha: 1.0), for: .normal)
        recordBtn.setTitleColor(UIColor.init(red: 27/255.0, green: 126/255.0, blue: 252/255.0, alpha: 1), for:.highlighted)
        recordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        recordBtn.layer.borderWidth = 1
        recordBtn.layer.borderColor = UIColor(displayP3Red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1.0).cgColor
        recordBtn.layer.cornerRadius = 3.0
        recordBtn.addTarget(self, action: #selector(recordButtonAction), for: .touchUpInside)
        view.addSubview(recordBtn)
        
        //调用相机按钮
        cameraBtn = UIButton(frame: CGRect(x: (showView.frame.size.width - 120)/2, y: (showView.frame.size.height - 120)/2 - 10, width: 120, height: 120))
        cameraBtn.setTitle("实景拍照后上传", for: .normal)
        cameraBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cameraBtn.setTitleColor(UIColor.init(red: 58/255.0, green: 58/255.0, blue: 58/255.0, alpha: 1.0), for: .normal)
        cameraBtn.setImage(UIImage.init(named: "cameras"), for: .normal)
        
        let imageSize = cameraBtn.imageRect(forContentRect: cameraBtn.frame)
        let titleString =  cameraBtn.title(for: .normal)
        let titleSize = titleString?.size(attributes: [NSFontAttributeName : cameraBtn.titleLabel?.font as Any])
        let titleInset = UIEdgeInsets(top: (imageSize.height + (titleSize?.height)! + 8), left: -imageSize.width, bottom: 0, right: 0)
        let imageInaet = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -((titleSize?.width)!))
        
        cameraBtn.titleEdgeInsets = titleInset
        cameraBtn.imageEdgeInsets = imageInaet
        
        cameraBtn.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
        showView.addSubview(cameraBtn)
    }
    
    //MARK: - 添加大头针
    func addAnnotationToMapView(coorinate2D: CLLocationCoordinate2D){
        AnnotationType = true
        map.removeAnnotations(map.annotations)
        let custonAnno = custonAnnotation.init()
        custonAnno.coordinate = coorinate2D
        map.addAnnotation(custonAnno)
        //反地理编码
        let location = CLLocation.init(latitude: coorinate2D.latitude, longitude: coorinate2D.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks : [CLPlacemark]?, error : Error?) in
            
           let err =  (error != nil) || (placemarks?.count == 0)
            if err {
                self.addressLbl.text = ""
                return
            }
            let placeMark = placemarks?.first
            custonAnno.title = placeMark?.locality
            custonAnno.subtitle = placeMark?.subLocality
            print("反地理编译：\(String(describing: placeMark?.addressDictionary))")
            let AddressLinesArray = placeMark?.addressDictionary!["FormattedAddressLines"] as! [String]
            let Name = placeMark?.addressDictionary!["Name"] as! String
            let addressString = AddressLinesArray[0] + Name
            self.addressLbl.text = addressString
            
            //计算两点间距离
            self.distance = self.myLocation.distance(from: location)
            print("距离\(String(describing: self.distance))")
        }
       
        
    }
    //点击屏幕店家校准位置的大头针
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: map)
        let coord = map.convert(point!, toCoordinateFrom: map)
        print("所选位置的坐标：\(coord)")
        addAnnotationToMapView(coorinate2D: coord)
        
    }
    
}
//MARK: - 地图的代理方法
extension HAFieldClockController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let indentifier = "MKPinAnnotationView"
        var Pin = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier)
        if Pin == nil {
            Pin = MKAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
            Pin?.canShowCallout = true
        }
        if  !AnnotationType {
            Pin?.image = UIImage.init(named: "bluePin")
        }else{
            Pin?.image = UIImage.init(named: "redPin")
            AnnotationType = false
        }
        Pin?.annotation = annotation
        return Pin;
    }
//    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//        print("当MKMapView加载数据完成时激发该方法")
//    }
//    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
//        print("MKMapView渲染地图完成时调用该方法")
//    }
}
//MARK: - CLLocationManager 代理
extension HAFieldClockController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.myLocation = locations.last!
    }
    
    
}
//MARK:- 按钮的点击方法
extension HAFieldClockController{
    
    //MARK: - 相机按钮点击方法
    @objc func cameraButtonAction(){
//        print("在此调用相机")
        let isAvailaber = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        if isAvailaber{
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: {
                print("打开相机")
            })
        }else{
            print("找不到相机")
        }
        
    }
    //MARK: - 打卡按钮点击方法
    @objc func clockButtonAction(sender: UIButton){
        print("点击了** 打卡按钮")
        let showMapImageVC = HAShowMapAndImageController()
        self.navigationController?.pushViewController(showMapImageVC, animated: true)
        
        if self.imageView.image == nil{
            print("图片为空")
            return;
        }
        
        let imgData = UIImageJPEGRepresentation(self.imageView.image!, 0.0001)
        
        AFNetworkManager.post("上传图片的URL", parameters: nil, formData: { (formData: AFMultipartFormData?) in
            
            formData?.appendPart(withForm: imgData!, name: "打卡图片")
            
        } , success: { (operation : AFHTTPRequestOperation?, responseObject : [AnyHashable: Any]?) in
            print("上传图片成功\(String(describing: responseObject))")
            
        } ) { (operation: AFHTTPRequestOperation?, error: Error?) in
            print("上传图片失败")
        }
    }
    //MARK: - 记录按钮点击方法
    @objc func recordButtonAction(){
        print("点击了记录按钮")
    }
}

extension HAFieldClockController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let Img = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true) {
            print("相机退出")
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.showView.frame.size.width, height: self.showView.frame.size.height)
            self.imageView.image = Img
            self.imageView.contentMode = .scaleToFill
            self.showView.addSubview(self.imageView)
        }
    }
}

//MARK: - 自定义大头针
//class custonAnnotation: NSObject,MKAnnotation {
//    var coordinate = CLLocationCoordinate2D()
//    var title: String?
//    var subtitle: String?
//}












