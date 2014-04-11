//
//  GPUImageColorBalanceFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/12.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

@interface GPUImageColorBalanceFilter : GPUImageFilter
{
    GLint shadowsUniform;
    GLint midtonesUniform;
    GLint highlightsUniform;
    GLint preserveLuminosityUniform;
}

@property(readwrite, nonatomic) GPUVector3 shadows;
@property(readwrite, nonatomic) GPUVector3 midtones;
@property(readwrite, nonatomic) GPUVector3 highlights;
@property(readwrite, nonatomic) BOOL preserveLuminosity;

@end
