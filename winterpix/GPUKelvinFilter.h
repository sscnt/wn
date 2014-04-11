//
//  GPUKelvinFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2014/01/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGravyKelvinFragmentShaderString;

@interface GPUKelvinFilter : GPUImageFilter
{
    GLuint kelvinUniform;
    GLuint strengthUniform;
}

@property (nonatomic, assign) float kelvin;
@property (nonatomic, assign) float strength;


@end

