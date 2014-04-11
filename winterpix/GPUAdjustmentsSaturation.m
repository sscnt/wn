//
//  GPUSaturationImageFilter.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUAdjustmentsSaturation.h"

@implementation GPUAdjustmentsSaturation

NSString *const kGPUAdjustmentsSaturationFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float vibrance;
 uniform mediump float saturation;
 
 float round(float a){
     float b = floor(a);
     b = floor((a - b) * 10.0);
     if(int(b) < 5){
         return floor(a);
     }
     return ceil(a);
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
 
 vec3 rgb2hsv2(vec3 color){
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
 
 vec3 hsv2rgb2(vec3 color){
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
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     mediump vec3 hsv = rgb2hsv(pixel.rgb);
     mediump float increase = (1.0 - abs(hsv.y * 2.0 - 1.0)) * (1.0 - abs(hsv.z * 2.0 - 1.0)) * 0.4 * saturation;
     
     mediump vec3 redHsv = rgb2hsv2(vec3(1.0, 84.0/255.0, 0.0));
     mediump float diff = abs(hsv.x - redHsv.x);
     if(diff > 180.0){
         diff = 360.0 - diff;
     }
     mediump float redsWeight = (1.0 - max(0.0, min(1.0, diff / 90.0))) * hsv.y;
     
     hsv.y += increase * ((1.0 - redsWeight) * 0.7 + 0.3);

     
     mediump float x = textureCoordinate.x;
     mediump float y = textureCoordinate.y;
     mediump float d = sqrt((0.5 - x) * (0.5 - x) + (0.5 - y) * (0.5 - y));
     if(vibrance >= 0.0){
         d -= 0.707107 * (1.0 - vibrance);
         d /= 0.707107;
         d = max(0.0, min(1.0, d));
         increase = 1.0 * (1.0 - cos(d * 1.5707963));
         hsv.z -= increase;
         hsv.z = max(0.0, hsv.z);
         pixel.rgb = hsv2rgb(hsv);
     } else{
         // Contrast
         mediump vec3 rgb = hsv2rgb2(hsv);
         mediump float contrast = 1.0 - vibrance * 0.2;
         contrast *= contrast;
         
         mediump float value;
         value = rgb.r;
         value -= 0.5;
         value *= contrast;
         value += 0.5;
         rgb.r = min(1.0, max(0.0, value));
         
         value = rgb.b;
         value -= 0.5;
         value *= contrast;
         value += 0.5;
         rgb.b = min(1.0, max(0.0, value));
         
         value = rgb.g;
         value -= 0.5;
         value *= contrast;
         value += 0.5;
         rgb.g = min(1.0, max(0.0, value));
         pixel.rgb = rgb;

         
     }
     
     
     // Save the result
     gl_FragColor = pixel;
 }
 );

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUAdjustmentsSaturationFragmentShaderString]))
    {
        return nil;
    }
    saturationUniform = [filterProgram uniformIndex:@"saturation"];
    self.saturation = 0.0;
    vibranceUniform = [filterProgram uniformIndex:@"vibrance"];
    self.vibrance = 0.0;
    return self;
}

- (void)setSaturation:(float)saturation
{
    _saturation = MAX(-1.0f, MIN(1.0f, saturation));
    [self setFloat:_saturation forUniform:saturationUniform program:filterProgram];
}

- (void)setVibrance:(float)vibrance
{
    _vibrance = MAX(-1.0, MIN(1.0, vibrance));
    [self setFloat:_vibrance forUniform:vibranceUniform program:filterProgram];
}

@end
