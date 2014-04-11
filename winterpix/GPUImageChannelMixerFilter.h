//
//  GPUImageChannelMixerFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/03.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageChannelMixerFilterFragmentShaderString;

@interface GPUImageChannelMixerFilter : GPUImageFilter
{
    GLuint redRedUniform;
    GLuint redGreenUniform;
    GLuint redBlueUniform;
    GLuint redConstantUniform;
    GLuint greenRedUniform;
    GLuint greenGreenUniform;
    GLuint greenBlueUniform;
    GLuint greenConstantUniform;
    GLuint blueRedUniform;
    GLuint blueGreenUniform;
    GLuint blueBlueUniform;
    GLuint blueConstantUniform;
}

/*
 * percent
 * -100 - 100
 */
- (void)setRedChannelRed:(int)red Green:(int)green Blue:(int)blue Constant:(int)constant;
- (void)setGreenChannelRed:(int)red Green:(int)green Blue:(int)blue Constant:(int)constant;
- (void)setBlueChannelRed:(int)red Green:(int)green Blue:(int)blue Constant:(int)constant;

@end
