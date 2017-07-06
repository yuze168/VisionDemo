//
//  VDUtility.m
//  VisionDemo
//
//  Created by 高永祥 on 2017/6/28.
//  Copyright © 2017年 高永祥. All rights reserved.
//

#import "VDUtility.h"

@implementation VDUtility

+ (CGRect)rectFromBoundingBox:(CGRect )boundingBox oriSize:(CGSize)oriSize
{
    
    CGRect rect = CGRectMake(boundingBox.origin.x * oriSize.width,
                                     boundingBox.origin.y * oriSize.height ,
                                     boundingBox.size.width * oriSize.width,
                                     boundingBox.size.height * oriSize.height);
    
    
    return rect;
}

@end
