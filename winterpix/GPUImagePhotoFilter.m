//
//  GPUPhotoFIlter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/29.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImagePhotoFilter.h"

@implementation GPUImagePhotoFilter

NSString *const kGPUPhotoFIlterFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform int preserveLuminosity;
 uniform mediump float density;
 uniform mediump vec3 color;
 
 vec3 rgb2hsl(vec3 color){
     mediump float min = min(color.r, min(color.g, color.b));
     mediump float max = max(color.r, max(color.g, color.b));
     mediump float delMax = max - min;
     
     mediump float H = 0.0;
     mediump float S = 0.0;
     mediump float L = (max + min) / 2.0;
     if(delMax != 0.0){
         if(L < 0.5)
             S = delMax / (max + min);
         else
             S = delMax / (2.0 - max - min);
         
         mediump float delR = (((max - color.r) / 6.0) + (delMax / 2.0)) / delMax;
         mediump float delG = (((max - color.g) / 6.0) + (delMax / 2.0)) / delMax;
         mediump float delB = (((max - color.b) / 6.0) + (delMax / 2.0)) / delMax;
         
         if(color.r == max)
             H = delB - delG;
         else if(color.g == max)
             H = (1.0 / 3.0) + delR - delB;
         else if(color.b == max)
             H = (2.0 / 3.0) + delG - delR;
         
         if(H < 0.0)
             H += 1.0;
         if(H > 1.0)
             H -= 1.0;
     }
     
     return vec3(H, S, L);
 }
 
 float hue2rgb(float v1, float v2, float vH){
     if(vH < 0.0) vH += 1.0;
     if(vH > 1.0) vH -= 1.0;
     if((6.0 * vH) < 1.0) return (v1 + (v2 - v1) * 6.0 * vH);
     if((2.0 * vH) < 1.0) return v2;
     if((3.0 * vH) < 2.0) return (v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0);
     return v1;
 }
 
 vec3 hsl2rgb(vec3 hsl){
     mediump float H = hsl.x;
     mediump float S = hsl.y;
     mediump float L = hsl.z;
     
     mediump float R = 0.0;
     mediump float G = 0.0;
     mediump float B = 0.0;
     
     if(S == 0.0){
         R = L;
         G = L;
         B = L;
     } else{
         mediump float var2;
         if(L < 0.5)
             var2 = L * (1.0 + S);
         else
             var2 = (L + S) - (S * L);
         mediump float var1 = 2.0 * L - var2;
         
         R = hue2rgb(var1, var2, H + (1.0 / 3.0));
         G = hue2rgb(var1, var2, H);
         B = hue2rgb(var1, var2, H - (1.0 / 3.0));
     }
     return vec3(R, G, B);
 }
 void main()
 {
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     mediump float min = min(pixel.r, min(pixel.g, pixel.b));
     mediump float max = max(pixel.r, max(pixel.g, pixel.b));
     mediump float lumi = (max + min) / 2.0;
     
     if(preserveLuminosity == 1){
         mediump vec3 rgb = pixel.rgb + color * density;
         mediump vec3 hsl = rgb2hsl(rgb);
         //hsl.z = lumi;
         pixel.rgb = hsl2rgb(hsl);
     } else {
         
     }
     
     gl_FragColor = pixel;
 }
 );


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUPhotoFIlterFilterFragmentShaderString]))
    {
        return nil;
    }
    colorUniform = [filterProgram uniformIndex:@"color"];
    densityUniform = [filterProgram uniformIndex:@"density"];
    self.density = 0.0f;
    preserveLuminosityUniform = [filterProgram uniformIndex:@"preserveLuminosity"];
    self.preserveLuminosity = NO;
    return self;
}

- (void)setColorRed:(float)red Green:(float)green Blue:(float)blue
{
    GPUVector3 color = {red / 255.0f, green / 255.0f, blue / 255.0f};
    self.color = color;
}

- (void)setColor:(GPUVector3)color
{
    [self setVec3:color forUniform:colorUniform program:filterProgram];
}
- (void)setDensity:(float)density
{
    [self setFloat:density forUniform:densityUniform program:filterProgram];
}
- (void)setPreserveLuminosity:(BOOL)preserveLuminosity
{
    [self setInteger:preserveLuminosity forUniform:preserveLuminosityUniform program:filterProgram];
}

@end
