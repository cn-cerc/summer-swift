//
//  ARSpiritViewController.m
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/9.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARSpiritViewController.h"
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
#import <iflyMSC/iflyMSC.h>
#import <easyar/recorder.oc.h>
#import <easyar/renderer.oc.h>
#import <easyar/recorder_configuration.oc.h>
#import <easyar/callbackscheduler.oc.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "ARSpiritVideoView.h"
#import "ARSpiritVoiceTextView.h"
#import "TJAVplayerView.h"

/**检测录音是否*/
static bool permissionChecked = false;


@interface ARSpiritViewController () <IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//语音听写
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;//语音合成
@property (strong, nonatomic) easyar_MessageClient *theMessageClient;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *centerButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *centerLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (nonatomic, strong) easyar_Recorder *recorder;
@property (atomic, assign) int recorderId;
@property (nonatomic, strong) ARSpiritVideoView *spiritVideoView;
@property (nonatomic, strong) UIImageView *recodeOverView;
@property (nonatomic, strong) ARSpiritVoiceTextView *voiceTextView;
@property (nonatomic, strong) UIImageView *voicePrompt;
@property (nonatomic, strong) TJAVplayerView *playerView;




@end

@implementation ARSpiritViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    [IFlySpeechUtility createUtility:initString];
    
    [easyar_Player initialize:kEasyAR3DAppKey];
    //配置AR界面显示
    self.view = [[easyar_PlayerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [ARScene(self) setFPS:40];
    
    //UserFileSystem提供一种TS内容的访问方式。TS可以访问project://和user://形式的资源
    UserFileSystem *fileSystem = [[UserFileSystem alloc] init];
    [fileSystem setUserRootDir:[NSString stringWithFormat:@"%@/",[NSBundle mainBundle].bundlePath]];
    [ARScene(self) setFileSystem:fileSystem];
    
    [self loadEzp];
    
    self.theMessageClient = [[easyar_MessageClient alloc] initWithPlayerView:ARScene(self) name:@"Native" destName:@"TS" callback:^(NSString *from, easyar_Message *message) {
        NSLog(@"fromId: %@ \n id: %d",from,message.theId);
    }];
    
    [self creatSubView];
    [self loadmArID];
//    __weak typeof(self) weakSelf = self;
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
}
- (void)creatSubView {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, (KIsiPhoneX?70:30), 62, 62);
    [self.backButton setImage:kGetImage(@"fanhui_icon") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
 
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(28, ScreenTJHeight-57-72, 72, 72);
    [self.leftButton setImage:kGetImage(@"disappear_icon") forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, ScreenTJHeight-44-18, 72, 18)];
    self.leftLabel.font = FontTJ(13);
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.text = @"召回";
    self.leftLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.leftLabel];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.frame = CGRectMake(ScreenTJWidth/2.0-82/2.0, ScreenTJHeight-59-82, 82, 82);
    [self.centerButton setImage:kGetImage(@"voice_icon") forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(centerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.centerButton];
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-72/2.0, ScreenTJHeight-44-18, 72, 18)];
    self.centerLabel.font = FontTJ(13);
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.text = @"来撩我";
    self.centerLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.centerLabel];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(ScreenTJWidth-28-72, ScreenTJHeight-57-72, 72, 72);
    [self.rightButton setImage:kGetImage(@"video_icon") forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenTJWidth-28-72, ScreenTJHeight-44-18, 72, 18)];
    self.rightLabel.font = FontTJ(13);
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.text = @"录屏";
    self.rightLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.rightLabel];
    
    
    self.spiritVideoView = [[ARSpiritVideoView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-65/2.0, ScreenTJHeight-65-(KIsiPhoneX?27+34:27), 65, 65)];
    [self.view addSubview:self.spiritVideoView];
    [self.spiritVideoView hiddenView];
    __weak typeof(self) weakSelf = self;
    self.spiritVideoView.arSpiritVideoBlock = ^(NSString * _Nonnull type) {
        if ([type isEqualToString:@"start"]) {
            if (![weakSelf judgeCameraLimits]) {
                return;
            }
            if (![weakSelf checkMicrophone]) {
                return;
            }
            NSLog(@"录屏");
            [weakSelf checkPermission];
        } else if ([type isEqualToString:@"over"]) {
            NSLog(@"录屏结束操作");
            [weakSelf stopRecording];
        }
    };
    
    self.recodeOverView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-179/2.0, ScreenTJHeight-94-54-(KIsiPhoneX?27+34:27), 179, 54)];
    [self.recodeOverView setImage:kGetImage(@"tishi_window")];
    [self.view addSubview:self.recodeOverView];
    self.recodeOverView.hidden = YES;
    
    self.voiceTextView = [[ARSpiritVoiceTextView alloc] initWithFrame:CGRectMake(ScreenTJWidth/2.0-309/2.0, (KIsiPhoneX?164+40:164), 309, 82)];
    [self.view addSubview:self.voiceTextView];
    
    self.voicePrompt = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 123, 123)];
    [self.voicePrompt setImage:kGetImage(@"shuohua")];
    self.voicePrompt.center = self.view.center;
    [self.view addSubview:self.voicePrompt];
    self.voicePrompt.hidden = YES;
}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)leftButtonAction {
    static BOOL isShow = YES;
    NSString *type = @"y";
    if (isShow) {
        [self.leftButton setImage:kGetImage(@"disappear_icon") forState:UIControlStateNormal];
        self.leftLabel.text = @"召回";
        type = @"n";
    } else {
        [self.leftButton setImage:kGetImage(@"appear_icon") forState:UIControlStateNormal];
        self.leftLabel.text = @"召出";
        type = @"y";
    }
    isShow = !isShow;
    easyar_Dictionary*body = [easyar_Dictionary new];
    [body setString:type forKey:@"active"];
    [self.theMessageClient send:[[easyar_Message alloc] initWithId:1010 body:body]];
}
- (void)centerButtonAction {
    if (self.iFlySpeechRecognizer.isListening) {
        return;
    }
    [self.iFlySpeechRecognizer startListening];
    self.voicePrompt.hidden = NO;
}
- (void)rightButtonAction {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.centerButton.hidden = YES;
    self.spiritVideoView.hidden = NO;
    self.leftLabel.hidden = YES;
    self.centerLabel.hidden = YES;
    self.rightLabel.hidden = YES;
}
#pragma mark - 获取文字回答
- (void)getAnswerWith:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://api.turingos.cn/turingos/api/v2"];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //5.设置请求体
    NSDictionary *dict = @{@"key":@"d8336a2db103406d8163dee0bf410f74",@"timestamp":@"PpOB9I4KR6UPy7ik",@"data":@{@"content":@[@{@"data":text}],@"userInfo":@{@"uniqueId":@"uniqueId"}}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    request.HTTPBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //        request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSLog(@"%@",text);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"%@",dict);
        NSString *str = @"";
        for (NSDictionary *dic in dict[@"results"]) {
            if ([dic[@"resultType"] isEqualToString:@"text"]) {
                str = dic[@"values"][@"text"];
                NSLog(@"%@",dic[@"values"][@"text"]);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //启动合成会话
            [weakSelf.iFlySpeechSynthesizer startSpeaking:str];
            [weakSelf.voiceTextView showViewWithVoice:str];
        });
    }];
    //7.执行任务
    [dataTask resume];
}
#pragma mark - 语音听写 IFlySpeechRecognizerDelegate协议实现
- (IFlySpeechRecognizer *)iFlySpeechRecognizer {
    if (!_iFlySpeechRecognizer) {
        //创建语音识别对象
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        _iFlySpeechRecognizer.delegate = self;
        //设置识别参数
        //设置为听写模式
        [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
        [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    }
    return _iFlySpeechRecognizer;
}
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    if (!results) {
        return;
    }
    static NSString *resultStr = @"";
    NSLog(@"识别结果 %@",results);
    NSString *str = [results[0] allKeys][0];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *ws in dic[@"ws"]) {
        for (NSDictionary *cw in ws[@"cw"]) {
            resultStr = [resultStr stringByAppendingString:cw[@"w"]];
        }
    }
    NSLog(@"识别结果 %@",resultStr);
    if (isLast) {
        [self getAnswerWith:resultStr];
        self.voicePrompt.hidden = YES;
        resultStr = @"";
    }
}
//识别会话结束返回代理  //合成结束
- (void)onCompleted: (IFlySpeechError *) error{
    NSLog(@"识别会话结束 %d %@",error.errorCode,error.errorDesc);
    if (self.voicePrompt.hidden == NO) {
        self.voicePrompt.hidden = YES;
    }
    if (self.voiceTextView.hidden == NO) {
        self.voiceTextView.hidden = YES;
    }
}
//停止录音回调
- (void) onEndOfSpeech{
    
}
//开始录音回调
- (void) onBeginOfSpeech{
    
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
    
}
//会话取消回调
- (void) onCancel{
    
}
#pragma mark - 语音合成 IFlySpeechSynthesizerDelegate协议实现
- (IFlySpeechSynthesizer *)iFlySpeechSynthesizer {
    if (!_iFlySpeechSynthesizer) {
        //获取语音合成单例
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        //设置协议委托对象
        _iFlySpeechSynthesizer.delegate = self;
        //设置合成参数
        //设置在线工作方式
        [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                      forKey:[IFlySpeechConstant ENGINE_TYPE]];
        //设置音量，取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50"
                                      forKey: [IFlySpeechConstant VOLUME]];
        //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
        [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
                                      forKey: [IFlySpeechConstant VOICE_NAME]];
        //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
        [_iFlySpeechSynthesizer setParameter:@" tts.pcm"
                                      forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    }
    return _iFlySpeechSynthesizer;
}
//合成开始
- (void) onSpeakBegin {
    
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    
}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    
}

