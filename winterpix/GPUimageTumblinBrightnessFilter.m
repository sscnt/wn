//
//  GPUimageTumblinBrightnessFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUimageTumblinBrightnessFilter.h"

@implementation GPUimageTumblinBrightnessFilter

NSString *const kGPUImageTumblinBrightnessFilterFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float brightness;
 
 vec3 rgb2yuv(vec3 rgb){
     mediump float r = rgb.r * 0.8588 + 0.0625;
     mediump float g = rgb.g * 0.8588 + 0.0625;
     mediump float b = rgb.b * 0.8588 + 0.0625;
     
     mediump float y = 0.299 * r + 0.587 * g + 0.114 * b;
     mediump float u = -0.169 * r - 0.331 * g + 0.500 * b;
     mediump float v = 0.500 * r - 0.419 * g - 0.081 * b;
     return vec3(y, u, v);
 }
 
 vec3 yuv2rgb(vec3 yuv){
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
     // Sample the input pixel
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump vec3 yuv = rgb2yuv(pixel.rgb);
     mediump float lum = yuv.x;
     yuv.x += brightness;
     if(yuv.x > 1.0){
         yuv.x = 1.0;
     }else if(yuv.x < 0.0){
         yuv.x = 0.0;
     }
     if(brightness > 0.0){
         pixel.r = pow(pixel.r / lum, 0.6) * yuv.x;
         pixel.g = pow(pixel.g / lum, 0.6) * yuv.x;
         pixel.b = pow(pixel.b / lum, 0.6) * yuv.x;
     }else{
         pixel.rgb = yuv2rgb(yuv);
     }
     
     gl_FragColor = pixel;
 }
 );

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageTumblinBrightnessFilterFragmentShaderString]))
    {
        return nil;
    }
    
    brightnessUniform = [filterProgram uniformIndex:@"brightness"];
    self.brightness = 0.0f;
    return self;
}

- (void)setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setFloat:brightness forUniform:brightnessUniform program:filterProgram];
}

@end
