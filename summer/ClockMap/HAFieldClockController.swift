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

protocol HAFieldClockControllerDelegate: NSObjectProtocol{
    func toClockRecordInterface()
    
}

class HAFieldClockController: BaseViewController {
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
    var noteContentTF = UITextView()
    /** 经纬度，经度在前 */
    var Position = String()
    /** 打卡界面代理 */
    var delegate : HAFieldClockControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setNavTitle(title: "考勤打卡")
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI , infoStr: "HA")
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
        let myMap = MKMapView.init(frame: CGRect(x: 0, y: 64, width: SCREENWIDTH, height: self.lineView.frame.minY - 144))
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
        lineView = UIView.init(frame: CGRect(x: 0, y: SCREENHEIGHT/2 + 60, width: SCREENWIDTH - 20, height: 1))
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
        addressLbl.text = ""
        addressLbl.numberOfLines = 2
        addressLbl.textColor = UIColor(displayP3Red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: 1.0)
        addressLbl.font = UIFont.boldSystemFont(ofSize: 12)
        view.addSubview(addressLbl)
        //备注label
        Y = addNameLbl.frame.maxY + 10
        let noteLbl = UILabel.init(frame: CGRect(x: 8, y: Y, width: 45, height: 20))
        noteLbl.text = "备注:"
        noteLbl.textColor = UIColor(displayP3Red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
        noteLbl.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(noteLbl)
        noteContentTF = UITextView.init(frame: CGRect(x: noteLbl.frame.maxX, y: Y - 2, width: SCREENWIDTH - noteLbl.frame.maxX - 20, height: 40))
        noteContentTF.layer.borderWidth = 2
        noteContentTF.layer.borderColor = UIColor(displayP3Red: 206/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1.0).cgColor
        noteContentTF.text = ""
        noteContentTF.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(noteContentTF)
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
        Position = "\(coorinate2D.longitude),\(coorinate2D.latitude)"
        map.removeAnnotations(map.annotations)
        let custonAnno = custonAnnotation.init()
        custonAnno.coordinate = coorinate2D
        map.addAnnotation(custonAnno)
        //反地理编码
        let location = CLLocation.init(latitude: coorinate2D.latitude, longitude: coorinate2D.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks : [CLPlacemark]?, error : Error?) in
            
           let err =  (error != nil) || (placemarks?.count == 0)
            if err {
                self.addressLbl.text = "未获取到地址"
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.noteContentTF.resignFirstResponder()
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
            Position = "\(annotation.coordinate.longitude),\(annotation.coordinate.latitude)"
           let location = CLLocation.init(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
                let err =  (error != nil) || (placemarks?.count == 0)
                if err {
                    self.addressLbl.text = "未获取到地址"
                    return
                }
                let placeMark = placemarks?.first
                let AddressLinesArray = placeMark?.addressDictionary!["FormattedAddressLines"] as! [String]
                let Name = placeMark?.addressDictionary!["Name"] as! String
                let addressString = AddressLinesArray[0] + Name
                self.addressLbl.text = addressString
                
            })
        }else{
            Pin?.image = UIImage.init(named: "redPin")
            AnnotationType = false
        }
        Pin?.annotation = annotation
        return Pin;
    }
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
        if self.imageView.image == nil{
            MBProgressHUD.showText("图片为空")
            return;
        }
        let Hud = MBProgressHUD.show(in: view, message: "打卡中")
        let Myapp = shareedMyApp.init()
        let urlString = Myapp.getFormUrl("FrmAttendance.clockIn")
        let imgData = UIImageJPEGRepresentation(self.imageView.image!, 0.0001)
        let noteContent = noteContentTF.text
        let paramet = ["Address_" : self.addressLbl.text,"Position_" : Position,"Remark_": noteContent]
        AFNetworkManager.post(urlString, parameters: paramet, formData: { (formData: AFMultipartFormData?) in
            let fileManager = FileManager.default
            var path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            path = path + "/image.jpg"
            if  fileManager.createFile(atPath: path, contents: imgData, attributes: nil){
                let fileURL = URL.init(fileURLWithPath: path)
                try? formData?.appendPart(withFileURL: fileURL, name: "FileUrl_")
            }
        } , success: { (operation : AFHTTPRequestOperation?, responseObject : [AnyHashable: Any]?) in
            Hud?.hide(true)

            print("上传图片成功\(String(describing: responseObject))")
            guard var result = responseObject?["result"] as? Bool else{
                return;
            }
            if result{
                MBProgressHUD.showText("打卡成功！")
                self.navigationController?.popViewController(animated: true)
            }else{
                MBProgressHUD.showText("\(String(describing: responseObject!["message"]))")
            }
        } ) { (operation: AFHTTPRequestOperation?, error: Error?) in
            Hud?.hide(true)
            MBProgressHUD.showText("打卡失败")
        }
 
    }
    //MARK: - 记录按钮点击方法
    @objc func recordButtonAction(){
        print("点击了记录按钮")
        if delegate != nil{
            delegate?.toClockRecordInterface()
          self.navigationController?.popViewController(animated: true)
        }else{
            print("没有HAFieldClockControllerDelegate对象")
        }
        
    }
}
//MARK: - 相机及导航栏按钮的代理方法
extension HAFieldClockController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustemBBI{
    
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
   
    func BBIdidClickWithName(infoStr: String) {
        self.navigationController?.popViewController(animated: true)
    }
   
}













