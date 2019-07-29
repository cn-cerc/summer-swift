//
//  ARSearchViewController.m
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/4.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARSearchViewController.h"
#import <EasyARPlayer/player.oc.h>
#import <EasyARPlayer/player_view.oc.h>
#import <EasyARPlayer/message.oc.h>
#import <EasyARPlayer/messageclient.oc.h>
#import <EasyARPlayer/dictionary.oc.h>
#import <EasyARPlayer/buffervariant.oc.h>
#define ARScene(self) ((easyar_PlayerView *)[self view])
#import <MediaPlayer/MediaPlayer.h>
#import "UserFileSystem.h"
#import "OCClient.h"
#import "OCUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "ARSearchView.h"
#import <CoreLocation/CoreLocation.h>
#import "ARSensorManager.h"
#import "TJAVplayerView.h"
#import "ARSearchDetailView.h"

@interface ARSearchViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) easyar_MessageClient *theMessageClient;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) ARSearchView *searchView;

@property (nonatomic, strong) CLLocationManager *locationmanager;//定位服务
@property (strong, nonatomic) NSString *location;//经度+纬度
@property (assign, nonatomic) float longitude;//经度
@property (assign, nonatomic) float latitude;//纬度
@property (strong, nonatomic) NSString *searchStr;//搜索内容

@property (nonatomic, strong) ARSensorManager *sensorManger;
@property (nonatomic, assign) CLLocationDirection northAngel;
@property (nonatomic, strong) TJAVplayerView *playerView;
@property (nonatomic, strong) ARSearchDetailView *detailView;
@property (nonatomic, strong) NSTimer *timer;



@end

@implementation ARSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    // Do any additional setup after loading the view.
    [easyar_Player initialize:kEasyAR3DAppKey];
    
    //配置AR界面显示
    self.view = [[easyar_PlayerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [ARScene(self) setFPS:40];
    
    //UserFileSystem提供一种TS内容的访问方式。TS可以访问project://和user://形式的资源
    UserFileSystem *fileSystem = [[UserFileSystem alloc] init];
    [fileSystem setUserRootDir:[NSString stringWithFormat:@"%@/",[NSBundle mainBundle].bundlePath]];
    [ARScene(self) setFileSystem:fileSystem];
    
    [self loadEzp];
    
    [self creatSubView];
    
    __weak typeof(self) weakSelf = self;
    self.sensorManger = [ARSensorManager shared];
    [self.sensorManger startSensor];
    self.sensorManger.didUpdateHeadingBlock = ^(CLLocationDirection theHeading) {
        easyar_Dictionary*body = [easyar_Dictionary new];
        [body setFloat:theHeading forKey:@"y"];
        [weakSelf.theMessageClient send:[[easyar_Message alloc] initWithId:1300 body:body]];
    };
//    [self.sensorManger startGyroscope];
//    self.sensorManger.updateDeviceMotionBlock = ^(CMDeviceMotion * _Nonnull data) {
////        NSLog(@"updateDeviceMotionBlock %f %f %f",data.rotationRate.x,data.rotationRate.y,data.rotationRate.z);
////        NSLog(@"update %f %f %f",data.gravity.x,data.gravity.y,data.gravity.z);
//        easyar_Dictionary*body = [easyar_Dictionary new];
//        [body setFloat:data.gravity.x forKey:@"x"];
//        [body setFloat:data.gravity.y forKey:@"y"];
//        [body setFloat:data.gravity.z forKey:@"z"];
//        [weakSelf.theMessageClient send:[[easyar_Message alloc] initWithId:1300 body:body]];
//    };
    
//    self.playerView = [[TJAVplayerView alloc] init];
//    self.playerView.isNoUI = YES;
//    self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    [self.view addSubview:self.playerView];
//    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"guideVideo" ofType:@"mp4"];
//    [self.playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
//    self.playerView.overBlock = ^(NSString *type) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.playerView removeSelf];
//            weakSelf.playerView = nil;
//            [weakSelf loadmArID];
//        });
//    };
    
    /**
     屏蔽调AR刚启动时的视频 loadmArID  方法需要单独拿出来
     若需要开启 AR 启动是的视频，则下面的的代码需要注释掉
     */
    [self loadmArID];
    self.theMessageClient = [[easyar_MessageClient alloc] initWithPlayerView:ARScene(self) name:@"Native" destName:@"TS" callback:^(NSString *from, easyar_Message *message) {
        NSLog(@"fromId: %@ \n id: %d",from,message.theId);
        if (message.theId == 1100) {
            NSString *jsonStr = [message.body getStringForKey:@"value"];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            NSString *title = dic[@"name"];
            NSLog(@"%@",dic);
            NSString *address = [NSString stringWithFormat:@"距您%@米 | %@",dic[@"detail_info"][@"distance"],dic[@"address"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.detailView showViewWith:title address:address];
            });
        }
    }];
    [self.timer setFireDate:[NSDate distantPast]];
}
- (void)creatSubView {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, (KIsiPhoneX?70:30), 62, 62);
    [self.backButton setImage:kGetImage(@"fanhui_icon") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];

    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(ScreenTJWidth/2.0-119/2.0, ScreenTJHeight-(KIsiPhoneX?28+34:28)-119, 119, 119);
    [self.searchButton setImage:kGetImage(@"search_button") forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    
    self.detailView = [[ARSearchDetailView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-304/2.0, ScreenTJHeight-87-149-KBottomHeight, 304, 87)];
    [self.view addSubview:self.detailView];
    [self.detailView hiddenView];
    
    self.searchView = [[ARSearchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.searchView];
    self.searchView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.searchView.searchBlock = ^(NSString * _Nonnull text) {
        if (text) {
            [weakSelf searchInfoWith:text];
            weakSelf.searchStr = text;
        }
        weakSelf.backButton.hidden = NO;
        weakSelf.searchButton.hidden = NO;
    };
}
- (void)backAction {
    [_sensorManger stopSensor];
    [_locationmanager stopUpdatingHeading];
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchButtonAction {
    self.searchView.hidden = NO;
    self.backButton.hidden = YES;
    self.searchButton.hidden = YES;
    [self.detailView hiddenView];
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)timerRunAction {
    if (self.searchStr) {
        [self searchInfoWith:self.searchStr];
    }
    if (self.longitude && self.latitude) {
        easyar_Dictionary*body = [easyar_Dictionary new];
        [body setFloat:self.longitude forKey:@"x"];
        [body setFloat:self.latitude forKey:@"y"];
        [self.theMessageClient send:[[easyar_Message alloc] initWithId:1250 body:body]];
    }
    
//    easyar_Dictionary*body = [easyar_Dictionary new];
//    [body setString:@"asa" forKey:@"targetId"];
//    [weakSelf.theMessageClient send:[[easyar_Message alloc] initWithId:12 body:body]];
}

- (void)loadEzp {
    //加载本地环境文件，主要打开摄像头
    __weak typeof(self) weakSelf = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"environment" ofType:@"ezp"];
    [ARScene(self) loadPackage:path onFinish:^{

    }];
    
}
- (void)loadmArID {
    
    __weak typeof(self) weakSelf = self;
    //OC 服务器配置
    //OC key和密钥
    //ar 发布方案arId
    //启动方案的ID，一个启动方案对应一种APP配置模式和一组本地及云识别的binding数据关系
    NSString *serverAddr = @"https://aroc-cn1.easyar.com";
    NSString *ocKey = @"0560a9dab192c15b15d7921c5091dc55";
    NSString *ocSecret = @"3314f279e3b94acefeb904794aadbc2937c11cb8714572f40ee5c6ebf9f52421";
    NSString *arId = @"5a594631-8202-4bbb-8dc8-150c6a773a36";
    
    OCClient*occ = [OCClient sharedClient];
    [occ setServerAddress:serverAddr];
    [occ setServerAccessKey:ocKey secret:ocSecret];
    [occ loadARAsset:arId completionHandler:^(OCARAsset *asset, NSError *error) {
        NSString*assetLocalAbsolutePath = [asset localAbsolutePath];
        if (assetLocalAbsolutePath) {
            //下载完成加载内容
            [ARScene(weakSelf) loadPackage:assetLocalAbsolutePath onFinish:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"loadARAsset Successfully!");
                    
                });
            }];
        } else {
            NSLog(@"下载失败 %@",arId);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    } progressHandler:^(NSString *taskName, float progress) {
        
    }];
}

