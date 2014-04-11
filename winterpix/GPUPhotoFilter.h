//
//  GPUPhotoFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2014/01/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGravyPhotoFilterFragmentShaderString;

@interface GPUPhotoFilter : GPUImageFilter
{
    GLuint redUniform;
    GLuint greenUniform;
    GLuint blueUniform;
    GLuint strengthUniform;
}

@property (nonatomic, readwrite) float red;
@property (nonatomic, readwrite) float green;
@property (nonatomic, readwrite) float blue;
@property (nonatomic, readwrite) float strength;

- (void)setRed:(float)red Green:(float)green Blue:(float)blue;

@end
