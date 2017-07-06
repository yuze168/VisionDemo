//
//  VDFaceRectanglesViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/6/27.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDFaceRectanglesViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "VDUtility.h"
@interface VDFaceRectanglesViewController ()
{
}
@end

@implementation VDFaceRectanglesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脸检测";
    
    self.detectImageView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
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
            
            NSLog(@"当前图片的宽度是：%f 高度是：%f,人脸个数是：%ld 识别耗时是：%f", imageSize.width, imageSize.height, [request.results count], (CFAbsoluteTimeGetCurrent() - strongSelf.beginTime)*1000);
            
            VNDetectFaceRectanglesRequest *faceRequest = (VNDetectFaceRectanglesRequest *)request;
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI
                
                float imageScale = kScreenWidth/imageSize.width;
                
                strongSelf.detectImageView.image = [strongSelf faceBoundingBox:strongSelf.detectImage imageScale:imageScale results:faceRequest.results];
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

 // 在UIimage 上画矩形
- (UIImage *)faceBoundingBox:(UIImage *)detectImage imageScale:(float)imageScale results:(NSArray *)results
{
    CGSize imageSize = detectImage.size;
    imageSize.width *= imageScale;
    imageSize.height *= imageScale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, detectImage.size.height* imageScale), false, 1);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextDrawImage(contextRef, CGRectMake(0, 0, kScreenWidth, imageSize.height), detectImage.CGImage);
    //画矩形
    for (VNFaceObservation *observation in results) {
        CGRect boundingBox = [observation boundingBox];
        CGRect boundingRect =[VDUtility rectFromBoundingBox:boundingBox oriSize:imageSize];
        CGContextAddRect(contextRef, boundingRect);
    }
    
    CGContextSetLineWidth(contextRef, 1);
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor greenColor] CGColor]);
    CGContextStrokePath(contextRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
    
}

- (void)requestCoreMLInfo:(UIImage *)image
{
    self.beginTime = CFAbsoluteTimeGetCurrent();
    // 人脸信息
    VNDetectFaceRectanglesRequest * faceRequest = [[VNDetectFaceRectanglesRequest alloc]  initWithCompletionHandler:self.vNRequestHandle];
    
    // init  handler
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage orientation:image.imageOrientation options:@{}];
    [handler performRequests:@[faceRequest] error:nil];
}


@end
