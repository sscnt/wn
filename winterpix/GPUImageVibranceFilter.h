//
//  GPUImageVibranceFilter.h
//  Vintage
//
//  Created by SSC on 2014/02/19.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

@interface GPUImageVibranceFilter : GPUImageFilter
{
    GLuint vibranceUniform;
}

@property (nonatomic, assign) CGFloat vibrance;


@end