#pragma mark - 内容加载
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
    NSString *arId = @"a212e23f-8193-4482-8e71-2d7d0309bb64";
    
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
#pragma mark record ---
- (void) checkPermission
{
    __weak typeof(self) weakSelf = self;
    if(!permissionChecked)
    {
        if (!self.recorder) {
            [weakSelf createRecorder];
        }
        
        [easyar_Recorder requestPermissions:[easyar_ImmediateCallbackScheduler getDefault] permissionCallback:^(easyar_PermissionStatus status, NSString * value){
            
            //auto d = [[NSData alloc] initWithBytes:v.data() length:v.length()];
            //auto value =  [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            NSLog(@" permission value: %@, int: %d", value, (int)status);
            [weakSelf asyncPermissionStatus: status];
        }];
        
        
    }
    
}

- (void) asyncPermissionStatus:(easyar_PermissionStatus)status
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        switch (status) {
            case easyar_PermissionStatus_Granted:
            {
                permissionChecked = YES;
                //开始录屏
                if (self.recorder == nil) {
                    [self createRecorder];
                }
                [self startRecording];
            }
                break;
            case easyar_PermissionStatus_Denied:
                
            {
                permissionChecked = NO;
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"权限通知" message:@"录屏相关权限被关闭，请开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alertview show];
            }
                
                break;
            case easyar_PermissionStatus_Error:
            {
                permissionChecked = NO;
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"权限通知" message:@"录屏相关权限错误，请正确开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alertview show];
            }
                break;
            default:
                assert(false);
                break;
        }
        
    });
}

