//
//  GPUImageNaturalSaturationFilter.h
//  Vintage
//
//  Created by SSC on 2014/02/19.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

@interface GPUImageNaturalSaturationFilter : GPUImageFilter
{
    GLuint saturationUniform;
}

@property (nonatomic, assign) CGFloat saturation;


@end
