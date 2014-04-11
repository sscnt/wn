//
//  GPUKelvinFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2014/01/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUKelvinFilter.h"

@implementation GPUKelvinFilter

NSString *const kGravyKelvinFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float kelvin;
 uniform mediump float strength;
 
 mediump vec3 RGBToHSL(lowp vec3 color)
 {
     mediump vec3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)
     
     mediump float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
     mediump float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
     mediump float delta = fmax - fmin;             //Delta RGB value
     
     hsl.z = (fmax + fmin) / 2.0; // Luminance
     
     if (delta == 0.0)		//This is a gray, no chroma...
     {
         hsl.x = 0.0;	// Hue
         hsl.y = 0.0;	// Saturation
     }
     else                                    //Chromatic data...
     {
         if (hsl.z < 0.5)
             hsl.y = delta / (fmax + fmin); // Saturation
         else
             hsl.y = delta / (2.0 - fmax - fmin); // Saturation
         
         lowp float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
         lowp float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
         lowp float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;
         
         if (color.r == fmax )
             hsl.x = deltaB - deltaG; // Hue
         else if (color.g == fmax)
             hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
         else if (color.b == fmax)
             hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue
         
         if (hsl.x < 0.0)
             hsl.x += 1.0; // Hue
         else if (hsl.x > 1.0)
             hsl.x -= 1.0; // Hue
     }
     
     return hsl;
 }
 mediump float HueToRGB(lowp float f1, lowp float f2, lowp float hue)
 {
     if (hue < 0.0)
         hue += 1.0;
     else if (hue > 1.0)
         hue -= 1.0;
     mediump float res;
     if ((6.0 * hue) < 1.0)
         res = f1 + (f2 - f1) * 6.0 * hue;
     else if ((2.0 * hue) < 1.0)
         res = f2;
     else if ((3.0 * hue) < 2.0)
         res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
     else
         res = f1;
     return res;
 }
 
 mediump vec3 HSLToRGB(lowp vec3 hsl)
 {
     mediump vec3 rgb;
     
     if (hsl.y == 0.0)
         rgb = vec3(hsl.z); // Luminance
     else
     {
         mediump float f2;
         
         if (hsl.z < 0.5)
             f2 = hsl.z * (1.0 + hsl.y);
         else
             f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);
         
         mediump float f1 = 2.0 * hsl.z - f2;
         
         rgb.r = HueToRGB(f1, f2, hsl.x + (1.0/3.0));
         rgb.g = HueToRGB(f1, f2, hsl.x);
         rgb.b= HueToRGB(f1, f2, hsl.x - (1.0/3.0));
     }
     
     return rgb;
 }
 
 void main()
 {
     // Sample the input pixel
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     lowp float fmin = min(min(pixel.r, pixel.g), pixel.b);    //Min. value of RGB
     lowp float fmax = max(max(pixel.r, pixel.g), pixel.b);    //Max. value of RGB
     lowp float delta = fmax - fmin;             //Delta RGB value
     
     mediump float luminance = (fmax + fmin) / 2.0; // Luminance

     mediump float r = 0.0;
     mediump float g = 0.0;
     mediump float b = 0.0;
     
     // Calc red
     if(kelvin <= 66.0){
         r = 255.0;
     }else{
         r = kelvin - 60.0;
         r = 329.698727446 * pow(r, -0.1332047592);
     }
     if(r < 0.0){
         r = 0.0;
     }
     if(r > 255.0){
         r = 255.0;
     }
     
     // Calc green
     if(kelvin <= 66.0){
         g = kelvin;
         g = 99.4708025861 * log(g) - 161.1195681661;
     }else{
         g = kelvin - 60.0;
         g = 288.1221695283 * pow(g, -0.0755148492);
     }
     if(g < 0.0){
         g = 0.0;
     }
     if(g > 255.0){
         g = 255.0;
     }
     
     
     // Calc blue
     if(kelvin >= 66.0){
         b = 255.0;
     }else{
         if(kelvin <= 19.0){
             b = 0.0;
         }else{
             b = kelvin - 10.0;
             b = 138.5177312231 * log(b) - 305.0447927307;
         }
     }
     if(b < 0.0){
         b = 0.0;
     }
     if(b > 255.0){
         b = 255.0;
     }
     
     pixel.r = (1.0 - strength) * pixel.r + r * 0.00392156862 * strength;
     pixel.g = (1.0 - strength) * pixel.g + g * 0.00392156862 * strength;
     pixel.b = (1.0 - strength) * pixel.b + b * 0.00392156862 * strength;
     
     mediump vec3 hsl = RGBToHSL(pixel.rgb);
     hsl.z = luminance;
     pixel.rgb = HSLToRGB(hsl);
     
     
     // Save the result
     gl_FragColor = pixel;
 }
 );

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGravyKelvinFragmentShaderString]))
    {
        return nil;
    }
    
    kelvinUniform = [filterProgram uniformIndex:@"kelvin"];
    self.kelvin = 0;
    strengthUniform = [filterProgram uniformIndex:@"strength"];
    self.strength = 100.0f;
    return self;
}

- (void)setKelvin:(float)kelvin
{
    if(kelvin < 1000.0){
        kelvin = 1000.0f;
    }
    if(kelvin > 40000.0f){
        kelvin = 40000.0f;
    }
    kelvin /= 100.0f;
    _kelvin = kelvin;
    [self setFloat:kelvin forUniform:kelvinUniform program:filterProgram];
}

- (void)setStrength:(float)strength
{
    if(strength > 100.0f){
        strength = 100.0f;
    }
    if(strength < 0.0f){
        strength = 0.0f;
    }
    strength /= 100.0f;
    [self setFloat:strength forUniform:strengthUniform program:filterProgram];
}
@end
