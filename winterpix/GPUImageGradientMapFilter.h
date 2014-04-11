//
//  GPUImageGradientMapFIlter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"


extern NSString *const kGPUImageGradientMapFilterFragmentShaderString;

@interface GPUImageGradientMapFilter : GPUImageFilter
{
    
    GLuint locationsUniform;
    GLuint midpointUniform;
    GLuint colorsUniform;
    GLuint stopsCountUniform;
    
    int index;
    float locations[20];
    GPUVector4 colors[20];
    float midpoints[20];
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint;

@end
