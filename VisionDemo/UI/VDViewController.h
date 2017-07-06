//
//  VDViewController.h
//  VisionDemo
//
//  Created by 高永祥 on 2017/6/28.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

@interface VDViewController : UIViewController

@property (nonatomic, copy)  VNRequestCompletionHandler  vNRequestHandle;

@property (nonatomic, strong)  UIImageView * detectImageView;
@property (nonatomic, strong)  UIImage * detectImage;

@property (nonatomic, assign)  CFAbsoluteTime beginTime;

- (void)albumButtonClick:(UIButton *)sender;
- (void)shootButtonClick:(UIButton *)sender;

@end
