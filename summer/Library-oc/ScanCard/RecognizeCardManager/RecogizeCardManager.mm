//
//  RecogizeCardManager.m
//  RecognizeCard
//
//  Created by 谭高丰 on 16/8/31.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "RecogizeCardManager.h"



@implementation RecogizeCardManager

+ (instancetype)recognizeCardManager {
    static RecogizeCardManager *recognizeCardManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizeCardManager = [[RecogizeCardManager alloc] init];
    });
    return recognizeCardManager;
}

- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate {
    //扫描身份证图片，并进行预处理，定位号码区域图片并返回
    UIImage *numberImage = [self opencvScanCard:cardImage];
    if (numberImage == nil) {
        compleate(nil);
    }
    //利用TesseractOCR识别文字
    [self tesseractRecognizeImage:numberImage compleate:^(NSString *numbaerText) {
        compleate(numbaerText);
    }];
}


//扫描身份证图片，并进行预处理，定位号码区域图片并返回
//利用TesseractOCR识别文字
- (void)tesseractRecognizeImage:(UIImage *)image compleate:(CompleateBlock)compleate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        tesseract.image = [image g8_blackAndWhite];
        tesseract.image = image;
        // Start the recognition
        [tesseract recognize];
        //执行回调
        compleate(tesseract.recognizedText);
    });
}

@end
