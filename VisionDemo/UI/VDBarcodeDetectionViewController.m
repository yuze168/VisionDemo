//
//  VDBarcodeDetectionViewController.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/7/2.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDBarcodeDetectionViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VDBarcodeDetectionViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;//输入输出的中间桥梁
    
}

@end

@implementation VDBarcodeDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"条码扫描";
    
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        //获取到信息后停止扫描:
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串:
        NSLog(@"%@", metaDataObject.stringValue);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别内容" message:metaDataObject.stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_session startRunning];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)startScanWithSize:(CGFloat)sizeValue
{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //判断输入流是否可用
    if (input) {
        //创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        _session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //设置为宽高为200的正方形区域相对于屏幕居中
        layer.frame = CGRectMake((self.view.bounds.size.width - sizeValue) / 2.0, (self.view.bounds.size.height - sizeValue) / 2.0, sizeValue, sizeValue);
        [self.detectImageView.layer insertSublayer:layer atIndex:0];
        //开始捕获图像:
        [_session startRunning];
    }
}
#pragma  mark - 子类实现 -
- (void)albumButtonClick:(UIButton *)sender
{
    //移除扫描视图:
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.detectImageView.layer sublayers] objectAtIndex:0];
    [layer removeFromSuperlayer];
    
    [super albumButtonClick:sender];
    
}
- (void)shootButtonClick:(UIButton *)sender {
    [self startScanWithSize:300];
}

- (void)requestCoreMLInfo:(UIImage *)image
{
    self.beginTime = CFAbsoluteTimeGetCurrent();
    // 人脸特性信息
    VNDetectBarcodesRequest * detectBarcodesRequest = [[VNDetectBarcodesRequest alloc]  initWithCompletionHandler:self.vNRequestHandle];
    
//    VNBarcodeSymbology
    NSArray *syms = VNDetectBarcodesRequest.supportedSymbologies;
    NSLog(@"%@",[syms description]);
    // init  handler
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage orientation:image.imageOrientation options:@{}];
    [handler performRequests:@[detectBarcodesRequest] error:nil];
    
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
            
            NSLog(@"当前图片的宽度是：%f 高度是：%f,识别耗时是：%f", imageSize.width, imageSize.height, (CFAbsoluteTimeGetCurrent() - strongSelf.beginTime)*1000);
            
            VNDetectBarcodesRequest *detectBarcodesRequest = (VNDetectBarcodesRequest *)request;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               VNBarcodeObservation * observation =[detectBarcodesRequest.results firstObject];
                
                if ([observation.symbology isEqualToString:VNBarcodeSymbologyQR]) {
                    CIQRCodeDescriptor *qrCodeDes = (CIQRCodeDescriptor *) observation.barcodeDescriptor;
                    for (int i= 0;  i< 100; i++) {
                        
                        NSString *result = [[NSString alloc] initWithData:qrCodeDes.errorCorrectedPayload encoding:i];
                        
                        NSLog(@"index is:%d result is:%@",i,result);
                    }
                    
                }
                // UI
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前类型" message:observation.symbology preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
                [strongSelf presentViewController:alert animated:YES completion:nil];
                
                strongSelf.detectImageView.image = strongSelf.detectImage;
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



@end
