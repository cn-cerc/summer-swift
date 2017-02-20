//
//  lhScanQCodeViewController.m
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import "ScanViewController.h"
#import "FLCodeView.h"
#import "CustemNavItemOC.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "RecogizeCardManager.h"

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

@interface ScanViewController ()<FLCodeView,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,CustemBBI>
{
    FLCodeView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (nonatomic,strong)G8RecognitionOperation *operation;

@property (nonatomic,strong)NSOperationQueue *queue;

@property (strong, nonatomic) CIDetector *detector;

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation ScanViewController

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 450, 200, 100)];
        
    }
    return _imageView;
}

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"扫描卡号"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [CustemNavItemOC initWithString:@"相册" andTarget:self andinfoStr:@"second"];
    //    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"ic_nav_back"] andTarget:self andinfoStr:@"first"];
    self.navigationItem.leftBarButtonItem = [CustemNavItemOC initWithImage:[UIImage imageNamed:@"ic_nav_back"] andTarget:self andinfoStr:@"first"];
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.operation cancel];
    [self.queue cancelAllOperations];
    self.operation = nil;
    self.queue = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏返回
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"first"]) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(backBar)]) {
            [self.delegate backBar];
        }
    }else if ([infoStr isEqualToString:@"second"]){
        [readview stop];
        [self alumbBtnEvent];
    }
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[FLCodeView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
//    [self.view addSubview:self.imageView];
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        return;
    }
    
    isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"==== %@ ",mediaType);
    UIImage *srcImage = nil;
    //判断资源类型
    if ([mediaType isEqualToString:@"public.image"]) {
        srcImage = info[UIImagePickerControllerEditedImage];
        
        [self recognizeImageWithTesseract:srcImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

#pragma mark -QRCodeReaderViewDelegate 代理方法
- (void)readerScanResult:(UIImage *)result
{
    self.imageView.image = result;
    [self recognizeImageWithTesseract:result];
}

#pragma mark - 判断字符串是否为数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
#if 0
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [readview start];
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [readview stop];
        if (str != nil) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(scanCardReturn:)]) {
                [self.delegate scanCardReturn:str];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [readview start];
        }
        
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
#endif
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanCardReturn:)]) {
        [self.delegate scanCardReturn:str];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    [readview start];
}

-(void)recordAction
{
    [readview loopDrawLine];
}

#pragma mark - 识别健康卡卡号
-(void)recognizeImageWithTesseract:(UIImage *)image
{
    self.queue = [[NSOperationQueue alloc] init];
    self.operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
    self.operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    self.operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    self.operation.delegate = self;
    self.operation.tesseract.image = image;
    __weak typeof(self) weakSelf = self;
    weakSelf.operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        
        recognizedText = [recognizedText stringByReplacingOccurrencesOfString:@" " withString:@""];
        recognizedText = [recognizedText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        recognizedText = [recognizedText stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@", recognizedText);
        
        for (int i = 0; i<recognizedText.length; i++) {
            if (i > recognizedText.length-17 || recognizedText.length < 17) {
                break;
            }
            NSString *newStr = [recognizedText substringWithRange:NSMakeRange(i, 17)];
            if ([weakSelf isPureInt:newStr]) {
                NSLog(@"newstr = %@",newStr);
                [readview stop];
                [weakSelf accordingQcode:newStr];
                break;
            }
        }
    };
    
//    self.imageView.image = operation.tesseract.thresholdedImage;
    [self.queue addOperation:self.operation];
    self.operation = nil;
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}

-(void)dealloc
{
    
}

@end
