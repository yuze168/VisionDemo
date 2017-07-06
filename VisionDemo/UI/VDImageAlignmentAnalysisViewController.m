//
//  VDImageAlignmentAnalysisViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/7/2.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDImageAlignmentAnalysisViewController.h"
#import "VDUtility.h"

@interface VDImageAlignmentAnalysisViewController ()

@end

@implementation VDImageAlignmentAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图像对齐";
}

- (void) createHandler
{
    // 人脸信息
    __weak typeof(self) weakSelf = self;
    self.vNRequestHandle =  ^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // count是识别出来的人脸个数
        if ([request.results count] > 0) {
            CGSize imageSize= strongSelf.detectImage.size;
            
            NSLog(@"当前图片的宽度是：%f 高度是：%f, 识别耗时是：%f", imageSize.width, imageSize.height, (CFAbsoluteTimeGetCurrent() - strongSelf.beginTime)*1000);
            
            VNTranslationalImageRegistrationRequest *tranImageRequest = (VNTranslationalImageRegistrationRequest *)request;
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI
               VNImageTranslationAlignmentObservation *imageTranAligOb = [tranImageRequest.results firstObject];
                CGAffineTransform transform =  imageTranAligOb.alignmentTransform;
                strongSelf.detectImageView.image = strongSelf.detectImage;
//                strongSelf.detectImageView.transform = transform;
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.detectImageView.image = nil;
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"人脸检测" message:@"没有找到人脸信息" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            });
        }
    };
}

- (void)requestCoreMLInfo:(UIImage *)image
{
    self.beginTime = CFAbsoluteTimeGetCurrent();
    // 全息图像配准
    VNHomographicImageRegistrationRequest * homImageRe = [[VNHomographicImageRegistrationRequest alloc]  initWithTargetedCGImage:image.CGImage completionHandler:self.vNRequestHandle];
    
    VNTranslationalImageRegistrationRequest *tranImageRe = [[VNTranslationalImageRegistrationRequest alloc] initWithTargetedCGImage:image.CGImage completionHandler:self.vNRequestHandle];
    // init  handler
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage orientation:image.imageOrientation options:@{}];
    [handler performRequests:@[tranImageRe] error:nil];
}


@end
