//
//  GPUImageGradientMapFIlter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/26.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageGradientMapFilter.h"

@implementation GPUImageGradientMapFilter

NSString *const kGPUImageGradientMapFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform int stopsCount;
 uniform mediump float locations[20];
 uniform mediump vec4 colors[20];
 uniform mediump float midpoints[20];
 
 int index(float x){
     if(x < 0.0){
         return 0;
     }
     if(x > 1.0){
         return stopsCount - 1;
     }
     mediump float loc = 0.0;
     for(int i = 1;i < 20;i++){
         loc = locations[i];
         if(x < loc){
             return i - 1;
         }
     }
     return 0;
 }
 
 void main()
 {
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump float max = max(pixel.r, max(pixel.g, pixel.b));
     mediump float min = min(pixel.r, min(pixel.g, pixel.b));
     
     mediump float d = (max + min) / 2.0;
     d = 0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b;
     
     int index = index(d);
     mediump float startLocation = locations[index];
     mediump float endLocation = locations[index + 1];
     mediump vec4 startColor = colors[index];
     mediump vec4 endColor = colors[index + 1];
     mediump float midpoint = midpoints[index + 1];
     
     
     mediump float r = startColor.r;
     mediump float g = startColor.g;
     mediump float b = startColor.b;
     mediump float a = startColor.a;
     mediump float rdiff = endColor.r - startColor.r;
     mediump float gdiff = endColor.g - startColor.g;
     mediump float bdiff = endColor.b - startColor.b;
     mediump float adiff = endColor.a - startColor.a;
     mediump float rmid = rdiff / 2.0;
     mediump float gmid = gdiff / 2.0;
     mediump float bmid = bdiff / 2.0;
     mediump float amid = adiff / 2.0;
     
     
     if(d > 1.0){
         r = colors[stopsCount - 1].r;
         g = colors[stopsCount - 1].g;
         b = colors[stopsCount - 1].b;
         a = colors[stopsCount - 1].a;
     } else if(d < 0.0){
         r = startColor.r;
         g = startColor.g;
         b = startColor.b;
         a = startColor.a;
     } else{
         mediump float relativeX;
         relativeX = (d - startLocation) / (endLocation - startLocation);
         if(relativeX > midpoint){
             relativeX = (relativeX - midpoint) / (1.0 - midpoint);
             mediump float weight = -cos(M_PI_2 + relativeX * M_PI_2);
             relativeX = relativeX + (weight - relativeX) * 0.8;
             r += rmid * (relativeX + 1.0);
             g += gmid * (relativeX + 1.0);
             b += bmid * (relativeX + 1.0);
             a += amid * (relativeX + 1.0);
         } else{
             relativeX = relativeX / midpoint;
             mediump float weight = 1.0 - cos(relativeX * M_PI_2);
             relativeX = relativeX + (weight - relativeX) * 0.8;
             r += rmid * relativeX;
             g += gmid * relativeX;
             b += bmid * relativeX;
             a += amid * relativeX;
         }
     }
     
     r = max(0.0, min(1.0, r));
     g = max(0.0, min(1.0, g));
     b = max(0.0, min(1.0, b));
     a = max(0.0, min(1.0, a));
     
     gl_FragColor = vec4(r, g, b, 1.0);   
     
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageGradientMapFilterFragmentShaderString]))
    {
        return nil;
    }
    locationsUniform = [filterProgram uniformIndex:@"locations"];
    colorsUniform = [filterProgram uniformIndex:@"colors"];
    midpointUniform = [filterProgram uniformIndex:@"midpoints"];
    stopsCountUniform = [filterProgram uniformIndex:@"stopsCount"];
    index = 0;
    return self;
}

- (void)addColorRed:(float)red Green:(float)green Blue:(float)blue Opacity:(float)opacity Location:(int)location Midpoint:(int)midpoint
{
    
    GPUVector4 vec = {red / 255.0f, green / 255.0f, blue / 255.0f, opacity / 100.0f};
    colors[index] = vec;
    locations[index] = (float)location / 4096.0f;
    midpoints[index] = (float)midpoint / 100.0f;
    index++;
    
    [self setFloatArray:locations length:20 forUniform:locationsUniform program:filterProgram];
    [self setVec4Array:colors length:20 forUniform:colorsUniform program:filterProgram];
    [self setFloatArray:midpoints length:20 forUniform:midpointUniform program:filterProgram];
    [self setInteger:index forUniform:stopsCountUniform program:filterProgram];
}


@end
