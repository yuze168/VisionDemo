//
//  VDHorizonDetectionViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/7/2.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDHorizonDetectionViewController.h"

@interface VDHorizonDetectionViewController ()

@end

@implementation VDHorizonDetectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文字识别";
    
//    self.detectImageView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    
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
            
            VNDetectHorizonRequest *horizonDetect = (VNDetectHorizonRequest *)request;
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI
                VNHorizonObservation *horOb =  [horizonDetect.results firstObject];
                CGAffineTransform transform =  horOb.transform ;
                CGFloat angle = horOb.angle;
                
                strongSelf.detectImageView.image = strongSelf.detectImage;
                
                strongSelf.detectImageView.transform = CGAffineTransformRotate(transform, angle);
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.detectImageView.image = nil;
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"水平线检测" message:@"没有找到图片" preferredStyle:UIAlertControllerStyleAlert];
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
    
    //
    VNDetectHorizonRequest *horizonDetect = [[VNDetectHorizonRequest alloc] initWithCompletionHandler:self.vNRequestHandle];
    // init  handler
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:@{}];
    [handler performRequests:@[horizonDetect] error:nil];
}


@end
