//
//  GPUimageTumblinBrightnessFilter.h
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageTumblinBrightnessFilterFragmentShaderString;

@interface GPUimageTumblinBrightnessFilter : GPUImageFilter
{
    GLuint brightnessUniform;
}

@property (nonatomic, assign) CGFloat brightness;

@end
