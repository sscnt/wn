//
//  GPUImageVignetteFilter.h
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageVignette2FilterFragmentShaderString;

@interface GPUImageVignette2Filter : GPUImageFilter
{
    GLuint scaleUniform;
}

@property (nonatomic, assign) CGFloat scale;

@end
