//
//  GPUPhotoFIlter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/29.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUPhotoFIlterFilterFragmentShaderString;

@interface GPUImagePhotoFilter : GPUImageFilter
{
    GLuint colorUniform;
    GLuint densityUniform;
    GLuint preserveLuminosityUniform;
}

@property (nonatomic, assign) GPUVector3 color;
@property (nonatomic, assign) float density;
@property (nonatomic, assign) BOOL preserveLuminosity;

- (void)setColorRed:(float)red Green:(float)green Blue:(float)blue;

@end
