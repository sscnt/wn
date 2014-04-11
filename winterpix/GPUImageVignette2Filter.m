//
//  GPUImageVignetteFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageVignette2Filter.h"

@implementation GPUImageVignette2Filter

NSString *const kGPUImageVignette2FilterFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float scale;
 
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
     
     mediump float x = textureCoordinate.x - 0.5;
     mediump float y = textureCoordinate.y - 0.5;
     mediump float d = sqrt(x * x + y * y) / sqrt(0.5) * scale;
     d = 1.0 - pow(d * 0.80, 1.2);
     if(d < 0.0){
         d = 0.0;
     }
     
     mediump vec3 yuv = rgb2yuv(pixel.rgb);
     yuv.x *= d;
     mediump vec3 result = yuv2rgb(yuv);
     
     mediump float color;
     
     //// Multiply
     pixel.r = result.r * pixel.r * result.r * (1.0 - d) + d * pixel.r;
     pixel.g = result.g * pixel.g * result.g * (1.0 - d) + d * pixel.g;
     pixel.b = result.b * pixel.b * result.b * (1.0 - d) + d * pixel.b;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageVignette2FilterFragmentShaderString]))
    {
        return nil;
    }
    
    scaleUniform = [filterProgram uniformIndex:@"scale"];
    self.scale = 1.0f;
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self setFloat:scale forUniform:scaleUniform program:filterProgram];
}


@end
