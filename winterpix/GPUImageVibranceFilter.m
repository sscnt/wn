//
//  GPUImageVibranceFilter.m
//  Vintage
//
//  Created by SSC on 2014/02/19.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUImageVibranceFilter.h"

@implementation GPUImageVibranceFilter
NSString *const kGPUImageVibranceFilterFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform mediump float vibrance;
 
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
 
 vec3 rgb2xyz(mediump vec3 color){
     mat3 adobe;
     adobe[0] = vec3(0.576669, 0.297345, 0.027031);
     adobe[1] = vec3(0.185558, 0.627364, 0.070689);
     adobe[2] = vec3(0.188229, 0.075291, 0.991338);
     mat3 srgb;
     srgb[0] = vec3(0.412391, 0.212639, 0.019331);
     srgb[1] = vec3(0.357584, 0.715169, 0.119195);
     srgb[2] = vec3(0.180481, 0.072192, 0.950532);
     return adobe * color;
 }
 
 vec3 xyz2rgb(mediump vec3 color){
     mat3 adobe;
     adobe[0] = vec3(2.041588, -0.969244, 0.013444);
     adobe[1] = vec3(-0.565007, 1.875968, -0.118362);
     adobe[2] = vec3(-0.344731, 0.041555, 1.015175);
     mat3 srgb;
     srgb[0] = vec3(3.240970 , -0.969244  , 0.055630 );
     srgb[1] = vec3(-1.537383 , 1.875968  , -0.203977  );
     srgb[2] = vec3(-0.498611, 0.041555, 1.056972);
     return adobe * color;
 }
 
 float xyz2labFt(mediump float t){
     if(t > 0.00885645167){
         return 116.0 * pow(t, 0.33333333333) - 16.0;
     } else{
         return 903.296296296 * t;
     }
 }
 
 vec3 xyz2lab(mediump vec3 color){
     mediump float l = xyz2labFt(color.y);
     mediump float a = 4.31034482759 * (xyz2labFt(color.x / 0.9642) - l);
     mediump float b = 1.72413793103 * (l - xyz2labFt(color.z / 0.8249));
     return vec3(l, a, b);
 }
 
 vec3 lab2xyz(mediump vec3 color){
     mediump float fy = (color.x + 16.0) / 116.0;
     mediump float fx = fy + (color.y / 500.0);
     mediump float fz = fy - (color.z / 200.0);
     mediump float x;
     mediump float y;
     mediump float z;
     if(fy > 0.20689655172)
         y = fy * fy * fy;
     else
         y = 0.00110705645 * (116.0 * fy - 16.0);
     if(fx > 0.20689655172)
         x = fx * fx * fx * 0.9642;
     else
         x = 0.00110705645 * (116.0 * fx - 16.0) * 0.9642;
     if(fz > 0.20689655172)
         z = fz * fz * fz * 0.8249 ;
     else
         z = 0.00110705645 * (116.0 * fz - 16.0) * 0.8249;
     return vec3(x, y, z);
 }
 
 vec3 rgb2lab(mediump vec3 color){
     return xyz2lab(rgb2xyz(color));
 }
 
 vec3 lab2rgb(mediump vec3 color){
     return xyz2rgb(lab2xyz(color));
 }
 
 void main()
 {
     // Sample the input pixel
     mediump vec4 pixel   = texture2D(inputImageTexture, textureCoordinate);
     
     mediump vec3 hsv = rgb2hsv(pixel.rgb);
     mediump float x = hsv.y * 2.0 - 1.0;
     mediump float y = hsv.x / 90.0;
     mediump float influence = 1.0 - x * x;
     
     mediump vec3 lab = rgb2lab(pixel.rgb);
     mediump vec3 baselab = rgb2lab(vec3(252.0/255.0, 226.0/255.0, 196.0/255.0));
     mediump float skin_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     skin_distance /= 376.0;
     
     baselab = rgb2lab(vec3(1.0, 0.5, 0.0));
     mediump float red_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     red_distance /= 376.0;
     
     baselab = rgb2lab(vec3(0.0, 1.0, 0.0));
     mediump float green_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     green_distance /= 376.0;
     
     baselab = rgb2lab(vec3(0.0, 0.0, 1.0));
     mediump float blue_distance = sqrt((lab.x - baselab.x) * (lab.x - baselab.x) + (lab.y - baselab.y) * (lab.y - baselab.y) + (lab.z - baselab.z) * (lab.z - baselab.z));
     blue_distance /= 376.0;
     
     mediump float distance = (skin_distance + red_distance) / (blue_distance + green_distance);
     distance = max(min(distance, 1.0), 0.0);
     
     influence *= distance;
     hsv.y *= vibrance;
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
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageVibranceFilterFragmentShaderString]))
    {
        return nil;
    }
    
    vibranceUniform = [filterProgram uniformIndex:@"vibrance"];
    self.vibrance = 1.0f;
    return self;
}

- (void)setVibrance:(CGFloat)vibrance
{
    _vibrance = MAX(MIN(vibrance, 2.0), 0.01);
    [self setFloat:vibrance forUniform:vibranceUniform program:filterProgram];
}


@end
