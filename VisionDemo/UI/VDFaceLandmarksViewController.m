//
//  VDFaceLandmarksViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/6/28.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDFaceLandmarksViewController.h"
#import "VDUtility.h"

@interface VDFaceLandmarksViewController ()
{
    VNDetectFaceRectanglesRequest *_faceRectanglesRequest;
}

@end

@implementation VDFaceLandmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"特征提取";
    self.detectImageView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
}


#pragma  mark - 子类实现 -
- (void) createHandler
{
    // 人脸信息
    __weak typeof(self) weakSelf = self;
    self.vNRequestHandle =  ^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        VNDetectFaceRectanglesRequest *faceRectReq = strongSelf->_faceRectanglesRequest;
        
        // count是识别出来的人脸个数
        if ([request.results count] > 0) {
            CGSize imageSize= strongSelf.detectImage.size;
            
            NSLog(@"当前图片的宽度是：%f 高度是：%f,人脸个数是：%ld 识别耗时是：%f", imageSize.width, imageSize.height, [request.results count], (CFAbsoluteTimeGetCurrent() - strongSelf.beginTime)*1000);
            
            VNDetectFaceLandmarksRequest *faceLMRequest = (VNDetectFaceLandmarksRequest *)request;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI
                float imageScale = kScreenWidth/imageSize.width;
                    
                strongSelf.detectImageView.image = [strongSelf faceBoundingBox:strongSelf.detectImage imageScale:imageScale boundingResults:faceRectReq.results faceLMResults:faceLMRequest.results];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.detectImageView.image = nil;
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"特征检测" message:@"没有找到人脸信息" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            });
        }
    };
    
}


// 在UIimage 上画点
- (UIImage *)faceBoundingBox:(UIImage *)detectImage imageScale:(float)imageScale boundingResults:(NSArray *)boundingResults faceLMResults:(NSArray *)faceLMResults
{
    
    // 人脸识别
    VNFaceObservation *faceDectOb = [boundingResults firstObject];
    
    // 人脸特征
    VNFaceObservation *faceLMOb = [faceLMResults firstObject];
    VNFaceLandmarks2D *landmarks = faceLMOb.landmarks;
    
    // 图片尺寸
    CGSize imageSize = detectImage.size;
    imageSize.width *= imageScale;
    imageSize.height *= imageScale;
    
    CGRect boundingBox = [faceDectOb boundingBox];
    CGRect boundingRect =[VDUtility rectFromBoundingBox:boundingBox oriSize:imageSize];
    
    // 设置画板
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, detectImage.size.height* imageScale), false, 1);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextDrawImage(contextRef, CGRectMake(0, 0, kScreenWidth, imageSize.height), detectImage.CGImage);
    
    // 画脸
    VNFaceLandmarkRegion2D *faceContour=  landmarks.faceContour;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:faceContour boundingRect:boundingRect];
    
    // 画左眼
    VNFaceLandmarkRegion2D *leftEyeRegin=  landmarks.leftEye;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:leftEyeRegin boundingRect:boundingRect];
    
    // 画右眼
    VNFaceLandmarkRegion2D *rightEyeRegin=  landmarks.rightEye;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:rightEyeRegin boundingRect:boundingRect];
    
    // 左眉毛
    VNFaceLandmarkRegion2D *leftEyebrow=  landmarks.leftEyebrow;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:leftEyebrow boundingRect:boundingRect];
    
    // 右眉毛
    VNFaceLandmarkRegion2D *rightEyebrow=  landmarks.rightEyebrow;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:rightEyebrow boundingRect:boundingRect];
    
    // 鼻子
    VNFaceLandmarkRegion2D *nose=  landmarks.nose;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:nose boundingRect:boundingRect];
    
    // 鼻嵴
    VNFaceLandmarkRegion2D *noseCrest=  landmarks.noseCrest;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:noseCrest boundingRect:boundingRect];
    
    //正中线
    VNFaceLandmarkRegion2D *medianLine=  landmarks.medianLine;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:medianLine boundingRect:boundingRect];
    
    //外嘴唇
    VNFaceLandmarkRegion2D *outerLips=  landmarks.outerLips;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:outerLips boundingRect:boundingRect];
    
    //内嘴唇
    VNFaceLandmarkRegion2D *innerLips=  landmarks.innerLips;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:innerLips boundingRect:boundingRect];
    
    //  左瞳孔
    VNFaceLandmarkRegion2D *leftPupil=  landmarks.leftPupil;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:leftPupil boundingRect:boundingRect];
    
    //  右瞳孔
    VNFaceLandmarkRegion2D *rightPupil=  landmarks.rightPupil;
    [self drawLandMarksInCGContextRef:contextRef faceLandmarkRegion2D:rightPupil boundingRect:boundingRect];
    
    CGContextStrokePath(contextRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
    
}

// 画点
- (void)drawLandMarksInCGContextRef:(CGContextRef )contextRef faceLandmarkRegion2D:(VNFaceLandmarkRegion2D *)faceLandmarkRegion2D boundingRect:(CGRect)boundingRect
{
    NSMutableArray *landMarkPoints = [self convertPointsForFace:faceLandmarkRegion2D boundingBox:boundingRect];
    [landMarkPoints enumerateObjectsUsingBlock:^(NSValue * pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [pointValue CGPointValue];
        CGContextSetFillColorWithColor(contextRef, [[UIColor greenColor] CGColor]);//填充颜色
        CGContextSetLineWidth(contextRef, 0.1);//线的宽度
        CGContextAddArc(contextRef, point.x, point.y, 2, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(contextRef, kCGPathFillStroke); //绘制路径加填充
    }];
}

// 计算landmark 在图片上的点
- (NSMutableArray *)convertPointsForFace:(VNFaceLandmarkRegion2D *)landmark boundingBox:(CGRect) boundingBox
{
    NSInteger count = landmark.pointCount;
    
    NSMutableArray *pointsInImage = [NSMutableArray arrayWithCapacity:count];
    
    for (int index = 0; index < count; index++) {
        
        vector_float2 *lmPoints =(vector_float2 *)landmark.points;
        
        CGPoint lmPoint = CGPointMake((CGFloat)(lmPoints[index].x),
                                    (CGFloat)(lmPoints[index].y));
        
        CGFloat pointX = lmPoint.x * boundingBox.size.width + boundingBox.origin.x ;
        CGFloat pointY = lmPoint.y  *boundingBox.size.height + boundingBox.origin.y;
        
        [pointsInImage addObject:[NSValue valueWithCGPoint:CGPointMake(pointX, pointY)]];
    }
    
    return pointsInImage;
}

- (void)requestCoreMLInfo:(UIImage *)image
{
    VNDetectFaceRectanglesRequest *faceRectanglesRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        _faceRectanglesRequest = (VNDetectFaceRectanglesRequest *)request;
    }];
    
    self.beginTime = CFAbsoluteTimeGetCurrent();
    // 人脸特性信息
    VNDetectFaceLandmarksRequest * faceLandmarksRequest = [[VNDetectFaceLandmarksRequest alloc]  initWithCompletionHandler:self.vNRequestHandle];
    
    // init  handler
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage orientation:image.imageOrientation options:@{}];
    [handler performRequests:@[faceRectanglesRequest, faceLandmarksRequest] error:nil];

}

@end
