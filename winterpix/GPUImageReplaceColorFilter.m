//
//  GPUImageReplaceColorFilter.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageReplaceColorFilter.h"

NSString *const kGPUImageReplaceColorFilterFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float saturation;
 uniform mediump float lightness;
 uniform mediump float selectionColorRed;
 uniform mediump float selectionColorGreen;
 uniform mediump float selectionColorBlue;
 
 vec3 hsv2rgb(vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     int hi = int(mod(float(floor(h / 60.0)), 6.0));
     mediump float f = (h / 60.0) - float(hi);
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
     mediump vec3 v3 = pixel.rgb - vec3(selectionColorRed, selectionColorGreen, selectionColorBlue);
     v3 = v3 * v3;
     mediump float dist = sqrt(v3.x + v3.y + v3.z);
    
     v3 = rgb2hsv(pixel.rgb);
     v3.y += saturation;
     v3.y = max(min(v3.y, 1.0), 0.0);
     v3.z += lightness;
     v3.z = max(min(v3.z, 1.0), 0.0);
     v3 = hsv2rgb(v3);
     
     // Save the result
     gl_FragColor = vec4(v3 * (1.0 - dist) + pixel.rgb * dist, 1.0);
 }
);
 
@implementation GPUImageReplaceColorFilter
 
 - (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageReplaceColorFilterFragmentShaderString]))
    {
        return nil;
    }
    return self;
}

- (void)setSelectionColorRed:(float)red Green:(float)green Blue:(float)blue
{
    [self setFloat:red forUniformName:@"selectionColorRed"];
    [self setFloat:green forUniformName:@"selectionColorGreen"];
    [self setFloat:blue forUniformName:@"selectionColorBlue"];
}

- (void)setSaturation:(float)saturation
{
    [self setFloat:saturation / 100.0f forUniformName:@"saturation"];
}

- (void)setLightness:(float)lightness
{
    [self setFloat:lightness / 100.0f forUniformName:@"lightness"];
}

@end