- (void)searchInfoWith:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    NSString *key = @"Wp2U9nyGTbsbmuGWaG70mKNUMIZM0Ybz";
    NSString *location = @"39.915,116.404";
    NSString *urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?query=%@&scope=2&location=%@&radius=1000&output=json&ak=%@",text,self.location,key];
//    http://api.map.baidu.com/place/v2/search?query=%E7%BE%8E%E9%A3%9F&scope=2&location=39.915,116.404&radius=2000&output=json&ak=Wp2U9nyGTbsbmuGWaG70mKNUMIZM0Ybz
    NSLog(@"%@",urlStr);
//    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSessionDataTask *explainDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"searchInfoWith %@",error);
            return ;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"searchInfoWith %@",json);
        dispatch_async(dispatch_get_main_queue(), ^{
            easyar_Dictionary*body = [easyar_Dictionary new];
            [body setString:[weakSelf convertToJsonData:json] forKey:@"value"];
            [weakSelf.theMessageClient send:[[easyar_Message alloc] initWithId:1200 body:body]];
        });
    }];
    [explainDataTask resume];
}
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (void)startLocation {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationmanager = [[CLLocationManager alloc]init];
        self.locationmanager.delegate = self;
        [self.locationmanager requestAlwaysAuthorization];
        [self.locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationmanager.distanceFilter = 5.0;
        [self.locationmanager startUpdatingLocation];
    }
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
//    [self.locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    self.longitude = currentLocation.coordinate.longitude;
    self.latitude = currentLocation.coordinate.latitude;
    self.location = [NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    NSLog(@"location %@",self.location);
    
    //反地理编码
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
//     {
//         NSLog(@"反地理编码");
//         NSLog(@"反地理编码%ld",placemarks.count);
//         if (placemarks.count > 0) {
//             CLPlacemark *placeMark = placemarks[0];
//             /*看需求定义一个全局变量来接收赋值*/
//             NSLog(@"城市----%@",placeMark.country);//当前国家
//             NSLog(@"城市%@",placeMark.locality);//当前的城市
//             NSLog(@"%@",placeMark.subLocality);//当前的位置
//             NSLog(@"%@",placeMark.thoroughfare);//当前街道
//             NSLog(@"%@",placeMark.name);//具体地址
//
//         }
//     }];
    
}

- (void)dealloc {
    [_sensorManger stopSensor];
    [_locationmanager stopUpdatingHeading];
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    NSLog(@"**************ARSearchViewController********************");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
