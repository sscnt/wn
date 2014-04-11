//
//  GPUWhitebalanceImageFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUAdjustmentsWhiteBalanceFragmentShaderString;

@interface GPUAdjustmentsWhiteBalance : GPUImageFilter
{
    float redWeightUniform;
    float blueWeightUniform;
}

@property (nonatomic, readwrite) float redWeight;
@property (nonatomic, readwrite) float blueWeight;

@end