-(void) createRecorder
{
    
    __weak typeof(self) weakSelf = self;
    //prepare config
    easyar_RecorderConfiguration* config = [easyar_RecorderConfiguration create];
    NSString* url = [self prepareURL];
    [config setOutputFile:url];
    [config setProfile:easyar_RecordProfile_Quality_720P_Middle];
    [config setVideoBitrate:2500000];
    [config setVideoOrientation:easyar_RecordVideoOrientation_Portrait];
    [config setZoomMode:easyar_RecordZoomMode_NoZoomAndClip];
    
    self.recorder = [easyar_Recorder create:config callbackScheduler:[easyar_ImmediateCallbackScheduler getDefault] statusCallback:^(easyar_RecordStatus status, NSString *value) {
        NSLog(@" Recorder status: %d %@", (int)status, value);
        
        switch (status) {
            case easyar_RecordStatus_OnStarted:
            {
                
            }
                break;
            case easyar_RecordStatus_OnStopped:
            {
                permissionChecked = NO;
            }
                break;
            case easyar_RecordStatus_FileSucceeded:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    permissionChecked = NO;
                    //保存文件到相册
                    if (![weakSelf checkAumbleLists]) {
                        return ;
                    }else {
                        //保存视频到相册
                        UISaveVideoAtPathToSavedPhotosAlbum(url, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                    }
                });
                
            }
                break;
            case easyar_RecordStatus_FailedToStart:
            {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"录屏通知" message:@"录屏失败，请检查！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alertview show];
            }
                break;
            default:
                break;
        }
    }];
}

