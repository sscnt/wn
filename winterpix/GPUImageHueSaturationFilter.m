//
//  GPUImageHueSaturationFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageHueSaturationFilter.h"

@implementation GPUImageHueSaturationFilter

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageHueSaturationFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform int colorize;
 uniform mediump float hue;
 uniform mediump float saturation;
 uniform mediump float lightness;
 
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
 
 vec3 hsv2rgb(vec3 color){
     mediump float h = color.r;
     mediump float s = color.g;
     mediump float v = color.b;
     mediump float r;
     mediump float g;
     mediump float b;
     mediump float m60 = 0.01666666666;
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
 
 vec3 blend2(vec3 left, vec3 right, float pos){
     return vec3(left.r * (1.0 - pos) + right.r * pos,
                 left.g * (1.0 - pos) + right.g * pos,
                 left.b * (1.0 - pos) + right.b * pos);
 }
 
 vec3 blend3(vec3 left, vec3 main, vec3 right, float pos){
     if(pos < 0.0){
         return blend2(left, main, pos + 1.0);
     }
     if(pos > 0.0){
         return blend2(main, right, pos);
     }
     return main;
 }
 
 float round(float a){
     float b = floor(a);
     b = floor((a - b) * 10.0);
     if(int(b) < 5){
         return floor(a);
     }
     return ceil(a);
 }
 
 void main()
 {
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);

     if(colorize == 1){
         mediump vec3 hsl = rgb2hsl(pixel.rgb);
         hsl.x = hue;
         hsl.y = saturation;
         hsl.z += lightness;
         hsl.z = min(1.0, max(0.0, hsl.z));
         pixel.rgb = hsl2rgb(hsl);
     } else {
         mediump vec3 hsl = rgb2hsl(pixel.rgb);
         hsl.x += hue;
         if(hsl.x < 0.0){
             hsl.x = 1.0 + hsl.x;
         }else if(hsl.x > 1.0){
             hsl.x = hsl.x - 1.0;
         }
         mediump float weight = hsl.y * 2.0 - 1.0;
         weight = 1.0 - weight * weight;
         hsl.y += saturation * weight;
         hsl.y = min(1.0, max(0.0, hsl.y));
         hsl.z += lightness;
         hsl.z = min(1.0, max(0.0, hsl.z));
         pixel.rgb = hsl2rgb(hsl);
     }

     gl_FragColor = pixel;
 }
 );

#else
#endif


- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageHueSaturationFilterFragmentShaderString]))
    {
        return nil;
    }

    hueUniform = [filterProgram uniformIndex:@"hue"];
    self.hue = 0.0f;
    
    saturationUniform = [filterProgram uniformIndex:@"saturation"];
    self.saturation = 0.0f;
    
    lightnessUniform = [filterProgram uniformIndex:@"lightness"];
    self.lightness = 0.0f;
    
    colorizeUniform = [filterProgram uniformIndex:@"colorize"];
    self.colorize = NO;
    
    return self;
}

- (void)setColorize:(BOOL)colorize
{
    _colorize = colorize;
    [self setInteger:_colorize forUniform:colorizeUniform program:filterProgram];
}

- (void)setSaturation:(float)saturation
{
    _saturation = saturation / 100.0f;
    _saturation = MAX(-1.0f, MIN(1.0f, _saturation));
    [self setFloat:_saturation forUniform:saturationUniform program:filterProgram];
}

- (void)setLightness:(float)lightness
{
    _lightness = lightness / 100.0f;
    _lightness = MAX(-1.0f, MIN(1.0f, _lightness));
    [self setFloat:_lightness forUniform:lightnessUniform program:filterProgram];
}

- (void)setHue:(float)hue
{
    _hue = hue / 360.0f;
    _hue = MAX(0.0f, MIN(1.0f, _hue));
    [self setFloat:_hue forUniform:hueUniform program:filterProgram];
}

@end
