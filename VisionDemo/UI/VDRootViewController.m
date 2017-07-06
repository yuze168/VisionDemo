//
//  VDRootViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/6/27.
//  Copyright © 2017年 高永祥. All rights reserved.
//
#define kFaceRectangles  1234  // 人脸识别
#define kFaceLandmarks   1235   // 人脸特性提取
#define kBarcodeDetection   1236  //  矩阵码/条形码检测
#define kImageAlignmentAnalysis 1237  // 图像对齐分析
#define kTextDetection 1238  //文字检测
#define kHorizonDetection 1239  //水平面检测
#define kObjectDetectionAndTracking 1240  //物体检测和追踪

#import "VDRootViewController.h"
#import "VDFaceRectanglesViewController.h"
#import "VDFaceLandmarksViewController.h"
#import "VDBarcodeDetectionViewController.h"
#import "VDImageAlignmentAnalysisViewController.h"
#import "VDTextDetectionViewController.h"
#import "VDHorizonDetectionViewController.h"
#import "VDObjectDetectionAndTrackingViewController.h"

@interface VDRootViewController ()

@end

@implementation VDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"VD";
    
    CGFloat  indent_y = 70;
    CGFloat y = 90;
    NSInteger i = 0;
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"人脸检测" tag:kFaceRectangles];
    
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"人脸特性提取" tag:kFaceLandmarks];
    
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"条形码检测" tag:kBarcodeDetection];
    
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"图像对齐" tag:kImageAlignmentAnalysis];
    
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"文字检测" tag:kTextDetection];
    
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"水平面检测" tag:kHorizonDetection];
    
    [self createButtonWithCenter:CGPointMake(self.view.bounds.size.width/2, (y + indent_y *i++)) title:@"物体检测和追踪" tag:kObjectDetectionAndTracking];
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

-(void)createButtonWithCenter:(CGPoint)center title:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 200, 50)];
    button.backgroundColor = [UIColor colorWithRed:1 green:218/255.f blue:185/255.f alpha:1];
    button.center = center;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case kFaceRectangles:   // 人脸识别
        {
            VDFaceRectanglesViewController *fRVC = [VDFaceRectanglesViewController new];
            [self.navigationController pushViewController:fRVC animated:YES];
        }
            break;
        case kFaceLandmarks:    // 人脸特性提取
        {
            VDFaceLandmarksViewController *fLVC = [VDFaceLandmarksViewController new];
            [self.navigationController pushViewController:fLVC animated:YES];
            
        }
            break;
            
        case kBarcodeDetection: // 矩阵码/条形码检测
        {
            VDBarcodeDetectionViewController *fLVC = [VDBarcodeDetectionViewController new];
            [self.navigationController pushViewController:fLVC animated:YES];
            
        }
            break;
        case kImageAlignmentAnalysis:   // 图像对齐分析
        {
            VDImageAlignmentAnalysisViewController *fLVC = [VDImageAlignmentAnalysisViewController new];
            [self.navigationController pushViewController:fLVC animated:YES];
            
        }
            break;
        case kTextDetection:  //文字检测
        {
            VDTextDetectionViewController *fLVC = [VDTextDetectionViewController new];
            [self.navigationController pushViewController:fLVC animated:YES];
        }
            break;
        case kHorizonDetection:  //水平面检测
        {
            VDHorizonDetectionViewController *fLVC = [VDHorizonDetectionViewController new];
            [self.navigationController pushViewController:fLVC animated:YES];
            
        }
            break;
        case kObjectDetectionAndTracking: //物体检测和追踪
        {
            VDObjectDetectionAndTrackingViewController *fLVC = [VDObjectDetectionAndTrackingViewController new];
            [self.navigationController pushViewController:fLVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


@end
