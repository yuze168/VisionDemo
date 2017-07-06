//
//  VDViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/6/28.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Vision/Vision.h>

@interface VDViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{

}
@end

@implementation VDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *albumButton =[[UIButton alloc] initWithFrame:CGRectMake(40.f, 0.f, 40, 44)];
    
    [albumButton setTitle:@"相册" forState:UIControlStateNormal];
    [albumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    albumButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [albumButton addTarget:self action:@selector(albumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shootButton =[[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40, 44)];
    
    [shootButton setTitle:@"拍摄" forState:UIControlStateNormal];
    [shootButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shootButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [shootButton addTarget:self action:@selector(shootButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightView addSubview: albumButton];
    [rightView addSubview: shootButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    _detectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _detectImageView.backgroundColor = [UIColor clearColor];
    _detectImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_detectImageView];
    [self createHandler];
    
}

- (void)shootButtonClick:(UIButton *)sender {
    
}

- (void)albumButtonClick:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        CGRect boundingRect = CGRectMake(boundingBox.origin.x *imageSize.width, boundingBox.origin.y * imageSize.height , boundingBox.size.width *imageSize.width, boundingBox.size.height *imageSize.height);
        
        CGContextAddRect(contextRef, boundingRect);
    }
    
    CGContextSetLineWidth(contextRef, 1);
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor greenColor] CGColor]);
    CGContextStrokePath(contextRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
    
}
#pragma mark - UIImagePickerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _detectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self requestCoreMLInfo:_detectImage];
        });
    }];
    
}

#pragma  mark - 子类实现 -
- (void)createHandler
{
}

- (void)requestCoreMLInfo:(UIImage *)image
{
    
}

@end
