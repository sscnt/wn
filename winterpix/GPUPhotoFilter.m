//
//  GPUPhotoFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2014/01/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUPhotoFilter.h"

@implementation GPUPhotoFilter

NSString *const kGravyPhotoFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float red;
 uniform mediump float green;
 uniform mediump float blue;
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
     
     /*
     pixel.r = (1.0 - strength) * pixel.r + red * strength;
     pixel.g = (1.0 - strength) * pixel.g + green * strength;
     pixel.b = (1.0 - strength) * pixel.b + blue * strength;
      */
     
     pixel.r = (1.0 - strength) * pixel.r + red * pixel.r * strength;
     pixel.g = (1.0 - strength) * pixel.g + green * pixel.g * strength;
     pixel.b = (1.0 - strength) * pixel.b + blue * pixel.b * strength;
     
     mediump vec3 hsl = RGBToHSL(pixel.rgb);
     hsl.z = luminance;
     pixel.rgb = HSLToRGB(hsl);
     
     
     // Save the result
     gl_FragColor = pixel;
 }
 );

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGravyPhotoFilterFragmentShaderString]))
    {
        return nil;
    }
    
    redUniform = [filterProgram uniformIndex:@"red"];
    self.red = 0;
    greenUniform = [filterProgram uniformIndex:@"green"];
    self.green = 0;
    blueUniform = [filterProgram uniformIndex:@"blue"];
    self.blue = 0;
    strengthUniform = [filterProgram uniformIndex:@"strength"];
    self.strength = 100.0f;
    return self;
}

- (void)setStrength:(float)strength
{
    strength /= 100.0f;
    [self setFloat:strength forUniform:strengthUniform program:filterProgram];
}

- (void)setRed:(float)red
{
    red = MIN(1.0f, MAX(0.0f, red));
    [self setFloat:red forUniform:redUniform program:filterProgram];
}

- (void)setGreen:(float)green
{
    green = MIN(1.0f, MAX(0.0f, green));
    [self setFloat:green forUniform:greenUniform program:filterProgram];
    
}

- (void)setBlue:(float)blue
{
    blue = MIN(1.0f, MAX(0.0f, blue));
    [self setFloat:blue forUniform:blueUniform program:filterProgram];
    
}

- (void)setRed:(float)red Green:(float)green Blue:(float)blue
{
    [self setRed:red];
    [self setGreen:green];
    [self setBlue:blue];
}

@end
