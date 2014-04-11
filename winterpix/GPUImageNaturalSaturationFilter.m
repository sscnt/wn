//
//  GPUImageNaturalSaturationFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/19.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageNaturalSaturationFilter.h"

@implementation GPUImageNaturalSaturationFilter
NSString *const kGPUImageNaturalSaturationFilterFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float saturation;
 
 vec3 hsv2rgb(vec3 color){
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
 
 vec3 rgb2hsv(vec3 color){
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
 
 void main()
 {
     // Sample the input pixel
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump vec3 hsv = rgb2hsv(pixel.rgb);
     mediump float x = hsv.y * 2.0 - 1.0;
     mediump float y = hsv.x / 90.0;
     mediump float influence = 1.0 - x * x;
     
     hsv.y *= saturation;
     mediump vec3 rgb = hsv2rgb(hsv);
     
     pixel.r = influence * rgb.r + (1.0 - influence) * pixel.r;
     pixel.g = influence * rgb.g + (1.0 - influence) * pixel.g;
     pixel.b = influence * rgb.b + (1.0 - influence) * pixel.b;
     
     // Save the result
     gl_FragColor = pixel;
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageNaturalSaturationFilterFragmentShaderString]))
    {
        return nil;
    }
    
    saturationUniform = [filterProgram uniformIndex:@"saturation"];
    self.saturation = 1.0f;
    return self;
}

- (void)setSaturation:(CGFloat)saturation
{
    _saturation = MAX(MIN(saturation, 1.0), 0.01);
    [self setFloat:saturation forUniform:saturationUniform program:filterProgram];
}
@end
