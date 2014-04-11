//
//  GPUWhitebalanceImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUAdjustmentsWhiteBalance.h"

@implementation GPUAdjustmentsWhiteBalance

NSString *const kGPUAdjustmentsWhiteBalanceFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float redWeight;
 uniform mediump float blueWeight;
 
 
 vec3 rgb2hsv(const in vec3 color){
     mediump float r = color.r;
     mediump float g = color.g;
     mediump float b = color.b;
     
     
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     mediump float h = 0.0;
     if(max < min){
         max = 0.0;
         min = 0.0;
     }
     
     if(max == min){
         
     } else if(max == r){
         h = 60.0 * (g - b) / (max - min);
     } else if(max == g){
         h = 60.0 * (b - r) / (max - min) + 120.0;
     } else if(max == b){
         h = 60.0 * (r - g) / (max - min) + 240.0;
     }
     if(h < 0.0){
         h += 360.0;
     }
     h = mod(h, 360.0);
     
     mediump float s;
     if(max == 0.0) {
         s = 0.0;
     } else {
         s = (max - min) / max;
     }
     mediump float v = max;
     
     return vec3(h, s, v);
 }
 
 vec3 hsv2rgb(const in vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     mediump float m60 = 0.01665;
     int hi = int(mod(float(floor(h * m60)), 6.0));
     mediump float f = (h * m60) - float(hi);
     mediump float p = v * (1.0 - s);
     mediump float q = v * (1.0 - s * f);
     mediump float t = v * (1.0 - s * (1.0 - f));
     
     if(hi == 0){
         r = v;
         g = t;
         b = p;
     } else if(hi == 1){
         r = q;
         g = v;
         b = p;
     } else if(hi == 2){
         r = p;
         g = v;
         b = t;
     } else if(hi == 3){
         r = p;
         g = q;
         b = v;
     } else if(hi == 4){
         r = t;
         g = p;
         b = v;
     } else if(hi == 5){
         r = v;
         g = p;
         b = q;
     } else {
         r = v;
         g = t;
         b = p;
     }
     return vec3(r, g, b);
     
 }

 void main()
 {
     // Sample the input pixel
     mediump vec4 pixel = texture2D(inputImageTexture, textureCoordinate);
     mediump float r = pixel.r ;
     mediump float g = pixel.g;
     mediump float b = pixel.b ;
     
     mediump float max = max(r, max(g, b));
     mediump float min = min(r, min(g, b));
     if(max < min){
         max = 0.0;
     }
     
     mediump vec3 hsv = rgb2hsv(vec3(r, g, b));
     mediump float weight = sqrt(hsv.y);
     r += redWeight * weight;
     b += blueWeight * weight;
     
     hsv.z = max;
     mediump vec3 rgb = vec3(r, g, b);
     
     // Save the result
     gl_FragColor = vec4(rgb, 1.0);
 }
 );

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUAdjustmentsWhiteBalanceFragmentShaderString]))
    {
        return nil;
    }
    
    redWeightUniform = [filterProgram uniformIndex:@"redWeight"];
    self.redWeight = 0.0f;
    
    blueWeightUniform = [filterProgram uniformIndex:@"blueWeight"];
    self.blueWeight = 0.0f;
    
    return self;
}

- (void)setRedWeight:(float)redWeight
{
    _redWeight = redWeight;
    [self setFloat:_redWeight forUniform:redWeightUniform program:filterProgram];
}

- (void)setBlueWeight:(float)blueWeight
{
    _blueWeight = blueWeight;
    [self setFloat:_blueWeight forUniform:blueWeightUniform program:filterProgram];
}

@end