-(void) startRecording
{
    
    assert(self.recorder !=  nil);
    __weak typeof(self) weakSelf = self;
    self.recorderId = [ARScene(self) addPostRenderCallback:^(int texture, unsigned int width, unsigned int height){
        typeof(self) s = weakSelf;
        [s.recorder updateFrame:[easyar_TextureId fromInt:texture] width:(int)width height:(int)height];
    }];
    
    assert(self.recorderId != -1);
    [self.recorder start];
    
}

-(void) stopRecording
{
    assert(self.recorder != nil);
    [self.recorder stop];
    assert(self.recorderId != -1);
    [ARScene(self) removePostRenderCallback:self.recorderId];
    self.recorder = nil;
    self.recorderId = -1;
}

-(NSString*) prepareURL
{
    static long size = 0;
    size ++ ;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *album = [docDir stringByAppendingPathComponent:@"album"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:album]) {
        NSLog(@"first run");
        [[NSFileManager defaultManager] createDirectoryAtPath:album withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",album);
    }
    double timenumber = [NSDate date].timeIntervalSince1970;
    NSLog(@"timenumber %lf",timenumber);
    NSString *time = [NSString stringWithFormat:@"%lf",timenumber];
    time = [time stringByReplacingOccurrencesOfString:@"." withString:@"mm"];
    NSLog(@"%@",time);
    NSString *videoString = [NSString stringWithFormat:@"%@number%08ld.mp4",time,size];
    NSString *path = [NSString stringWithFormat:@"%@/%@",album,videoString];
    NSLog(@"path %@",path);
    //self.path = path;
    return path;
}

#pragma mark 权限监测
- (BOOL)judgeCameraLimits{
    /// 先判断摄像头硬件是否好用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        // 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"相机权限未打开，请在系统设置中开启。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
            [alert show];
            return false;
        }else{
            // 这里是摄像头可以使用的处理逻辑
            return YES;
        }
    } else {
        // 硬件问题提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"相机权限未打开，请在系统设置中开启。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
        [alert show];
        return false;
    }
    return YES;
}

//相册权限
- (BOOL)checkAumbleLists {
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法访问您的相册" message:@"请在系统设置中打开权限开关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去打开", nil];
        [alert show];
        return NO;
    }else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
        return YES;
    }
    return YES;
}
//检测麦克风
- (BOOL)checkMicrophone {
    // 用户是否允许麦克风使用
    NSString * mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    // 不允许弹出提示框
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"麦克风权限未打开，请在系统设置中开启。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
        [alert show];
        return NO;
    }else{
        // 这里是摄像头可以使用的处理逻辑
        return YES;
    }
    
}
//获取权限
- (void)getMicrophone
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"save to System photo album error %@",error);
    } else {
        NSLog(@"save to System photo album Success");
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
        self.spiritVideoView.hidden = YES;
        UILabel *toast = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        toast.center = self.view.center;
        toast.textAlignment = NSTextAlignmentCenter;
        toast.layer.masksToBounds = YES;
        toast.layer.cornerRadius = 5;
        toast.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        toast.textColor = [UIColor whiteColor];
        toast.text = @"保存视频失败";
        [self.view addSubview:toast];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast removeFromSuperview];
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            self.centerButton.hidden = NO;
            self.leftLabel.hidden = NO;
            self.centerLabel.hidden = NO;
            self.rightLabel.hidden = NO;
        });
    } else {
        self.spiritVideoView.hidden = YES;
        self.recodeOverView.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.recodeOverView.hidden = YES;
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            self.centerButton.hidden = NO;
            self.leftLabel.hidden = NO;
            self.centerLabel.hidden = NO;
            self.rightLabel.hidden = NO;
        });
    }
    NSLog(@"视频保存成功.");
}


- (void)dealloc {
    [_iFlySpeechRecognizer destroy];
    [IFlySpeechSynthesizer destroy];
    NSLog(@"**********ARSpiritViewController*************");
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
