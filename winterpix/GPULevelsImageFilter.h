//
//  GPULevelsImageFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGravyLevelsFragmentShaderString;

@interface GPULevelsImageFilter : GPUImageFilter
{
    GLuint lvLowWeightUniform;
    GLuint lvMidWeightUniform;
    GLuint lvHighWeightUniform;
    GLuint histLowestValueUniform;
    GLuint histHighestValueUniform;
    
    GLuint diffHighAndMidUniform;
    GLuint diffMidAndLowUniform;
    
    GLuint mtplHMUniform;
    GLuint mtplMLUniform;
    
    GLuint sigmoidUniform;
}

@property (nonatomic, readwrite) float lvLowWeight;
@property (nonatomic, readwrite) float lvMidWeight;
@property (nonatomic, readwrite) float lvHighWeight;
@property (nonatomic, readwrite) float histLowestValue;
@property (nonatomic, readwrite) float histHighestValue;

@property (nonatomic, readwrite) float diffHighAndMid;
@property (nonatomic, readwrite) float diffMidAndLow;

@property (nonatomic, readwrite) float mtplHM;
@property (nonatomic, readwrite) float mtplML;

@property (nonatomic, readwrite) int sigmoid;

@end
