//
//  GPUImageTumblinLevelsFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageTumblinLevelsFilter.h"

/*
 ** Gamma correction
 ** Details: http://blog.mouaif.org/2009/01/22/photoshop-gamma-correction-shader/
 */

#define GammaCorrection(color, gamma)								pow(color, 1.0 / gamma)

/*
 ** Levels control (input (+gamma), output)
 ** Details: http://blog.mouaif.org/2009/01/28/levels-control-shader/
 */

#define LevelsControlInputRange(color, minInput, maxInput)				min(max(color - minInput, vec3(0.0)) / (maxInput - minInput), vec3(1.0))
#define LevelsControlInput(color, minInput, gamma, maxInput)				GammaCorrection(LevelsControlInputRange(color, minInput, maxInput), gamma)
#define LevelsControlOutputRange(color, minOutput, maxOutput) 			mix(minOutput, maxOutput, color)
#define LevelsControl(color, minInput, gamma, maxInput, minOutput, maxOutput) 	LevelsControlOutputRange(LevelsControlInput(color, minInput, gamma, maxInput), minOutput, maxOutput)

NSString *const kGPUImageTumblinLevelsFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform mediump vec3 levelMinimum;
 uniform mediump vec3 levelMiddle;
 uniform mediump vec3 levelMaximum;
 uniform mediump vec3 minOutput;
 uniform mediump vec3 maxOutput;
 
 mediump vec3 rgb2yuv(mediump vec3 rgb){
     mediump float r = rgb.r * 0.8588 + 0.0625;
     mediump float g = rgb.g * 0.8588 + 0.0625;
     mediump float b = rgb.b * 0.8588 + 0.0625;
     
     mediump float y = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump float u = -0.169 * r - 0.331 * g + 0.500 * b;
     mediump float v = 0.500 * r - 0.419 * g - 0.081 * b;
     return vec3(y, u, v);
 }
 
 mediump vec3 yuv2rgb(mediump vec3 yuv){
     mediump float r = yuv.x + 1.402 * yuv.z - 0.0625;
     mediump float g = yuv.x - 0.344 * yuv.y - 0.714 * yuv.z - 0.0625;
     mediump float b = yuv.x + 1.772 * yuv.y - 0.0625;
     
     r *= 1.164;
     g *= 1.164;
     b *= 1.164;
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     return vec3(r, g, b);
 }
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec3 yuv = rgb2yuv(textureColor.rgb);
     mediump float lum = yuv.x;
     mediump float x = lum - 0.3;
     if(x < 0.0){
         x = 0.0;
     }
     mediump float influence = 1.0 - pow(x, 5.0);
     mediump vec3 result = LevelsControl(textureColor.rgb, levelMinimum, levelMiddle, levelMaximum, minOutput, maxOutput);
     yuv = rgb2yuv(result);
     
     result.r = pow(textureColor.r / lum, 0.6) * yuv.x;
     result.g = pow(textureColor.g / lum, 0.6) * yuv.x;
     result.b = pow(textureColor.b / lum, 0.6) * yuv.x;
     
     textureColor.r = influence * result.r + (1.0 - influence) * textureColor.r;
     textureColor.g = influence * result.g + (1.0 - influence) * textureColor.g;
     textureColor.b = influence * result.b + (1.0 - influence) * textureColor.g;
     
     gl_FragColor = textureColor;
 }

 void _main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec3 yuv = rgb2yuv(textureColor.rgb);
     mediump float lum = yuv.x;
     mediump vec3 result = LevelsControl(textureColor.rgb, levelMinimum, levelMiddle, levelMaximum, minOutput, maxOutput);
     yuv = rgb2yuv(result);
     
     textureColor.r = pow(textureColor.r / lum, 0.6) * yuv.x;
     textureColor.g = pow(textureColor.g / lum, 0.6) * yuv.x;
     textureColor.b = pow(textureColor.b / lum, 0.6) * yuv.x;
     
     gl_FragColor = textureColor;
 }
 );


@implementation GPUImageTumblinLevelsFilter

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageTumblinLevelsFragmentShaderString]))
    {
		return nil;
    }
    
    minUniform = [filterProgram uniformIndex:@"levelMinimum"];
    midUniform = [filterProgram uniformIndex:@"levelMiddle"];
    maxUniform = [filterProgram uniformIndex:@"levelMaximum"];
    minOutputUniform = [filterProgram uniformIndex:@"minOutput"];
    maxOutputUniform = [filterProgram uniformIndex:@"maxOutput"];
    
    [self setRedMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    [self setGreenMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    [self setBlueMin:0.0 gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    
    return self;
}

#pragma mark -
#pragma mark Helpers

- (void)updateUniforms {
    [self setVec3:minVector forUniform:minUniform program:filterProgram];
    [self setVec3:midVector forUniform:midUniform program:filterProgram];
    [self setVec3:maxVector forUniform:maxUniform program:filterProgram];
    [self setVec3:minOutputVector forUniform:minOutputUniform program:filterProgram];
    [self setVec3:maxOutputVector forUniform:maxOutputUniform program:filterProgram];
}

#pragma mark -
#pragma mark Accessors

- (void)setMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    [self setRedMin:min gamma:mid max:max minOut:minOut maxOut:maxOut];
    [self setGreenMin:min gamma:mid max:max minOut:minOut maxOut:maxOut];
    [self setBlueMin:min gamma:mid max:max minOut:minOut maxOut:maxOut];
}

- (void)setMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

- (void)setRedMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    minVector.one = min;
    midVector.one = mid;
    maxVector.one = max;
    minOutputVector.one = minOut;
    maxOutputVector.one = maxOut;
    
    [self updateUniforms];
}

- (void)setRedMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setRedMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

- (void)setGreenMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    minVector.two = min;
    midVector.two = mid;
    maxVector.two = max;
    minOutputVector.two = minOut;
    maxOutputVector.two = maxOut;
    
    [self updateUniforms];
}

- (void)setGreenMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setGreenMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

- (void)setBlueMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut {
    minVector.three = min;
    midVector.three = mid;
    maxVector.three = max;
    minOutputVector.three = minOut;
    maxOutputVector.three = maxOut;
    
    [self updateUniforms];
}

- (void)setBlueMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max {
    [self setBlueMin:min gamma:mid max:max minOut:0.0 maxOut:1.0];
}

@end
